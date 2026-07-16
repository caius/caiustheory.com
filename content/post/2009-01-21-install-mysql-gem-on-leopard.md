---
title: "Install Mysql Gem on Leopard"
author: "Caius Durling"
date: 2009-01-21 17:09:41 +0000
lastmod: "2009-10-19T14:15:16+0100"
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
  - "fix"
  - "cli"
  - "bash"
  - "rails"
  - "gem"
  - "rubygems"
  - "google"
  - "macports"
  - "mysql"
  - "installing"
---

So, I keep having to reinstall mysql5 and rubygems from time to time for various reasons. I always install mysql5 through [MacPorts][] as a dependency for the php5 port (along with various other bits for the LA*P stack).

[MacPorts]: http://macports.org/

```shell
sudo port install php5 +mysql5 +pear +readline +sockets +apache2 +sqlite
```

Once this is installed then I have `mysql` and can setup my databases, etc.

Ignoring the rest of the LAMP stack, I then need to connect Ruby to the Mysql I just installed through MacPorts. Its quite simple to do, once you know the right argument to pass to it. The easiest way is to just tell it where the `mysql5_conf` file is and let it figure out the rest for itself.

```shell
sudo gem install mysql -- --with-mysql-config=/opt/local/bin/mysql_config5
```

Hopefully this will save me 10 minutes of googling next time I need to do this!

### Update 2009-01-21

I'm an idiot and typed the `gem install` command by hand, and ended up with `--with-mysql-conf` instead of `--with-mysql-config`. Updated now.

### Update 2009-10-19

On Snow Leopard I needed to tell rubygems to install the gem as a 64-bit binary. Hattip to [Philipp](http://www.schmidp.com/2009/06/14/rubyrails-and-mysql-on-snow-leopard-10a380/comment-page-1/)

```shell
sudo env ARCHFLAGS="-arch x86_64" gem install mysql -- \
  --with-mysql-config=/opt/local/bin/mysql_config5
```
