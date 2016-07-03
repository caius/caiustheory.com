---
title: "Add to iCloud Reading List programmatically"
author: "Caius Durling"
date: 2013-12-16 22:26:31 +0000
tags:
  - "geek"
  - "code"
  - "fix"
  - "cli"
  - "apple"
  - "safari"
  - "instapaper"
  - "applescript"
  - "osascript"
  - "reading list"
---

One piece of a larger puzzle I'm trying to solve currently, was how to add a given URL to my Apple "[Reading List][]" that is stored in iCloud and synced across all my OS X and iOS devices. More specifically, I wanted to add URLs to the list from my mac running Mavericks (10.9). I had a quick look at the Cocoa APIs and couldn't see anything in OS X to do this. (iOS has an API to do it from Cocoa-land it seems though.)

[Reading List]: http://www.apple.com/uk/safari/#icloud

I figured [Safari.app][Safari] was the key to getting this done on OS X, given it has the ability itself to add the current page to the reading list, either via a keyboard command, a menu item, or a button in the address bar. One quick mental leap later, and I was wondering if the engineers at Apple had been nice enough to expose that via Applescript for me to take advantage of.

[Safari]: http://www.apple.com/uk/safari/

One quick stop in "Script Editor.app" later, and I had the Applescript dictionary open for Safari.app. Lo and behold, there is rather handily an Applescript command called "add reading list item", which does **exactly** what I want. It has a few different options you can call it with, depending on whether you want Safari to go populate the title & preview text, or if you want to specify it yourself at save-time.

As I want to be able to call this from multiple runtimes, I've chosen to save it as an executable, which leans on [`osascript`][osascript] to run the actual Applescript. And here it is:

[osascript]: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/osascript.1.html

```applescript
#!/usr/bin/env osascript

on run argv
    if (count of argv) > 0
        tell app "Safari" to add reading list item (item 1 of argv as text)
    end if
end run
```

Save it as whatever you want (eg. `add_to_reading_list`), make it executable (`chmod +x add_to_reading_list`), and then run it with the URL you want saving as the first argument.

    $ add_to_reading_list "http://caius.name/"
    $ add_to_reading_list "http://google.com/"
    # … etc …

*(Adding support for specifying preview text and title is left as an exercise for the reader!)*

Have fun reading later!
