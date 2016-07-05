---
title: Setup DHCP interface in FreeBSD
author: Caius Durling
tags:
  - geek
  - FreeBSD
  - network
---

Given a FreeBSD instance without a configured network interface that you'd like to configure, first check what the name of the interface you want to configure is with `ifconfig`. (Mine is `em0` in this instance.)

Then we need to add the configuration telling services that we want to use DHCP for this interface, and setting up our default router (use your IP, not mine!) too:

```shell
cat >> rc.conf <<CONF
ifconfig_em0="DHCP"
default_router="192.168.1.1"
CONF
```

And then we need to start `dhclient` on the given interface:

```shell
service dhclient start em0
```

Hey presto, you should see dhclient finding a DHCP server and being handed an IP address for `em0`.
