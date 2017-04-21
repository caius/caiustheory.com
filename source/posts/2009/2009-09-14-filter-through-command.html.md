---
title: "Filter through command"
author: "Caius Durling"
date: 2009-09-14 22:39:37 +0000
tags:
  - "geek"
  - "ruby"
  - "code"
  - "apple"
  - "os x"
  - "mac"
  - "textmate"
---

*This is another old post that I'm republishing. Originally published 27th April 2007.*

My text editor [TextMate][TM] has a nice feature called "Filter through command" whereby you can filter the current document through a command.

[TM]: http://macromates.com/

Anyway, I've never used it before, but today I had a text file with 30 or so url's in, each on a new line, so I thought I'd test it out.  I selected it to input the document & to not replace the output.  I then entered the following command, which is a ruby command to take each line that isn't blank, and run the shell command `open $url`.

```shell
ruby -e 'a = ARGF.read.scan(/\S+/); a.each { |x| `open #{x}` }'
```

What this does is take ARGF (the document) and read it in line by line, but only the non-whitespace characters (so newlines, space, etc are ignored.)  And it assigns it to an array called `a`.  What I then do is for each item of `a`, we run it past the shell command `open`, which on OS X if you pass it a URL it just opens that URL in the default browser.

My browser is Safari, and its set to open new links in a new tab in the foremost window.  So I ran the command, and hey presto, within a few seconds I had all the URL's loading in seperate tabs in Safari's foremost window!

The power of Unix *(OS X)* & TextMate (amongst other tools) just never ceases to amaze me.

**Update**

I just realised if you change the regex to scan for http://.* then it'll select all website URLs.

```shell
ruby -e 'a = ARGF.read.scan(/^http://.*$/); a.each { |url| `open #{url}` }'
```
