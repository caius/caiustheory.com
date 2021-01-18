---
title: "2021 01 18 Netgear Bridge"
date: 2021-01-18T16:42:40Z
author: Caius Durling
draft: true
tag:
  - 
---

<https://community.netgear.com/t5/Mobile-Routers-Hotspots-Modems/LB1120-Bridge-Mode-No-Connectivity/m-p/1404666>
<https://www.freebsd.org/cgi/man.cgi?query=dhclient.conf&sektion=5#LEASE_REQUIREMENTS_AND_REQUESTS>

> In pfSense, place a check in "Advanced Configuration" and then enter "supersede subnet-mask 255.255.255.0" in the Option modifiers field.  This supersedes the LB1120's supplied subnet mask of 255.255.255.255 and uses 255.255.255.0 instead.

```
set interfaces ethernet eth0 vif 20 dhcp-options client-option "supersede subnet-mask 255.255.255.0"
```
