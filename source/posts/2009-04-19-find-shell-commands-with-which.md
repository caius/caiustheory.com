---
title: "Find shell commands with which"
author: "Caius Durling"
date: 2009-04-19 15:02:04 +0000
tags:
  - "geek"
  - "tech"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "link"
  - "google"
  - "macports"
---

So I have this command in my $PATH, `apachectl`. Because I'm on a mac and I've installed apache2 through [MacPorts][], the command that gets found first is my macports install in `/opt`. Up until now I've always known that `which apachectl` will find that location, but to find any other locations of `apachectl` I'd usually use `locate` and `egrep` together.

[MacPorts]: http://macports.org/


Here's my original workflow, lets find the location of the `apachectl` being called when I don't specify a path.

    Julius:~ caius$ which apachectl
    /opt/local/apache2/bin/apachectl

Simple enough. Now lets figure out what other locations there's an `apachectl` installed at.

    Julius:~ caius$ locate apachectl | egrep "\/apachectl$"
    /opt/local/apache2/bin/apachectl
    /opt/local/var/macports/software/apache2/2.2.11_0+darwin_9/opt/local/apache2/bin/apachectl
    /usr/sbin/apachectl

Right, so now I know where else a command exists in the filesystem called `apachectl`, but I don't know if any of those is in my $PATH, or what order they come in when searching through my $PATH. In this (old) workflow I'd have compared them to my $PATH manually as there's so few of them.

So I noticed [Ali][] googling for the `which` man page on IRC, and *(quite stupidly)* poked fun at him for doing so. I then swallowed my ego and actually followed the link to the man page, and boy was I glad I did. Just shows with even a fairly simple command like `which`, you sure don't know everything!

[Ali]: http://awhitebox.com

What I discovered was that `which` has a single flag you can pass it, `-a`. From the [man page][man]:

[man]: http://unixhelp.ed.ac.uk/CGI/man-cgi?which

    -a     print all matching pathnames of each argument

Right. So that `locate | grep` command plus manually figuring out what is in my $PATH is really hard work then. `which -a` should give us the same results, but a lot faster and with a lot less manual thought.

    Julius:~ caius$ which -a apachectl
    /opt/local/apache2/bin/apachectl
    /usr/sbin/apachectl

And hey presto, yet another useful bit of bash knowledge for me, thanks to [Ali][] not being afraid to <acronym title="Read the Fucking Manual">RTFM</acronym>!
