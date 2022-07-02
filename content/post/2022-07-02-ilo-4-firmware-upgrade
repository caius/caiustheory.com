---
title: "iLO 4 Firmware Upgrade"
date: 2022-07-02T11:01:01Z
tag:
  - hp
  - microserver
  - upgrade
---

HP Microserver Gen8 machines have a HP iLo 4 built in for remote hands management. These are effectively a separate, embedded computer inside the server[^1], which also means it has it's own software (firmware) running on it and needs updating separately.

HP are still releasing firmware updates for the iLo 4, and whilst it's possible to update them from inside the host OS on the server, you can also do it by uploading the firmware directly to the iLO. I prefer this method as my servers are almost never running the correct operating system to update from the host[^2].

The easiest way to get ahold of the firmware is to extract it from the Red Hat linux host package, we're after a `.bin` file inside the `.rpm` package HP make available for downloading.

At the time of writing the latest firmware release is v2.8.0, released 2022-04-08, available [on HP's support site here](https://support.hpe.com/connect/s/softwaredetails?language=en_US&softwareId=MTX_d08e4968119e4737b8549928c2) (no login required). Click "View Download Files (2)" and then pick the one ending in `.rpm` (`firmware-ilo4-2.80-1.1.i386.rpm` at time of writing.)

Once downloaded, we can unpack the `rpm` using the `rpm2cpio` tool and then `cpio` to output the files on disk for us.

```shell
rpm2cpio firmware-ilo4-2.80-1.1.i386.rpm | clio -idmv
```

The file we're after is nested inside a few directories in the unpacked directory. You can find it under `usr/lib/i386-linux-gnu/firmware-ilo4-2.80-1.1/` named `ilo4_280.bin` (at time of writing. Version numbers might differ in future.)

Once you have that `bin` file on disk, go to your iLO web interface and login. Navigate to "Administration" in the sidebar, then select the "Firmware" tab. Pick the `bin` file from the file picker and click Upload.

Wait for flashing to complete and the iLO to restart. If you've upgraded from < 2.78 then you'll get a new UI as part of the upgrade which looks better and works just as well as the old one. It also adds new functionality, like a HTML5 remote console rather than having to download a `.jar` file to take remote control of the machine.

[^1]: out the box at least. The iLo can be configured to share eth0 with the host instead I believe.
[^2]: I think both Windows and Red Hat linux are supported for this.
