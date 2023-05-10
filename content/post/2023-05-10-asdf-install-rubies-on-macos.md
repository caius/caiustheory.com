---
title: "`asdf install ruby` on macOS"
slug: "asdf-install-ruby-macos"
date: "2023-05-10T21:03:53Z"
tag:
  - "macos"
  - "ruby"
---

NB: This mostly applies to M1/M2 Apple Silicon macs, because homebrew is installed in `/opt/homebrew` there. If you're on an Intel mac with Homebrew installed in `/usr/local`, asdf/ruby-build pick up the right things I believe.

Installing ruby through [asdf][] on macOS making sure to link openssl from homebrew requires a few contortions depending on which version of ruby you're installing. (There's also a trick I keep forgetting to have asdf pick up the latest `ruby-build` version, which is what it delegates building ruby to internally inside the asdf ruby plugin.)

Ruby 2.6.10 & 2.7.x need OpenSSL 1.1 specifically, so we link against that whilst building. Ruby 2 is also unsupported at time of publishing, you should upgrade to ruby 3! (Tested with ruby 2.6.10 and 2.7.8 at time of publishing.)

```shell
brew install openssl@1.1
ASDF_RUBY_BUILD_VERSION=master \
  RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)" \
  asdf install ruby 2.7.8
```

Ruby 3.0 and higher need openssl@3 instead, so link against that whilst building. (Tested with ruby 3.1.4 and 3.2.2 at time of publishing.)

```shell
brew install openssl@3
ASDF_RUBY_BUILD_VERSION=master \
  RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)" \
  asdf install ruby 3.2.2
```

[asdf]: https://asdf-vm.com
