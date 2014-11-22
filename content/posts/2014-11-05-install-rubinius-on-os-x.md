---
title: "Install Rubinius on OS X"
author: "Caius Durling"
created_at: 2014-11-05 12:50:16 +0000
tags:
  - install
  - "OS X"
  - Rubinius
  - Ruby
---

Using [ruby-install][], [homebrew][] building it for use with [chruby][], here's how I install [Rubinius][] under Yosemite (works for Mavericks as well.)

[ruby-install]: https://github.com/postmodern/ruby-install/
[homebrew]: http://brew.sh/
[chruby]: https://github.com/postmodern/chruby/
[Rubinius]: http://rubini.us/

1. Make sure llvm is installed

        $ brew install llvm

2. Prepend the homebrew-installed llvm tools to your path

        $ export PATH="$(brew --prefix llvm)/bin:$PATH"

        # Or, for ZSH
        $ path=( $(brew --prefix llvm)/bin $path )

3. Install rubinius, v2.3.0 at the time of writing

        $ ruby-install rbx 2.3.0

4. Open a fresh shell once that's built, and you should be able to switch to rbx!

        $ chruby rbx
        $ ruby -v
        rubinius 2.3.0 (2.1.0 9d61df5d 2014-10-31 3.5.0 JI) [x86_64-darwin14.0.0]

* * *

*There is also a homebrew tap for rubinius which should also work instead of the above. I couldn't get it working on one of my laptops though, which is why I was installing by hand using the above instead. The tap is at <https://github.com/rubinius/homebrew-apps/> and <https://twitter.com/brixen/status/529725881498226688> explains install steps.*
