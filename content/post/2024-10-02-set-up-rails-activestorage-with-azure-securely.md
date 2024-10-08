---
title: "Set Up Rails Activestorage With Azure Securely"
date: 2024-10-02T22:28:49+0100
author: Caius Durling
tag:
  - "Azure"
  - "ClickOps"
  - "Rails"
  - "Ruby"
---

[Ruby on Rails][] has built-in support for managing uploaded files with [ActiveStorage][], which both cleans up your application code and acts as an abstraction over different storage backends. Azure Storage is one of the supported backends, but configuring it securely can take a little figuring out.

[Ruby on Rails]: https://rubyonrails.org
[ActiveStorage]: https://github.com/rails/rails/tree/main/activestorage#readme

The most sensible way I've found to have it configured is with files stored having no public access, but allowing temporary access via signed URLs for both uploads & downloads. ActiveStorage happily generates these URLs for us which makes it easy for developers to use and transparent to users, whilst keeping their data as secure and protected as possible. From a technical point of view, this also allows upload and download between Azure Storage and the user's browser, without proxying all the data through your Rails app.

### Azure setup

We'll be storing the files in Azure as blobs within [Azure Blob Storage][]. Blobs live within a Storage Container which lives within a Storage Account, which is created in a specific geographical region and Resource Group.

[Azure Blob Storage]: https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction

To create the above, we'll need access to an Azure Subscription with permissions to create the resources. (Most of the time you will already be an admin on the subscription, so can ignore checking this. If you get permission errors creating the below, you'll need to go talk to your admin.)

Most resources in Azure need to live within a Resource Group, which it's suggested you use to group related resources together. If there isn't already a resource group for your application resources, create one.

Next we need to create a Storage Account in the main location for the app and nested in the Resource Group from above. The following settings are split across multiple pages, click "Next" to advance to next bit of the form:

-   **Storage account name**: 3-24 numbers/lowercase letters only, unique across all storage accounts globally in Azure. Good luck. (eg, `st123someappproduksth`)
-   **Region**: choose for your app location (eg, UK South)
-   **Performance**: Standard (general purpose v2 account)
-   **Redundancy**: Zone-redundant storage (ZRS) if possible. (Some regions don't support it, choose Locally-redundant storage (LRS) in those.)
-   **Enable infrastructure encryption**: Check the box, it's free.
-   **Tags**: tag the resource according to your internal conventions/policies (eg, `terraform:false`)

Create the Storage Account and wait for it to complete. Next we'll create the Storage Container nested under the Storage Account which is where our actual files will be uploaded to. Find the Storage Account we created in the portal and click "Containers" in the sidebar, then "+ Container" above the table listing the containers.

Add a sensible name for the Container, which is easier because there are [fewer restrictions on this name][container-name-docs]. (eg, `dragon-myapp-production-uksouth-activestorage`.) Create the container and wait for that to complete.

[container-name-docs]: https://learn.microsoft.com/en-us/rest/api/storageservices/naming-and-referencing-containers--blobs--and-metadata#container-names

Navigate back to viewing the Storage Account and select "Access Keys" in the sidebar. Make a note of the Key value (for key1) for use later configuring Rails. If you need to rotate the access keys later without causing an outage, you can update the app to use the Key from key2 and then rotate the key for key1 from the UI.

The final configuration we might need to set in Azure is allowing direct uploads from our app to the container. Due to this being client-side requests we need the Cross-Origin Resource Sharing (CORS) headers to allow this from Azure's side. Without these in place you will get permissions errors from browsers trying to make requests directly to Azure. If you're not using ActiveStorage's Direct Upload feature, you can skip this.

Find "Resource Sharing (CORS)" in the sidebar for the Storage Account. Add a new entry to the "Blob service" table:

-   Allowed origins: comma-separated list of all your app domains using this storage.
-   Allowed methods: `GET`, `POST`, `OPTIONS`, `PUT`
-   Allowed headers: \*
-   Exposed headers: \*
-   Max age: 0

Click out of the fields and the configuration will be saved automagically. (Little green ticks appear in the fields for some visual feedback.)

### Rails setup

We can follow the Rails documentation for [setting up ActiveStorage][rails activestorage setup], ensures you have the migrations for the required database tables installed and the framework is loaded in your application.

[rails activestorage setup]: https://guides.rubyonrails.org/active_storage_overview.html#setup

Follow the rails docs [for configuring `config/storage.yml` with Azure][rails azure config], and pulling `azure-storage-blob` into your app. (In Rails 8.1 this will be `azure-blob` instead, see [test double's post on the subject for more information][azure-blob-post]) I suggest storing the key in Rails credentials (or however you inject secrets into your rails app), and creating a new block in `storage.yml` for Azure storage. Using credentials per-environment makes using a different storage account for Staging & Production easy.

[rails azure config]: https://guides.rubyonrails.org/active_storage_overview.html#microsoft-azure-storage-service
[azure-blob-post]: https://testdouble.com/insights/azure-blob-a-new-ruby-gem-for-azure-blob-storage

```yaml
azure_storage:
    service: "AzureStorage"
    storage_account_name: "<%= Rails.application.credentials.dig(:azure_storage, :storage_account_name) %>"
    storage_access_key: "<%= Rails.application.credentials.dig(:azure_storage, :storage_access_key) %>"
    container: "<%= Rails.application.credentials.dig(:azure_storage, :container_name) %>"
```

Edit the credentials for the given environment (eg, `bin/rails credentials:edit --environment=production`) and enter the values we got from Azure above:

```yaml
azure_storage:
    storage_account_name: "st123someappproduksth"
    storage_access_key: "Qm9yZWQgeWV0PyBGdWNraW5nIGJhbGxhY2hlIGlubml0Lgo="
    container_name: "dragon-myapp-production-uksouth-activestorage"
```

Update the appropriate `config/environments/*.rb` file for the environments you want to use this Azure storage, setting `config.active_storage.service` to the key of the block in `storage.yml`.

```ruby
config.active_storage.service = :azure_storage
```

Deploy your changes, and you're good to start using ActiveStorage to manage your uploaded files. Ensure the ActiveStorage JS is added to your frontend (depends on which asset pipeline flavour the app is configured to use, should be there by default) and you won't be sending all files through your Rails backend, saves you some bandwidth and CPU cycles.
