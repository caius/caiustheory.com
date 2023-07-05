---
title: "`asdf install ruby` on macOS"
slug: "asdf-install-ruby-macos"
date: "2023-05-10T21:03:53Z"
tag:
  - "asdf"
  - "macos"
  - "ruby"
---

Installing ruby through [asdf][] on Apple Silicon Macs[^1] will attempt to build a custom OpenSSL for each install because it can't find OpenSSL from homebrew in `/usr/local`, as that's now installed in `/opt/homebrew`. This means your `brew update` no longer pulls in security fixes for your ruby runtimes, as well as wasting disk space.

Ruby 2.6.10 & 2.7.x need OpenSSL 1.1, and are unsupported at time of publishing so you should upgrade to ruby 3! (Tested with ruby 2.6.10 and 2.7.8 at time of publishing.)

```shell
brew install openssl@1.1
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)" \
  asdf install ruby 2.7.8
```

Ruby 3.0 and higher need `openssl@3` so we follow the same override but with a different brew name. (Tested with ruby 3.1.4 and 3.2.2 at time of publishing.)

```shell
brew install openssl@3
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)" \
  asdf install ruby 3.2.2
```

Also if you're trying to install a version of ruby that exists in [rbenv/ruby-build][] `master` branch, but not in the version of ruby-build [asdf-ruby plugin uses][asdf-ruby-lib-pin] you can override it with `ASDF_RUBY_BUILD_VERSION=master` when running `asdf ruby install x.y.z`. Pass as an extra envariable to the above commands.

[asdf]: https://asdf-vm.com
[rbenv/ruby-build]: https://github.com/rbenv/ruby-build
[asdf-ruby-lib-pin]: https://github.com/asdf-vm/asdf-ruby/blob/master/lib/utils.sh#L3

[^1]: M1/M2 processors
