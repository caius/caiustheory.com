---
title: "TweetSavr"
author: "Caius Durling"
date: 2011-10-22 12:05:39 +0000
tags:
  - "twitter"
  - "geek"
  - "ruby"
  - "programming"
  - "code"
  - "fix"
  - "hack"
  - "YAML"
---

I've had a dream for a while. A simple webapp that takes the last tweet in a conversation and outputs that conversation in chronological order on a page you can link to forevermore. Occasionally I'll google to see if anything new's turned up, but they all seem to do far more, require the start and end tweets or are covered in ads.

So one friday evening I just built it. It's called [TweetSavr](http://tweetsavr.com/). It's very simple—to the point the error page is just a standard 500 server error page currently. It fetches, caches and displays a conversation, given just the last tweet in said conversation.

KISS extends to the interface as well, I'm quite a fan of [URL hacking](http://jerz.setonhill.edu/writing/etext/url-hacking.htm) to use webapps, so TweetSavr works on that basis as well. The homepage sort of has some help telling you how to use it, but you basically take the (old-twitter) URL of the last tweet and paste it after tweetsavr.com in the address bar. Eg, <http://tweetsavr.com/http://twitter.com/ElizabethN/status/19766711653765120>. It'll then redirect you through to the actual page for that conversation. You can also put just the status id on the end of the URL, <http://tweetsavr.com/19766711653765120> and hey presto, it loads.

The caching layer is moderately rudimentary, after fetching a tweet that isn't in the cache it writes out a hash of data for that tweet into a yaml file. And when looking up a tweet it checks to see if that file exists, reading it in from disk if it is. Bonus side-effect is it builds up a corpus of tweets as yaml files on disk.

It lives on the internet at <http://tweetsavr.com/> and the source is on github at <http://github.com/caius/tweetsavr>

Side note: isn't it wonderful what we can create given just a few hours, a server somewhere in the cloud, and an idea? Never ceases to amaze me what can be built in just a short amount of time, even the dead simple things.

