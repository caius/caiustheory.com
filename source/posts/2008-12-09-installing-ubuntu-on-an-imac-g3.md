---
title: "Installing Ubuntu on an iMac G3"
author: "Caius Durling"
date: 2008-12-09 08:51:48 +0000
tags:
  - "geek"
  - "tech"
  - "code"
  - "fix"
  - "cli"
  - "bash"
  - "modification"
  - "apple"
  - "imac"
  - "ubuntu"
---

I decided to install ubuntu onto my iMac G3<ref>450Mhz G3, 768mb ram, 20GB Hard Drive</ref> to play around with.  Only problem was it would boot so far, then just stop at a black screen.  In googling the fix, the blog post that contains the fix is *slightly* outdated and 100% 404.

Here is the fix, updated for Ubuntu 6.10 Desktop PPC:

1. When the screen goes black, drop to the console

        Control - Option - F2

    *(if you need to log in use the name ubuntu to log in.)*

        $ sudo nano /etc/X11/xorg.conf

2. Change the frequencies in monitor section as follows:

        Section “Monitor”
            Identifier “Generic Monitor”
            Option “DPMS”
            HorizSync 60-60
            VertRefresh 43-117
        EndSection

3. After the changes then type `control-o`, `return` (to accept the filename), then `control-x` (save and exit nano)
4. Restart X by running the following:

        sudo killall gdm && sudo /etc/init.d/gdm start
