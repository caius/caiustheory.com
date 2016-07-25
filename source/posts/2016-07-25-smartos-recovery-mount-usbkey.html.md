---
title: SmartOS Recovery mount /usbkey
date: 2016-07-25 17:59 UTC
tags:
  - SmartOS
  - fix
  - geek
---

Recently I managed to hose a box in a perfectly self-inflicted storm of idiocy. Imagine a SmartOS server with the following issues:

* Root password not noted down anywhere
* `/usbkey/config` edited badly, meaning the network settings are wrong
* Rebooting the server to apply some other settings

Needless to say, this caused a tiny issue in the server doing what it's supposed to. Luckily I had access to a KVM remote console for the box and the following worked.

Bring the machine up or reboot it if it's already running and during the boot menu selection, choose the Recovery Mode boot option (second entry usually). Wait for the login prompt to appear and login with `root`/`root`.

You then need to mount `/usbkey` so you can edit the configs, which firstly means importing the zfs pool it resides on, then mounting the share.

```shell
zpool import zones
mkdir /usbkey
mount -F zfs zones/usbkey /usbkey
```
