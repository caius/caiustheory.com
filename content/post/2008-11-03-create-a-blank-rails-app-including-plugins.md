---
title: "Create a blank rails app including plugins"
author: "Caius Durling"
date: 2008-11-03 06:48:27 +0000
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "rails"
  - "rspec"
  - "cucumber"
  - "webrat"
---

When I create a rails app from scratch I like to include certain plugins to help me write the app, such as the *Rspec* testing framework instead of the built-in *Test::Unit* and *jQuery* instead of *prototype*.

* [Rspec](http://rspec.info/)
* [Rspec-rails](http://github.com/rahoulb/rspec-rails/wikis) *(NB: I use [rahoul](http://3hv.co.uk)'s fork of rspec-rails)*
* [Cucumber](http://github.com/aslakhellesoy/cucumber/wikis)
* [Webrat](http://github.com/brynary/webrat/wikis)
* [jRails](http://ennerchi.com/projects/jrails)
* [Demeters Revenge](http://plugins.code.lukeredpath.co.uk/browser/demeters_revenge/trunk)

And here are the commands in the order I run them to create the blank app.

    # Create the rails app
    cd ~/Sites/apps/
    rails myapp
    cd myapp

    # Setup a git repo
    git init
    # Add all files and make the initial import
    git add .
    git commit -m "Initial Import"

    # Add the plugins as git submodules
    git submodule add git://github.com/dchelimsky/rspec.git vendor/plugins/rspec
    git submodule add git://github.com/rahoulb/rspec-rails.git vendor/plugins/rspec-rails
    git submodule add git://github.com/aslakhellesoy/cucumber.git vendor/plugins/cucumber
    git submodule add git://github.com/brynary/webrat.git vendor/plugins/webrat
    git submodule add git://github.com/caius/demeters_revenge.git vendor/plugins/demeters_revenge

    # Commit the changes
    git ci -am "Adding all needed submodules"

    # Replace TestUnit with rspec
    git rm -r test/
    ruby script/generate rspec
    # Replace stories with cucumber features
    rm -rf stories/
    ruby script/generate cucumber

    # Add the changes to git
    git add .
    git ci -m "Committing initial rspec/cucumber files"

    # Install jRails, we have to install it using script/plugin
    # Remove existing javascript files
    git rm public/javascripts/*
    mkdir public/javascripts
    # Add jrails
    ruby script/plugin install http://ennerchi.googlecode.com/svn/trunk/plugins/jrails
    git add vendor/plugins/jrails/ public/javascripts
    git ci -m "Adding jRails to replace Prototype"

And now you have a blank app waiting for you to write using features for full stack testing, and rspec for testing model and controller code.

#### Updated 2008-11-04

Added demeters revenge and jRails plugins.

#### Update 2008-11-05

I've also blogged the [.gitignore][gi] file I use with rails apps as well. Usually add it into my apps before running `git init`

[gi]: http://swedishcampground.com/setting-up-git-with-rails-apps
