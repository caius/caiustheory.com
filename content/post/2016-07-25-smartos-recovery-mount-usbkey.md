---
title: SmartOS Recovery mount /usbkey
slug: smartos-recovery-mount-usbkey
date: 2016-07-25 17:59:00
tag:
  - fix
  - geek
  - SmartOS
---

Recently I managed to hose a box in a perfectly self-inflicted storm of idiocy. Imagine a SmartOS server with the following issues:

* Root password not noted down anywhere
* `/usbkey/config` edited badly, meaning the network settings are wrong
* Rebooting the server to apply some other settings

Needless to say, this caused a tiny issue in the server doing what it's supposed to. Luckily I had access to a KVM remote console for the box and the following worked.

I brought the machine up, choosing the second option for recovery at the grub menu. Waited for a login prompt, then logged in with `root`/`root`.

Realised quite quickly that `/usbkey` must be persisted on the `zones` zfs pool otherwise the configuration would be lost after shutdown, so imported the correct pool, created a directory to mount into and then mounted the zfs share.

```shell
zpool import zones
mkdir /usbkey
mount -F zfs zones/usbkey /usbkey
```
