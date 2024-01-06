---
title: "Running OmniOS via UTM on Apple Silicon"
date: 2024-01-05T01:00:00Z
author: "Caius Durling"
draft: true
tag:
    - "apple"
    - "cpu"
    - "mac"
    - "OmniOS"
    - "OS X"
    - "unix"
    - "virtualisation"
---

Wanted to fire up [OmniOS] to play with and didn't have any spare x86 hardware to hand so decided to figure out running it in [UTM] on Apple Silicon, meaning it needs emulation as OmniOS is x86 only.

[OmniOS]: https://omnios.org/
[UTM]: https://getutm.app/

Grab the ISO from the [OmniOS downloads page][omnios-downloads], I used the LTS release but the current stable should work too. Just make sure it's the ISO version, not USB, etc.

[omnios-downloads]: https://omnios.org/download.html

Open UTM and click "Create a New Virtual Machine". Choose "Emulate" as we need a x86 VM on an aarch64 host. Choose "Other" for the Operating System, then select the iso file you downloaded above from the Browse… button.

Make sure to leave the Hardware Architecture set to x86_64, but adjust the rest to what you require. OmniOS suggests 1GB ram minimum for VMs. Storage is suggested to be 8GB minimum.

On the Summary screen check the "Open VM Settings" and click Save.

On the Settings popover that appears, select Display from the sidebar and change the "Emulated Display Card" to "VGA". This ensures we don't get a black screen when booting.

I then chose to make the VM appear as a separate host on my LAN, by changing "Network" -> "Network Mode" to "Bridged (Advanced)". This isn't required.

Save the settings and boot the VM, now you can follow the [OmniOS Installer Walk-Through][installer] as normal.

On the post-installation menu I chose "**C**onfigure the installed OmniOS system", then "**C**onfigure Networking" and changed it from Static to DHCP, so it will pick up an IP at boot from my router.

[installer]: https://omnios.org/setup/freshinstall.html

Reboot and Enjoy.

![OmniOS boot menu inside a UTM window on a Mac](/2024-01-06-omnios-running-utm.png)
