---
title: "Use datamapper sessions with merb & datamapper"
slug: use-datamapper-sessions-with-merb-datamapper
author: "Caius Durling"
date: 2008-02-05 20:27:31 +0000
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "merb"
  - "datamapper"
  - "merb_datamapper"
  - "code"
  - "bug"
  - "fix"
---

### Issue

Can't use merb sessions with datamapper & mysql, get back an error about needing an id on the text column or something (I had the error a couple of days ago.)

### Solution

I suggest grabbing merb_datamapper svn source to fix this in.  To do so make sure you have subversion installed on your machine (I'm assuming a Unix based machine here.)

1. Checkout the source 

        svn co http://svn.devjavu.com/merb/plugins/merb_datamapper

2. Open up the affected file in your favourite editor *(I use TextMate)*

        cd merb_datamapper
        mate lib/merb/sessions/data_mapper_session.rb

3. Find line 25 that contains

        `property :session_id, :text, :lazy => false, :key => true`

    and remove `:text, :lazy => false` to replace it with `:string`

        `property :session_id, :string, :key => true`

    Save and close the file, thats the editing done.  Now to install the gem.

4. Build the gem

        rake gem

5. Install the gem

        sudo gem install pkg/merb_datamapper-0.5.gem

And you're away with the fix installed.  Now just run `merb` to create your sessions table in the db.  Hope this helped!
