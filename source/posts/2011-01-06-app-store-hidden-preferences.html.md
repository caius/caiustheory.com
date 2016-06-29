---
title: "App Store Hidden Preferences"
author: "Caius Durling"
date: 2011-01-06 19:45:49 +0000
tags:
  - "geek"
  - "fix"
  - "modification"
  - "apple"
  - "mac"
  - "hack"
  - "mac app store"
  - "app store"
  - "defaults"
  - "terminal"
  - "strings"
  - "hidden preferences"
---

*See the Update at the end before you get excited :(*

Having just installed 10.6.6 to use the Mac App Store, I was [slightly annoyed][tweet] that it fills my dock with apps as I install them. I'm a bit strange, in that I use a hidden preference to make the dock uneditable (it stops me accidentally dragging an app off.) But that means I can't drag off the Mac App Store installed apps either.

[tweet]: http://twitter.com/Caius/status/23096911170899968

Had a quick look through `/Applications/App Store.app/Contents/MacOS/App Store` with `strings` (love that tool) and noted a few strings that looked interesting. (There's a full list [in this gist][gist].) There wasn't anything that explicitly stated it stopped it putting anything in the dock, but I did notice an option that stopped it showing **install progress** in the dock.

[gist]: https://gist.github.com/768442

Yank up a terminal window, bash out the following...

    defaults write com.apple.appstore FRDebugShowInstallProgress -bool NO

...head back to the MAS and install another (free) app, and hey presto, it's leaving my dock alone! Hopefully that's all I needed to continue using my Dock as I like. (Hidden, and left alone.)

**Update 2011-01-06:**

Seems my joy was short-lived. I'd re-downloaded an app I'd already purchased and it just showed download progress in the MAS app, not in the dock. Installing new applications still shows up in the dock (annoyingly.)

I've been having a poke through how it all hangs together, and if it's possible to actually block downloads from the Dock or not. It doesn't look like there's a hidden preference to hide new apps from downloading in the dock, you can just disable the progress bars in the dock with prefs. The MAS.app seems to be codenamed "Firenze", with [the "hidden" prefs][firenzeprefs] being prefixed with "FRDebug".

[firenzeprefs]: https://gist.github.com/768829

As I understand it, the App\ Store.app invokes a binary inside `/System/Library/PrivateFrameworks/CommerceKit.framework` called "storeagent" to do the actual downloading/talking to the dock. From looking at the [class-dump][storeagentdump] of storeagent it communicates with the dock to place a new type of DockTile. Interesting sounding methods to (potentially?) swizzle are `-[DownloadQueue sendDownloadListToDock]` and `-[DownloadQueue tellDockToAddDownload:]`.

[storeagentdump]: https://gist.github.com/768837

I've given up for now, but I reckon it should be possible to create a bundle that swizzles the right methods in storeagent to stop it placing the downloads on the Dock.
