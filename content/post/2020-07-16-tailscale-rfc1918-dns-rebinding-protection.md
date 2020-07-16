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

We recently replaced [OpenVPN][] servers with [Tailscale][] subnet relays, and ran into a funky issue with DNS lookups and rebinding attack protection that took a little thinking to work around.

Imagine we have a fleet of machines sat in a private network somewhere on a `172.16.20.20/24` IP range, with entries pointing at them published on public DNS servers. Eg, `dig workhorse.fake.tld` returns `172.16.20.21`. There’s an OpenVPN server sat there with a public IP address on it that everyone connects into, likely using something like [Viscosity][] on macOS.

Initially this all works swimmingly, until someone comes along that is using a DNS forwarder that has enabled protection against DNS rebinding attacks. Daniel Miessler has a [wonderfully succinct explanation on his blog][daniel rebinding post] about DNS Rebinding, but to protect against it you stop your resolver returning answers to DNS queries from public servers which resolve to IP addresses within standard internal network ranges. (ie, [rfc1918][].)

With Viscosity we can push out a configuration to say “when looking up names ending in `fake.tld`, use `8.8.8.8` as the DNS server directly”, all the client machines start doing that and follow their own routing tables to discover how to talk to `8.8.8.8` and can then successfully get to `workhorse.fake.tld`, looking up DNS over their public WAN link, then using the VPN interface to access the private network.

Fast forward a few months, and we find switching over to [Tailscale][] was seamless, easy, quick and also breaks the above. You can configure [custom DNS through the Tailscale admin panel][tailscale dns] and this config arrives on other nodes in your mesh _super_ quickly. Initially we setup the same as above: please look up `fake.tld` names by asking `8.8.8.8`.[^1] Then a short while later, all the beta users started complaining about network flakiness until they quit Tailscale and you start wondering if the universe is conspiring against you as Tailscale’s been fine for you for a month before you added anyone else 😬.

After a little more investigation we found Tailscale is adding (at least on a mac) the resolver and also telling the machine to use the Tailscale interface to talk to the DNS server. So the Mac then tries to query `8.8.8.8` over Tailscale's interface (into the mesh network), and nothing within our Tailscale network is announcing that as a route so the DNS query times out and goes unanswered 😿.

Once we’d figured this out, we realised we could either run a DNS forwarder within our own infrastructure, or get all our staff to change their home DNS settings and hope we were never on locked down networks ever again.

One quick puppet change later, and our Tailscale subnet relay was happily running [dnsmasq][], serving out answers[^2] as fast as it could to other Tailscale nodes. Add port 53 to the [Tailscale ACL][] and away we went.

[OpenVPN]: https://openvpn.net
[Tailscale]: https://tailscale.com
[Viscosity]: https://www.sparklabs.com/viscosity/
[daniel rebinding post]: https://danielmiessler.com/blog/dns-rebinding-explained/
[rfc1918]: https://www.ietf.org/rfc/rfc1918.txt
[tailscale dns]: https://www.tailscale.com/kb/1054/dns
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[Tailscale ACL]: https://www.tailscale.com/kb/1018/acls

[^1]: Strictly we're asking it to push out the IP Address for a resolver, and also append `fake.tld` into the search paths. On macOS this _mostly_ equates to the behaviour we want though in testing. Some other DNS queries appear to get sent through Tailscale, but for us that's fine.

[^2]: dnsmasq is simple to configure as a forwarder, just remember to allow rebinding for your domain with `rebind-domain-ok`! Might also be worth setting `all-servers` and having multiple upstream resolvers configured.
