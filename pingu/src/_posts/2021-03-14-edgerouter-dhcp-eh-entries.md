---
title: "Fix Edgerouter DHCP ? entries"
date: 2021-03-14T15:55:00Z
tag:
  - dhcp
  - dnsmasq
  - edgerouter
  - fix
  - network
  - networking
  - ubiquiti
---

Occasionally I end up with devices on the local network that don't emit their hostname over DHCP, so when listing the current leases on the EdgeRouter's cli, they just appear as "?".[^1] These usually just irritate me, but occasionally when I'm looking for a machine on the network it means I can't find it and end up poking the different "?" IPs using `nmap` or `ssh` to discover which machines they are.

```shell
$ show dhcp leases 
IP address      Hardware Address   Lease expiration     Pool       Client Name
----------      ----------------   ----------------     ----       -----------
10.0.0.34       a8:1d:16:74:xx:yy  2021/03/14 16:38:27  trusted    ?
10.0.0.40       b8:27:eb:c5:xx:yy  2021/03/14 16:36:13  trusted    picontrol1
10.0.0.46       a8:1d:16:75:xx:yy  2021/03/14 16:37:48  trusted    ?
10.0.0.93       14:f6:d8:53:xx:yy  2021/03/14 16:40:29  trusted    ?
```

The EdgeRouter lets me assign static entries in the DHCP subnet, which solves the problem of knowing which hostnames they are, but also pins those devices to (effectively) static IPs within the subnet which leads to me having to know which IPs are free when I assign them, etc. Avoiding that is why I have DHCP on the local network.[^2]

Provided the EdgeRouter is configured to use [dnsmasq][] to provide DHCP services[^3], you can lean on the `dhcp-host` option in the dnsmasq configuration to assign a hostname based on MAC address, without prescribing a specific IP address for the machine. This solves the issue of "?" devices showing up in `show dhcp leases`, whilst also allowing dynamic IP assignment.

You'll need to know the MAC address in question, and pick a hostname to be assigned to the machine. You'll then want to inject these through dnsmasq's configuration file, which `set service dns forwarding options xxx` nicely injects into on the EdgeRouter.

```shell
$ configure
set service dns forwarding options "dhcp-host=14:f6:d8:53:xx:yy,cb1"
set service dns forwarding options "dhcp-host=a8:1d:16:75:xx:yy,cb3"
set service dns forwarding options "dhcp-host=a8:1d:16:74:xx:yy,cb2"
```

Then follow the usual `compare`, `commit`, verify your DNS/DHCP still works, `save` dance to apply & persist the changes.

Now when you login to the router and list the current DHCP leases, you'll see the hostnames available - and you can now lookup the machines in local DNS via their hostname too. 🎉

```shell
$ show dhcp leases 
IP address      Hardware Address   Lease expiration     Pool       Client Name
----------      ----------------   ----------------     ----       -----------
10.0.0.34       a8:1d:16:74:xx:yy  2021/03/14 16:38:27  trusted    cb2
10.0.0.40       b8:27:eb:c5:xx:yy  2021/03/14 16:36:13  trusted    picontrol1
10.0.0.46       a8:1d:16:75:xx:yy  2021/03/14 16:37:48  trusted    cb3
10.0.0.93       14:f6:d8:53:xx:yy  2021/03/14 16:40:29  trusted    cb1
```

[^1]: On my network currently these are Chromebooks, and Sonos speakers. I've also observed native SmartOS Zones behaving like this previously (I think they might have fixed this now.) I believe the device fails to send the current hostname (option 12) in either the DHCPDISCOVER or DHCPREQUEST packets.

[^2]: Also, if I assign static host mappings to a device they vanish entirely from `show dhcp leases`, which stops me being lazy and checking one place to figure out where a device is.

[^3]: To find out if you're using dnsmasq for DHCP, check `show service dhcp-server use-dnsmasq` returns "enable"

[dnsmasq]: https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
