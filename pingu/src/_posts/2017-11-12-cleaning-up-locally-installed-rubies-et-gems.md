---
title: "Cleaning up locally installed Rubies & Gems"
date: 2017-11-12T11:30:24Z
author: Caius Durling
tag:
  - bash
  - cli
  - code
  - ruby
  - rubygems
---

Given the following is broadly true:

* Rubies installed to `~/.rubies` (via ruby-install most likely)
* Gems for each ruby version installed under ~/.gem (via chruby most likely)

What to do when you want to reclaim some disk space? Delete unused ruby versions of course! Pretty straight forward, look in ~/.rubies for ones you want to remove, then delete them.

    $ ls ~/.rubies
    ruby-2.0.0
    ruby-2.1.7
    ruby-2.3.1
    ruby-2.4.1

    $ rm -r ~/.rubies/ruby-{2.0.0,2.1.7}

Then the problem is we're left with artifacts hanging around, namely any gems we installed for ruby 2.0.0 or 2.1.7 are still present under `~/.gem` using up disk space. We could go through and find them by hand, or we could get the computer to delete anything under `~/.gem` that doesn't have a corresponding runtime under `~/.rubies`.

```shell
diff --old-line-format= --unchanged-line-format= --new-line-format=$HOME/.gem/ruby/%L \
  <(ls ~/.rubies | sed -Ee 's/ruby-|-p[0-9]+//g') <(ls ~/.gem/ruby) \
  | xargs -pL1 rm -r
```

(`xargs -pL1` will prompt with each command it wants to run before running it - answer `y` to proceed, anything else to prevent it running that command. Lets you see what ruby versions it is removing before it does so.)

    $ ls ~/.gem/ruby
    2.0.0
    2.1.7
    2.3.1
    2.4.1

    $ diff --old-line-format= --unchanged-line-format= --new-line-format=$HOME/.gem/ruby/%L \
      <(ls ~/.rubies | sed -Ee 's/ruby-|-p[0-9]+//g') <(ls ~/.gem/ruby) \
      | xargs -pL1 rm -r
    rm -r /Users/caius/.gem/ruby/2.0.0?...y
    rm -r /Users/caius/.gem/ruby/2.1.7?...y

    $ ls ~/.gem/ruby
    2.3.1
    2.4.1

And now revel in your reclaimed disk space. (Hunting other large folders/items on your disk? [`ncdu`][ncdu] is a great tool for that.)

[ncdu]: http://dev.yorhel.nl/ncdu
