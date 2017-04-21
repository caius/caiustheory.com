---
title: "Solve volume down button not working on iPhone 5"
author: "Caius Durling"
date: 2014-07-01 11:31:39 +0000
tags:
  - "apple"
  - "iphone"
  - "iOS"
---

I noticed this morning that my volume down button (-) wasn't working on my iPhone 5 running iOS 7. Pushing the physical button in didn't change the volume. The volume up button increased the volume successfully still.

As is my normal first step debugging iPhone weirdness, I rebooted the phone by turning it off, leaving it off for a few seconds, then booting it back up with the power button. Once powered off and on in this way, the volume down key still didn't decrease the volume.

Fearing a physical button issue at this point, I turned to google for suggestions on what else to try. Running across [this thread](https://discussions.apple.com/thread/4894152) on Apple's discussion forums, I tried out the solution in there.

1. Open "Settings"
2. Scroll down and tap on "General"
3. Tap on "Accessibility"
4. Scroll down to the bottom and tap on "AssistiveTouch"
5. Tap the toggle for AssistiveTouch to turn it on, and you should see a little icon appear on screen (white circle contained in a dark grey rounded square)
6. Tap the AssistiveTouch icon (was in the top left corner on screen for me)
7. Tap on "Device"
8. Tap "Volume Down" a bunch of times and you should see the volume being turned down
9. Tap outside the AssistiveTouch dialog to close it
10. Try pushing the physical Volume Down button

In my case, following these steps made my physical volume down button start working again. Makes me wonder if the solution author on the apple discussion thread is right, in that this is a software issue and forcing a volume down action through the on-screen interface makes it remember that there's a physical button to respond to as well.

Either way, I can stop deafening myself whenever I receive a notification now!
