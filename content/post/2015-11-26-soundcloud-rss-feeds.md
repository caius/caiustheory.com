---
title: "SoundCloud RSS Feeds"
author: "Caius Durling"
date: 2015-11-26 23:33:37 +0000
tag:
    - bookmarklet
    - geek
    - soundcloud
---

[SoundCloud][] appears to have gained popularity in recent times for hosting podcasts on. As a consumer of their service they're pretty good at everything except having a visible RSS feed on a profile page for a show! If I want to listen to a show in my podcast app of choice, an RSS feed is the easiest way for me to achieve that.

[SoundCloud]: https://soundcloud.com

Turns out SoundCloud *do* have RSS feeds, they're just well hidden and unfindable from the profile page itself. Thankfully, you can construct the URL for it from information on the profile page, and here's a bookmarklet that will do it for you:

    javascript:var%20userURI;var%20metaTags=document.getElementsByTagName(
    %22meta%22);for(var%20i=0;i<metaTags.length;i++){t=metaTags[i];if(
    t.attributes[%22property%22]&&t.attributes[%22property%22].value==
    %22al:ios:url%22){userURI=t.content;}}if(userURI){u=userURI.split(%22//%22)[1];
    window.location=%22http://feeds.soundcloud.com/users/soundcloud:%22+u+
    %22/sounds.rss%22;}

Or as a [handy link][link] to copy to your bookmarks bar. Simply click/run that when on a SoundCloud profile page and you'll be taken to the RSS Feed URL.

[link]: javascript:var%20userURI;var%20metaTags=document.getElementsByTagName(%22meta%22);for(var%20i=0;i<metaTags.length;i++){t=metaTags[i];if(t.attributes[%22property%22]&&t.attributes[%22property%22].value==%22al:ios:url%22){userURI=t.content;}}if(userURI){u=userURI.split(%22//%22)[1];window.location=%22http://feeds.soundcloud.com/users/soundcloud:%22+u+%22/sounds.rss%22;}
