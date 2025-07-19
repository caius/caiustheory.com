---
title: "Tailscale, RFC1918, and DNS Rebinding Protection"
date: 2020-07-16T21:00:00+01:00
author: Caius Durling
tag:
  - Tailscale
  - cli
  - fix
  - network
  - networking
  - security
  - tech
  - tips
  - vpn
---
**Edit:** _Originally this post was written to be a workaround for Tailscale routing all DNS traffic over its own link when you configured it to push out existing DNS Server IPs. This turned out to be a bad assumption on my part. Thanks to [apenwarr](https://twitter.com/apenwarr) for helping me understand that shouldn't be the case, and encouraging me to debug it properly rather than making assumptions._

_Naturally it turned out to be a [PEBKAC][]. I'd pushed out `162.159.25.4` as the DNS Server IP which is a nameserver rather than a forwarder. This in turn meant people were getting empty answers back to DNS queries, which stopped once they quit tailscale. (Go figure, Tailscale removes the resolver from the network stack when it quits.) The post has been updated to remove that invalid assumption. 🤦🏻‍♂️_

Imagine we have a fleet of machines sat in a private network somewhere on a `172.16.20.20/24` IP range, with entries pointing at them published on public DNS servers. Eg, `dig +short workhorse.fake.tld` returns `172.16.20.21`.

Initially this all works swimmingly, until someone comes along that is using a DNS forwarder that with DNS rebinding protection enabled. Daniel Miessler has a [wonderfully succinct explanation on his blog][daniel rebinding post] about DNS Rebinding attacks, but to protect against it you stop your resolver returning answers to DNS queries from public servers which resolve to IP addresses within standard internal network ranges. (ie, [rfc1918][].)

This means for those users they can successfully connect to our Tailscale network and access everything by IPs directly, but can't access any of the internal infrastructure by hostname. eg, `dig +short workhorse.fake.tld` will return an empty answer for them.

Once we figured out the root cause of that, for workarounds we figured we could either run a DNS forwarder within our own infrastructure, or get all our staff to change their home DNS settings and hope they were never on locked down networks ever again.

We chose the former, and thankfully [dnsmasq][] is really easy to configure in this fashion and we already have a node which is acting as the tailscale subnet relay, so we dropped the following config in `/etc/dnsmasq.conf` on there:

```
# Only listen for requests from VPN/local for debugging
interface=tailscale0
interface=lo

# Google DNS
server=8.8.8.8
server=8.8.4.4
# Quad9
server=9.9.9.9
# Cloudflare
server=1.1.1.1
server=1.0.0.1
# Race all servers to see which wins
all-servers

# Try and stop DNS rebinding, except where we expect it to happen
bogus-priv
stop-dns-rebind
rebind-localhost-ok
rebind-domain-ok=/fake.tld/

domain-needed
filterwin2k
no-poll
no-resolv
cache-size=10000
```

One quick puppet run later, and our Tailscale subnet relays are happily running both tailscale and dnsmasq, serving out answers as fast as they can to other Tailscale nodes. Add port 53 to the [Tailscale ACL][] and away we went.

[Tailscale]: https://tailscale.com
[PEBKAC]: https://www.urbandictionary.com/define.php?term=pebkac
[Viscosity]: https://www.sparklabs.com/viscosity/
[daniel rebinding post]: https://danielmiessler.com/blog/dns-rebinding-explained/
[rfc1918]: https://www.ietf.org/rfc/rfc1918.txt
[tailscale dns]: https://www.tailscale.com/kb/1054/dns
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[Tailscale ACL]: https://www.tailscale.com/kb/1018/acls
