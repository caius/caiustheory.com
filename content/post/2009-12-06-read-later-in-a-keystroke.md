---
title: "Read Later in a keystroke"
author: "Caius Durling"
date: 2009-12-06 22:15:37 +0000
tag:
  - "geek"
  - "fix"
  - "apple"
  - "safari"
  - "mac"
  - "hack"
  - "menubar"
  - "instapaper"
  - "webkit"
  - "read later"
  - "bookmarklet"
  - "key bindings"
  - "system preferences"
---

I use a wonderful service for saving text to be read later, [instapaper.com][insta]. It's gotten more wonderful as time has gone on and other applications/service's have gained the ability to save links/articles/webpages there for me to pick up later.

[insta]: http://instapaper.com/

For instance, I'm out and about checking twitter on my iPhone using [tweetie][] and someone tweets a link. Rather than wait for it to load and having to read it then and there I can just hit "Read Later" and it's saved in my instapaper account for me to read as and when I choose to. Recently the legendary mac feed reader [NetNewsWire][nnw] gained this ability too.

[tweetie]: http://atebits.com/tweetie-iphone/
[nnw]: http://www.newsgator.com/INDIVIDUALS/NETNEWSWIRE/

There's a few ways to send a feed item to instapaper from within NNW. Firstly you can right-click and click "Send to Instapaper".

![Send to Instapaper from contextual menu](http://farm3.static.flickr.com/2553/4163576297_ee60e26b53_o.jpg)  
[View Original on Flickr](http://www.flickr.com/photos/caius/4163576297)

Secondly there's a menu item for it in the News menu, which also provides my chosen way of instapapering an item&mdash;the keyboard shortcut! ⌃P *(control-P)*.

![Send to Instapaper from News menu](http://farm3.static.flickr.com/2748/4164341910_476f8ba539_o.jpg)  
[View Original on Flickr](http://www.flickr.com/photos/caius/4164341910)

So, in NNW I'm happily sending stuff to instapaper with the handy ⌃P shortcut, but that doesn't exist in the third place I mark things to read later--Safari! Up until now I've been using the standard "Read Later" bookmarklet that [instapaper.com][insta] provides, and it's got a spot on my Bookmarks Bar so I can easily click it.

That doesn't really help with the fact I'm hitting ⌃P in NNW, and it doesn't work in Safari. Quite often I noticed myself hitting the key combination in Safari and wondering for a split second why it wasn't sending the item to instapaper. Then the solution hit me!

In OS X you can setup (and/or override) menu items with custom key combinations! Why hadn't I remembered this before. Because the "Read Later" bookmark*(let)* is nested under the Bookmarks menu, it **is** a menu item! A quick trip into the Keyboards Prefpane in System Preferences and a new binding later and voilâ, "Read Later" in Safari is bound to ⌃P and I can use it in both Safari and NNW.

![Filling in the form to bind the keyboard shortcut](http://farm3.static.flickr.com/2517/4163642801_a14250da65_o.jpg)  
[View Original on Flickr](http://www.flickr.com/photos/caius/4163642801)
