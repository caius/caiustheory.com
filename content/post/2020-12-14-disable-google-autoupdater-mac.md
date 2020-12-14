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

With that in mind, I've decided to disable the background services rather than delete Chrome entirely. (I need it occasionally.) Stopping/unloading the services and fettling the config files to do nothing achieves this aim (and stops Chrome re-enabling them next launch), whilst leaving Chrome fully functional when needed.

0. Unload the currently loaded services

    ```shell
    launchctl unload -w ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
    launchctl unload -w ~/Library/LaunchAgents/com.google.keystone.agent.plist
    ```

0. Empty the config files, so if launchd ever tries to launch them they'll just error out

    ```shell
    echo > ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
    echo > ~/Library/LaunchAgents/com.google.keystone.agent.plist
    ```

0. Change ownership and permissions of these files so only root can write to the files

    ```shell
    chmod 644 ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
    chmod 644 ~/Library/LaunchAgents/com.google.keystone.agent.plist
    sudo chown root ~/Library/LaunchAgents/com.google.keystone.xpcservice.plist
    sudo chown root ~/Library/LaunchAgents/com.google.keystone.agent.plist
    ```

Now when I want to update Chrome once in a blue moon when I need it, I can navigate to <chrome://settings/help> to update (or from the UI, Chrome -> About Chrome.)
