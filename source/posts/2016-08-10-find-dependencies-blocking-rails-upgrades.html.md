---
title: Find dependencies blocking rails upgrades
date: 2016-08-10T11:39:00Z
tags:
  - ruby
  - rails
  - awk
---

The initial pain point when upgrading a rails app is figuring out which of your dependencies are blocking you upgrading the actual `rails` gem (& immediate dependencies, actionpack, etc.). One way to start this is to update the rails dependency in your `Gemfile` and run `bundle update rails`. Then check the error output _(it never works first time…)_ to see which gems are blocking the upgrade. Repeat, rinse until it works.

I figured I'd cheat a little and eyeball the `Gemfile.lock` to see which gems had an explicit dependency pinning rails (or actionpack, activejob, etc) to a version lower than I want to upgrade to, so I could get an idea of what needs to be upgraded without having to do them all one-by-one.

Then instead of eyeballing `Gemfile.lock`, I wrote an awk script to pull out the interesting dependencies (ie, anything that depends on rails gems) so I just have to check which versions they depend on by hand.

```awk
# Reads a Gemfile.lock and outputs all dependencies that depend on rails

BEGIN {
  parent = 0
  parent_printed = 0
  rails = "^rail(s|ties)|action(mailer|pack|view)|active(job|model|record|support)$"
}

# We only want the specs from the GEM section
NR == 1, $1 ~ /GEM/ { next }
$1 == "" { exit }

# Skip parent gems we don't care about (rails itself…)
$0 ~ /^ {4}[^ ]/ && $1 ~ rails {
  parent = 0
  parent_printed = 0
  next
}

# Parent gems that aren't part of rails core
# Store the name to be printed if we match below
$0 ~ /^ {4}[^ ]/ {
  parent = $0
  parent_printed = 0
  next
}

# If the nested gem (6 space prefix) matches rails-names and we have a parent value
# set then we print them out - making sure to only print the parent once
$0 ~ /^ {6}[^ ]/ && $1 ~ rails && parent != 0 {
 if (parent_printed == 0) {
   parent_printed = 1
   print parent
 }

  print $0
}
```

Run it against your `Gemfile.lock` for the app you're upgrading:

```shell
awk -f rails5.awk Gemfile.lock
```

And you'll get output like this, to run through and see if any of the dependencies are pinning to lower versions than you need.

```
    climate_control (0.0.3)
      activesupport (>= 3.0)
    cucumber-rails (1.4.2)
      rails (>= 3, < 5)
    devise (3.5.6)
      railties (>= 3.2.6, < 5)
    factory_girl (4.5.0)
      activesupport (>= 3.0.0)
    factory_girl_rails (4.5.0)
      railties (>= 3.0.0)
    globalid (0.3.6)
      activesupport (>= 4.1.0)
    jquery-rails (3.1.4)
      railties (>= 3.0, < 5.0)
    paperclip (4.3.2)
      activemodel (>= 3.2.0)
      activesupport (>= 3.2.0)
    responders (2.1.1)
      railties (>= 4.2.0, < 5.1)
    rspec-rails (3.4.0)
      actionpack (>= 3.0, < 4.3)
      activesupport (>= 3.0, < 4.3)
      railties (>= 3.0, < 4.3)
    sass-rails (5.0.4)
      railties (>= 4.0.0, < 5.0)
      sprockets-rails (>= 2.0, < 4.0)
    sprockets-rails (3.0.4)
      actionpack (>= 4.0)
      activesupport (>= 4.0)
    whenever (0.9.2)
      activesupport (>= 2.3.4)
```

In this case, I'm trying to take this app to rails 5.0, so all the ones specifying `< 5` and `< 4.3` need upgrading beforehand.
