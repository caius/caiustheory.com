---
title: "Safari 4 Hidden Preferences"
author: "Caius Durling"
date: 2009-02-24 16:11:05 +0000
lastmod: "2010-11-18T14:14:14+0000"
tag:
  - "geek"
  - "programming"
  - "apple"
  - "objective-c"
---

**Updated 2009-06-09:** This post is for the Safari 4 **beta** and will not work with the new Safari 4 released yesterday at the WWDC keynote. I've had a look through that release and can't see any way to revert the address bar, etc sorry.

* * * *

Having a quick poke through the new Safari binary yields the following strings:

    $ strings /Applications/Safari.app/Contents/MacOS/Safari | grep DebugSafari4
    DebugSafari4TabBarIsOnTop
    DebugSafari4IncludeToolbarRedesign
    DebugSafari4IncludeFancyURLCompletionList
    DebugSafari4IncludeGoogleSuggest
    DebugSafari4LoadProgressStyle
    DebugSafari4IncludeFlowViewInBookmarksView
    DebugSafari4TopSitesZoomToPageAnimationDimsSnapshot
    DebugSafari4IncludeTopSites

*NB: Run these commands in Terminal.app and then you need to restart Safari for them to take effect.*

### DebugSafari4TabBarIsOnTop

This moves the tab bar back where you expect it to be:

    $ defaults write com.apple.Safari DebugSafari4TabBarIsOnTop -bool NO

### DebugSafari4IncludeToolbarRedesign and DebugSafari4LoadProgressStyle

When both set to NO it restores the blue loading bar behind the URL. *Also puts a page loading spinner in the tab itself, which looks odd with the new tabs.*

    $ defaults write com.apple.Safari DebugSafari4IncludeToolbarRedesign -bool NO
    $ defaults write com.apple.Safari DebugSafari4LoadProgressStyle -bool NO

### DebugSafari4IncludeFancyURLCompletionList

Switches off the new URL autocomplete menu and goes back to the original one.

    $ defaults write com.apple.Safari DebugSafari4IncludeFancyURLCompletionList -bool NO

### DebugSafari4IncludeGoogleSuggest

Turns off the new Google suggest menu.

    $ defaults write com.apple.Safari DebugSafari4IncludeGoogleSuggest -bool NO

### DebugSafari4IncludeFlowViewInBookmarksView

Removes CoverFlow from the Bookmarks view entirely. ([Credit][] to [Erik][])

[Credit]: http://twitter.com/iacas/status/1245800183
[Erik]: http://nslog.com/

    $ defaults write com.apple.Safari DebugSafari4IncludeFlowViewInBookmarksView -bool NO

### DebugSafari4TopSitesZoomToPageAnimationDimsSnapshot

Disables the dimming when you click on a Top Site and it scales the screenshot up to fill the screen.

    $ defaults write com.apple.Safari DebugSafari4TopSitesZoomToPageAnimationDimsSnapshot -bool NO

### DebugSafari4IncludeTopSites

Disables Top Sites feature completely.

    $ defaults write com.apple.Safari DebugSafari4IncludeTopSites -bool NO

## Undoing changes

Just run the defaults command with the `delete` flag for the appropriate key you wish to delete.

    $ defaults delete com.apple.Safari <key>

*NB: Don't include the `-bool NO` at the end, it just requires the key (eg: "DebugSafari4IncludeGoogleSuggest")*

### Update 2009-02-26

[Jools points out in the comments][jools] how to reset the recent searches in the google search box.

[jools]: http://swedishcampground.com/safari-4-hidden-preferences#comment-3265

### Update 2009-05-26

Lowell's kindly created a Mac OS X application to edit these settings without using Terminal. <http://github.com/cocoastep/tweaky>

### Update 2010-11-18

Patric has kindly [translated this post into Belorussian](http://www.movavi.com/opensource/safari-4-hidden-preferences-be) and posted it on his site.
