---
title: "Install GCC-4.2.1 (Apple build 5666.3) with Xcode 4.2"
author: "Caius Durling"
date: 2011-10-30 17:36:48 +0000
tag:
  - "geek"
  - "tech"
  - "programming"
  - "code"
  - "fix"
  - "cli"
  - "apple"
  - "installing"
  - "os x"
  - "mac"
  - "mac app store"
  - "gcc"
  - "llvm"
---

As of Xcode 4.2 Apple have stopped bundling GCC with it, shipping only the (mostly) compatible llvm-gcc binary instead. The suggested fix is to install GCC using the [osx-gcc-installer](https://github.com/kennethreitz/osx-gcc-installer) project. However, I wanted to build and install it from source, which apple provides at <http://opensource.apple.com/>.

You should already have installed Xcode 4.2 from the app store, then basically the following steps are to grab the tarball from the [4.1 developer tools source][devtools4.1], unpack & compile it, then install it into the right places.

[devtools4.1]: http://opensource.apple.com/release/developer-tools-41/

**Update 2016-07-03:** I'd suggest just using homebrew to install this these days:

```shell
brew install homebrew/dupes/apple-gcc42
```

## Instructions

```shell
# Grab and unpack the tarball
mkdir ~/tmp && cd ~/tmp
curl -O http://opensource.apple.com/tarballs/gcc/gcc-5666.3.tar.gz
tar zxf gcc-5666.3.tar.gz
cd gcc-5666.3

# Setup some stuff it requires
mkdir -p build/obj build/dst build/sym
# And then build it. You should go make a cup of tea or five whilst this runs.
gnumake install RC_OS=macos RC_ARCHS='i386 x86_64' TARGETS='i386 x86_64' \
  SRCROOT=`pwd` OBJROOT=`pwd`/build/obj DSTROOT=`pwd`/build/dst \
  SYMROOT=`pwd`/build/sym

# And finally install it
sudo ditto build/dst /
```

And now you should have `gcc-4.2` in your `$PATH`, available to build all the things that `llvm-gcc` fails to compile.
