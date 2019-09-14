---
title: "curl --resolve"
date: 2019-09-14T18:10:00+01:00
author: Caius Durling
tag:
  - curl
  - web
  - unix
---

Sometimes it's useful to be able to craft a request to one server, using a DNS name that's either not defined or currently pointed to a different IP. (Migrating webservers, testing a new webserver config out, etc.)

Historically for HTTP calls this was easy, just set the `Host` header as you make the http request to the IP directly:

		curl -H "Host: caiustheory.com" http://10.200.0.1/

However, HTTPS throws a bit of a spanner in the works, if we just try to connect using an overridden `Host` header, we get an error back from the server if it's not configured with a certificate for the IP address:

		$ curl -H "Host: caiustheory.com" https://10.200.0.1/
		curl: (51) SSL: no alternative certificate subject name matches target host name '10.200.0.1'

Usually at this point I'd just start editing `/etc/hosts` to add `10.200.0.1 caius.name` to it and carry on testing. This is a pain when you're testing more than one server, or you're on a machine where you don't have root access to edit `/etc/hosts`.

In later versions of curl there's a solution for this built into the binary, in the form of the `--resolve` flag. You can tell it to override the DNS lookup for a specific hostname/port combination. This in turn means that the correct host is forwarded to the server for the correct SSL certificate to be chosen to serve the request based on host.

It takes the form `--resolve HOST:PORT:IP` where `HOST` is the human-friendly host, `PORT` is the webserver's port (convention is 80 for HTTP, 443 for HTTPS) and IP being the destination IP you want to hit. (As opposed to the one in DNS currently.)

```
$ curl --silent --head --resolve caiustheory.com:443:10.200.0.1 https://caiustheory.com | head -n1
HTTP/2 200 
```

And voila, you don't need to fiddle with editing `/etc/hosts`. Just use `--resolve` to hit a different IP for a given host.
