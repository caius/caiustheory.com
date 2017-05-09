---
title: Finding cheap Microserver G8 memory
date: 2017-05-09T19:03:00Z
tags:
  - hardware
  - mac
  - microserver
---

I've been wanting to drop more memory in my [HP Microserver G8][], but hoping to find a cheaper alternative to buying new sticks from [Crucial][]. I needed one or two 4GB sticks, but they had to be ECC of course.

[HP Microserver G8]: https://www.hpe.com/uk/en/product-catalog/servers/proliant-servers/pip.hpe-proliant-microserver-gen8.5379860.html
[Crucial]: http://uk.crucial.com/gbr/en/

At the time of writing (May 2017), [Crucial's offering for the G8](http://uk.crucial.com/gbr/en/compatible-upgrade-for/HP-Compaq/proliant-microserver-gen8) shows a 4GB stick to be £43.19, and an 8GB stick to be £81.59. This was a little more than I wanted to pay, but I was struggling to find anything on eBay or Amazon UK that I could be sure was ECC, and also cheaper.

Eventually I wondered what else had compatible memory, after all this isn't a bespoke machine. It should share the same memory specifications as plenty of other machines. The spec I was looking for was:

* DDR3 240-Pin UDIMM
* ECC
* 1600Mhz (or faster)
* 4 or 8GB sticks

After a little while of searching, I happened to find the previous Mac Pro (ie. the tower, not the trashcan) also uses that specification of memory. One quick search on eBay and up turned someone selling off his 4GB sticks where he'd upgrade his Mac Pro to 8GB sticks across the board. £29 for 2x 4GB sticks is better than I was hoping for, and once fitted in the Microserver they work flawlessly.

(The onboard management software warns me that some processor features are disabled because I'm not using HP Approved memory, but it also logged that warning when I *was* using HP Approved memory previously and the machine worked perfectly then. No doubt it's to make IT Managers who don't like warnings spend more money with HP.)
