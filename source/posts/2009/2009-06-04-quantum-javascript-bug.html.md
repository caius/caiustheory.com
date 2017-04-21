---
title: "Quantum Javascript Bug"
author: "Caius Durling"
date: 2009-06-04 15:12:24 +0000
tags:
  - "geek"
  - "code"
  - "bug"
  - "fix"
  - "javascript"
  - "firefox"
  - "safari"
  - "firebug"
---

So I've got some js I've written to update a couple of `<select>` lists in a form, and it was all working fine for me (under Safari.) [John][] happened to mention it wasn't working for him under Firefox, so I fired up Firefox and took a look. Could reproduce it perfectly, changing the first popup was populating the second one, but then wasn't selecting the right value from the list.

[John]: http://johnleach.co.uk/

Having no idea what was happened I figured I'd enable firebug and watch it execute to figure out what was happening. Enabled firebug, reloaded the page, selected from the first popup… and **voila!** It updated the second one and selected the correct row! WTF!!!

Turned firebug off and it didn't work, turned it back on and it worked. Figured it might be something buggy in the Firefox 3.0.5 js runtime, so I grabbed a copy of the new [beta 3.5][fx beta] and tried it in there—still failed to update the page as it should.

[fx beta]: http://www.mozilla.com/en-US/firefox/all-beta.html

Then started poking around the javascript code, the function that was seemingly failing to run was being triggered by a setTimeout() call set to 1 second. We figured it might be the timing causing it, so started playing around with the time, tried anything from ½ a second up to 4 seconds but still no joy in firefox with firebug turned off.

Then [John][] went looking for the javascript errors in firefox (with firebug off) and discovered that it was throwing an error because `window.console` didn't exist. All of a sudden it made perfect sense! Safari has `window.console.log()` for writing to the console log, as does firebug. But of course firefox *without* firebug doesn't!

So the function was just exiting on that error. It was very weird initially to have it work perfectly as soon as the developer tools were enabled!
