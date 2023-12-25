---
title: "Ruby retry keyword pattern"
date: 2023-12-25T17:09:00Z
draft: true
author: "Caius Durling"
tag:
  - ruby
  - pattern
---

When raising errors (or calling things that raise errors) in Ruby, we sometimes want to retry the same code in case it works again. Specifically this is retrying within a tight loop, without leaning on a background job system or some other asynchronous delayed execution mechanism.

Lets pretend we're using a library that wraps an external call, and the first time we call it in a script it'll raise an error, so we can wrap this in a `begin/rescue` block and handle calling it a second time:

```ruby
begin
  Library.fetch(title: "To Kill A Mockingbird")
rescue => e
  e # => #<Library::ResponseError message="Unexpected server error" success=false>
  Library.fetch(title: "To Kill A Mockingbird")
end
```

Once we start testing this though we realise the error responses are more intermittent and sometimes we need to call the library three times before we get a response. Whilst the external service is working on their stability internally, we just want to wrap the error handling to call it four times and only let the error bubble out in our code if it fails five times in a row.

We could just write a bunch of nested rescue blocks, but that's tedious, we're copying data (the title string) through all of them and it's a lot of visual noise. Changing the retry behaviour (eg, only retry twice) is also quite a large edit to the file in future too.
