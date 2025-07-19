---
title: "Geolocation in nginx"
author: "Caius Durling"
date: 2012-12-04 09:42:00 +0000
tag:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "ubuntu"
  - "deployment"
  - "terminal"
  - "linux"
  - "geolocation"
  - "nginx"
---

Sometimes you need to have a rough idea of where your website visitor is located. There's many ways to geolocate them, but if you just want to go to country level then [MaxMind have free geo databases](http://dev.maxmind.com/geoip/geolite) available to help you. When we needed to do this quickly on-the-fly at EmberAds, we came up with the [trifle][] gem, which supports ipv4 and ipv6 lookups.

[trifle]: https://github.com/emberads/trifle#readme

Recently I was searching for something else to do with nginx and ran across [a mailing list thread][mlthread] about using the maxmind database with nginx's [HTTP Geo module](http://wiki.nginx.org/NginxHttpGeoModule) and do the lookup directly in nginx itself. Finally got a chance to sit down and work out the logistics of doing this. I've done this on an ubuntu 12.04 box, with the expected config file layouts that come with ubuntu.

[mlthread]: http://www.ruby-forum.com/topic/125810

Run the following on your server (as someone with write access to nginx config files):

```shell
# Generate the text file for nginx to import
perl <(curl -s https://raw.github.com/nginx/nginx/master/contrib/geo2nginx.pl) \
< <(zip=$(tempfile) && \
curl -so $zip http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip \
&& unzip -p $zip) > /etc/nginx/nginx_ip_country.txt

# Tell nginx to work out the IP country and store in variable
echo 'geo $IP_COUNTRY {
  default --;
  include /etc/nginx/nginx_ip_country.txt;
}' > /etc/nginx/conf.d/ip_country.conf
```

Now go find the http block for the vhost you want to have the header passed to, and assuming it's passenger, add the following:

```nginx
passenger_set_cgi_param HTTP_X_IP_COUNTRY $IP_COUNTRY;
```

(If you don't use passenger, look at the docs for [proxy\_pass\_header](http://wiki.nginx.org/HttpProxyModule#proxy_pass_header) or [fastcgi\_pass\_header](http://wiki.nginx.org/HttpFastcgiModule#fastcgi_pass_header) to see which you'll require for your setup.)

Reload nginx, and behold, `request.env["HTTP_X_IP_COUNTRY"]` (assuming a rack app running under ruby) will be a two letter country code, or `"--"`.

Unfortunately this is IPv4 only currently, there's a [thread on the nginx mailing list from November 2012](http://forum.nginx.org/read.php?29,232648) saying IPv6 support should be coming on the v1.3 branch of nginx, but with no known ETA. So currently for IPv6 support, take a look at [EmberAds' trifle gem][trifle] instead.
