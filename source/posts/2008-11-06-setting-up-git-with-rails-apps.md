---
title: "Setting up git with rails apps"
author: "Caius Durling"
created_at: 2008-11-06 13:03:02 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "code"
  - "rails"
  - "git"
---

When I create a new rails app, I'm constantly going back to another project and stealing the `.gitignore` file from it to make sure that git doesn't know about certain files rails either updates frequently, or stores machine-specific data in. The latter is generally just `config/database.yml`, because I develop alongside my colleagues at [Brightbox][] and we deploy via [capistrano][cap], we always put the `database.yml` file in the shared directory on the server, so we each have our own version with our local credentials in it locally. And thus we don't want it to be tracked by git.

[Brightbox]: http://brightbox.co.uk/ "Brightbox - Serious Rails Hosting"
[cap]: http://www.capify.org/

Here's what I've collated from various sources over the few weeks I've been using git + rails everyday.

#### .gitignore

    config/database.yml
    log/*.log
    tmp/*

    # OS X only
    .DS_Store
    **/.DS_Store

Then to make sure `log/` and `tmp/` are tracked, I just add a blank .gitignore file in them.

    touch log/.gitignore
    touch tmp/.gitignore
