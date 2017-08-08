---
title: "Use Readline With Default Ruby on OS X"
author: "Caius Durling"
date: 2012-02-05 18:13:20 +0000
tag:
  - "tech"
  - "ruby"
  - "code"
  - "fix"
  - "cli"
  - "apple"
  - "installing"
  - "os x"
  - "terminal"
---

OS X Lion comes with ruby 1.8.7-p249 installed, although it's compiled against libedit rather than libreadline. Whilst libedit is a mostly-compatible replacement for libreadline, I find there's a couple of settings I'm used to that don't work in libedit. (Like `history-beginning-search-backward`.)

Luckily you can grab the source of ruby and compile just the readline extension, and move it into the right place for it to just work. Here's what's been working for me:

```shell
# Install readline using homebrew
brew install readline

# Download the ruby source and check out 1.8.7-p249
mkdir ~/tmp && cd ~/tmp
git clone git://github.com/ruby/ruby
cd ruby
git checkout v1_8_7_249
cd ext/readline
ruby extconf.rb --with-readline-dir=$(brew --prefix readline) --disable-libedit
make
```

Now you should have `readline.bundle` in the current directory, and it should be compiled against your homebrew-installed readline library, rather than libedit that comes with the system. We can quickly double-check that by using `otool` to check what the binary is linked against.


    $ otool -L readline.bundle
    readline.bundle:
        /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/libruby.1.dylib (compatibility version 1.8.0, current version 1.8.7)
        /usr/local/Cellar/readline/6.2.2/lib/libreadline.6.2.dylib (compatibility version 6.0.0, current version 6.2.0)
        /usr/lib/libncurses.5.4.dylib (compatibility version 5.4.0, current version 5.4.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 159.1.0)

And in the output you should see a line listing "libreadline", and no lines listing "libedit". Which that shows, we've compiled it properly then. Now the bundle is built we need to move it into the right place so it's loaded when ruby is invoked.

```shell
RL_PATH="/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin11.0"
# Back up the original bundle, just in cases
sudo mv "$RL_PATH/readline.bundle" "$RL_PATH/readline.bundle.libedit"
sudo mv readline.bundle "$RL_PATH/readline.bundle"
```

And that's it. You've got a proper compiled-against-readline installed ruby 1.8.7-p249 on 10.7 now.

One gotcha I ran into was needing to pass the same arguments to rvm when installing any other version of 1.8.7 on the same machine. Simple enough, just need to remember to do it though.

```shell
CC=gcc-4.2 rvm install 1.8.7-p357 -C --with-readline-dir=$(brew --prefix readline) --disable-libedit
```
