---
title: Raspberry Pi 3 as an emergency router
date: 2016-07-11T19:55Z
tags:
  - cli
  - fix
  - linux
  - network
  - RPi
  - tech
  - unix
---

Due to my normal router's usb stick dying, I was in need of a replacement router for a day or two. Remembered I had a raspberry pi 3 lying around and stuck the latest raspbian on it, then set it up as a basic pppoe router.

I attached the fibre modem to the built in ethernet port, and plugged the LAN switch into an Apple USB Ethernet adapter in one of the USB ports.

To get it talking pppoe 



sysctl net.ipv4.ip_forward=1

```/etc/network/interfaces
iface eth0 inet static
  address 192.168.1.1
  netmask 255.255.255.0
  gateway 192.168.1.1

auto eth1
iface eth1 inet dhcp
```

```/etc/dhcpcd.conf
interface eth0
static ip_address=192.168.1.1
static routers=192.168.1.1
static domain_name_servers=8.8.8.8,8.8.4.4
```

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
# iptables -A INPUT -j LOG --log-level 7 --log-prefix "IPTABLES Dropped: "
iptables -A INPUT -j DROP

