---
title: Compiling SmartOS for AMD processors
date: 2014-09-28 10:00:00
tag:
  - SmartOS
  - cli
  - tech
  - geek
---

There's a few community-provided patches for SmartOS that enable KVM on AMD processors amongst other things, and given the HP Microserver has an AMD processor, that's quite useful for turning it into a better lab server. The main [list of so called "eait" builds][eait builds] was hiccuping when I tried to download the latest, and all I could find was a 20140812T062241Z image [here][eait mirror].

[eait builds]: http://imgapi.uqcloud.net/builds
[eait mirror]: http://builds.smartos.skylime.net

The source code for the eait builds is maintained at <https://github.com/arekinath/smartos-live>, and you can see the patches applied on top of the normal SmartOS master by going to <https://github.com/arekinath/smartos-live/compare/joyent:master...eait>.

So here's how to use SmartOS to compile a more up to date AMD-friendly Smartos!

1. Grab the latest multiarch SmartOS image (which **has** to be used, or the compile will fail.) The latest at the time of writing was `4aec529c-55f9-11e3-868e-a37707fcbe86`, so that's what I'll use.

        imgadm import 4aec529c-55f9-11e3-868e-a37707fcbe86

2. Spin up a zone for us to build in (the [Building SmartOS on SmartOS](http://wiki.smartos.org/display/DOC/Building+SmartOS+on+SmartOS) page has extra info about this):

        echo '{
          "alias": "platform-builder",
          "brand": "joyent",
          "dataset_uuid": "4aec529c-55f9-11e3-868e-a37707fcbe86",
          "max_physical_memory": 32768,
          "quota": 0,
          "tmpfs": 8192,
          "fs_allowed": "ufs,pcfs,tmpfs",
          "maintain_resolvers": true,
          "resolvers": [
            "8.8.8.8",
            "8.8.4.4"
          ],
          "nics": [
            {
              "nic_tag": "admin",
              "ip": "dhcp",
              "primary": true
            }
          ],
          "internal_metadata": {
            "root_pw": "password",
            "admin_pw": "password"
          }
        }' | vmadm create

3. Login to the created zone:

        zlogin <uuid from `vmadm create` output>

4. Update the image to the latest packages, etc:

        pkgin -y update && pkgin -y full-upgrade

5. Install a few images we'll need to compile & package SmartOS:

        pkgin install scmgit cdrtools pbzip2

6. Grab the source code of the fork containing the patches we want, from [arekinath/smartos-live](https://github.com/arekinath/smartos-live)

        git clone https://github.com/arekinath/smartos-live
        cd smartos-live

7. *Optional*: Edit `src/Makefile.defs` and change `PARALLEL =      -j$(MAX_JOBS)` to `PARALLEL =      -j8` to do less at once. (Microserver only has a dual core CPU!)

8. Copy the configure definition into the right place and start configuration:

        cp {sample.,}configure.smartos
        ./configure

      *(You'll probably get asked to accept the java license during configuration, so keep half an eye on it)*

9. Once configure has completed (which doesn't take *too* long, 15 minutes or so), start building:

        gmake world && gmake live

10. Once the build is successfully finished, time to package an iso & usb image:

        export LC_ALL=C
        tools/build_iso
        tools/build_usb

Hey presto, you've a freshly built AMD-friendly SmartOS build to flash to a USB key / put on your netboot server and boot your Microserver from!

* * *

**References**

* <http://wiki.smartos.org/display/DOC/Building+SmartOS+on+SmartOS>
* <https://github.com/arekinath/smartos-live>
