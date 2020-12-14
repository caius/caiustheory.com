---
title: "Disable Google Autoupdater on macOS"
date: 2020-12-14T16:14:53Z
author: Caius Durling
tag:
  - Chrome
  - Google
  - Hack
  - Mac
---

From reading [Chrome is Bad][], it seems in some situations the updater (also known as keystone) can chew up CPU cycles. Whilst I'm not 100% convinced keystone continuously chews CPU, its launchctl configuration suggests it runs at least once an hour. Given I don't use Chrome as my main browser, this is undesirable behaviour for me.

[Chrome is Bad]: https://chromeisbad.com

Here's how I've disabled the background services on my machine, whilst preventing Chrome from just "reinstalling" the services next time it opens. The services on my machine are installed under my user, so I'm running `launchctl` without `sudo`, and the files are in `~/Library`.

0. Unload the currently loaded services

```shell
launchctl unload -w ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
launchctl unload -w ~/Library/LaunchAgents/com.google.keystone.agent.plist
```

0. Empty the config files, which we'll leave in place to block them being re-written

```shell
echo > ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
echo > ~/Library/LaunchAgents/com.google.keystone.agent.plist
```

0. Change ownership and permissions of these files so only root can write to the files. This prevents Chrome running as my user from updating the files and loading the services again.

```shell
chmod 644 ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
chmod 644 ~/Library/LaunchAgents/com.google.keystone.agent.plist
sudo chown root ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
sudo chown root ~/Library/LaunchAgents/com.google.keystone.agent.plist
```

Now when I want to update Chrome once in a blue moon when I need it, I can navigate to <chrome://settings/help> to update (or from the UI, Chrome -> About Chrome.)
