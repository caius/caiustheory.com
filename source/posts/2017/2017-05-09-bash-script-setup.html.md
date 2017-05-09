---
title: Bash script setup
date: 2017-05-09T18:23:58Z
tags:
  - bash
  - programming
---

Recently I've been writing a bunch of bash scripts for various things. As some up-front safety checks I've taken to opening every script with the following:

```shell
#!/usr/bin/env bash

[[ "$TRACE" ]] && set -o xtrace
set -o errexit
set -o nounset
set -o pipefail
set -o noclobber
```

Other things I'm also trying to be good about doing:

* using `readonly` when declaring variables which shouldn't be mutated
* Trapping errors using an error function, and cleaning up anything temporary in there

And some useful reading I ran across in my quest to level up bash-scripts:

* [Bash Exit Traps](http://redsymbol.net/articles/bash-exit-traps/)
* [Use the unofficial Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/) (Yes, _two_ posts on <http://redsymbol.net/>. Well worth reading.)
* [Bash scripting quirks & safety tips](https://jvns.ca/blog/2017/03/26/bash-quirks/)
* [Bash hackers wiki](http://wiki.bash-hackers.org/)
