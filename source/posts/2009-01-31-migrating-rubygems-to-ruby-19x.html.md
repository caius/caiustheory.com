---
title: "Migrating Rubygems to Ruby 1.9.x"
author: "Caius Durling"
date: 2009-01-31 20:29:57 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "gem"
  - "rubygems"
  - "macports"
  - "installing"
  - "ruby1.9"
---

So I just installed ruby 1.9.1 through [MacPorts][] and wanted to easily migrate my rubygems across from 1.8 to see which ones would fail to install.

[MacPorts]: http://macports.org/

Thought about it for a while, then came up with the following bash one-liner to do it:

    gem list | grep "(" | awk '{ print $1 }' | xargs -L 1 gem1.9 install

**NB:** Installing Ruby 1.9.1 through macports `sudo port install ruby19` means I get `ruby1.9`, `gem1.9` and `rake1.9` installed alongside my usual 1.8 `ruby`, `gem` and `rake`.

That grabs the list of installed gems from `gem`, searches for lines containing "(" so it only grabs the gem names, spits out the first section of the line, which is the name of the gem, and finally calls `gem1.9 install` for each line via `xargs -L 1`. Make sure to run it as root or prefix `gem1.9` with `sudo`. *(Or let it install in your home folder, but I hate that.)*

From my quick run of the above snippet, 75% of my gems installed *(73 out of 98)* and the other few that failed to install were ones like [Hpricot][] that require native extensions compiling. You can see the entire list of failures and successes of the gems in [this pastie][gemlist]

[Hpricot]: http://github.com/why/hpricot/tree/master
[gemlist]: http://pastie.textmate.org/pastes/376136
