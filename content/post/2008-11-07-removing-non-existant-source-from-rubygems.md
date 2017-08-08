---
title: "Removing non-existent source from rubygems"
slug: removing-non-existant-source-from-rubygems
author: "Caius Durling"
date: 2008-11-07 06:08:28 +0000
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "bug"
  - "fix"
  - "cli"
  - "catch 22"
  - "gem"
  - "rubygems"
---

I just came to move some ruby scripts onto my mac mini, and to do so I needed to install a couple of gems. Now I realised I hadn't installed or updated rubygems on the machine for a while, so I figured it was best to update `gem` before installing the gems I wanted. Easier said than done.

At some point in the past I had added `http://gems.datamapper.org` as a source to rubygems. Since then the datamapper project has discontinued using this gem source to serve up gems, so I was getting the following output:

    mm:daemons caius$ sudo gem update --system
    Updating installed gems
    Bulk updating Gem source index for: http://gems.rubyforge.org/
    ERROR:  While executing gem ... (Gem::RemoteSourceException)
        HTTP Response 404 fetching http://gems.datamapper.org/yaml

Eeek! I can't update because the source no longer exists. So I figured I'd remove the source before updating, that should work right? Wrong. It updates the sources before removing the source from the config it would appear.

    mm:daemons caius$ sudo gem sources
    ** CURRENT SOURCES ***

    http://gems.rubyforge.org
    http://gems.datamapper.org
    
    mm:daemons caius$ sudo gem sources -r http://gems.datamapper.org
    Bulk updating Gem source index for: http://gems.rubyforge.org/
    ERROR:  While executing gem ... (Gem::RemoteSourceException)
        HTTP Response 404 fetching http://gems.datamapper.org/yaml
    
Oh balls. So how do I remove the source without updating it first. I need to update it to remove it, but to remove it I need to update from it. Gotta love catch 22s!

I remembered that `gem install` has an option not to update sources, `--no-update-sources`. So I figured thats gotta work when removing a source as well, but it doesn't.

    mm:daemons caius$ sudo gem sources -r http://gems.datamapper.org --no-update-sources
    ERROR:  While executing gem ... (OptionParser::InvalidOption)
        invalid option: --no-update-sources

Oh crap. Now what do I do? Take my usual tactic and google for a hint of course! I'd considered trying to find where the gem config was and remove the source by hand, but I figured that wouldn't be that simple. After hitting a couple of sites that weren't relevant I ended up [on the edge of complexity][complex] where he mentions the command `nano ~/.gemrc`. Which made me wonder if that file contains the sources.

[complex]: http://jaigouk.blogspot.com/2008/07/404-fetching-httpgemsdatamapperorgyaml.html

    mm:daemons caius$ cat ~/.gemrc
    --- 
    :update_sources: true
    :verbose: true
    :bulk_threshold: 1000
    :sources: 
    - http://gems.rubyforge.org
    - http://gems.datamapper.org
    :backtrace: false
    :benchmark: false

All I needed to do was remove the `- http://gems.datamapper.org` line and *poof*, `gem` was working again. One quick `gem update --system` later and I was upgraded from gem 1.1.1 to 1.3.1 and installing the gems I needed.
