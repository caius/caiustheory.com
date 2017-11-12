# Cleaning up locally installed Rubies & Gems

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
diff --old-line-format= --unchanged-line-format= --new-line-format=$HOME/.gem/ruby/%L <(ls ~/.rubies \
  | sed -Ee 's/ruby-|-p[0-9]+//g') <(ls ~/.gem/ruby) \
  | xargs rm -r
```

(Drop the final `| xargs rm -r` to list out what it will delete.)

    $ ls ~/.gem/ruby
    2.0.0
    2.1.7
    2.3.1
    2.4.1

    $ diff --old-line-format= --unchanged-line-format= --new-line-format=$HOME/.gem/ruby/%L <(ls ~/.rubies \
      | sed -Ee 's/ruby-|-p[0-9]+//g') <(ls ~/.gem/ruby) \
      | xargs rm -r

    $ ls ~/.gem/ruby
    2.3.1
    2.4.1

And now revel in your reclaimed disk space. (Hunting other large folders/items on your disk? [`ncdu`][ncdu] is a great tool for that.)

[ncdu]: http://dev.yorhel.nl/ncdu
