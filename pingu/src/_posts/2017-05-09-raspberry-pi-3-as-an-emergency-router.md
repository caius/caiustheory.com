---
title: Raspberry Pi 3 as an emergency router
date: 2017-05-09T20:55:00Z
tag:
  - RPi
  - networking
  - unix
---

Given a dead router, how do you get back online whilst you wait for the replacement part to arrive? Grab a Raspberry Pi 3 off the shelf, along with a USB to Ethernet adapter and hey presto the internet works again.

This is with a fibre modem (FTTC), using PPPoE to connect out. Plug the modem (WAN) into the RPi's ethernet port, and plug the LAN switch into the USB adapter.

First thing is to get the WAN link working, get it talking PPPoE to the ISP. Usually this will be configured in `/etc/ppp/pppoe.conf` (depends on your linux distro). (That'll require your username/password for your ISP usually too.)

Get it up & connected, and make sure you can ping the internet from the RPi. Then it's time to get the LAN working. Give it a static IP in the range you want shared out.

```
# /etc/network/interfaces
iface eth0 inet static
  address 192.168.1.1
  netmask 255.255.255.0
  gateway 192.168.1.1

auto eth1
iface eth1 inet dhcp
```

Get a dhcp server running on the LAN connection, 

```
# /etc/dhcpcd.conf
interface eth0
static ip_address=192.168.1.1
static routers=192.168.1.1
static domain_name_servers=8.8.8.8,8.8.4.4
```

And then it's time to handle WAN -> LAN traffic and the reverse. Make sure you have packet forwarding enabled, and then setup the firewall to handle NAT and also keep out undesirable traffic.

```shell
sysctl net.ipv4.ip_forward=1

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type any -j ACCEPT
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -f -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
iptables -A INPUT -j DROP
```

Hey presto, you have a working emergency router. In testing I found my fibre connection (80/20Mb) was slower than the traffic the RPi could push, so didn't notice any difference vs my normal router. (Although I did disable a bunch of automated stuff, so there was less contention on the WAN link.)
