---
title: "Ruby Shortcuts"
author: "Caius Durling"
date: 2010-03-18 22:32:45 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "code"
  - "tips"
---

There's a few useful shorthand ways to create certain objects in Ruby, a couple of obvious ones are `[]` to create an `Array` and `{}` to create a `Hash` (Or block/`Proc`). There's some not so obvious ones too, for creating strings, regexes and executing shell commands.

With all of the examples I've used `{}` as the delimiter characters, but you can use a variety of characters. Personally I tend to use `{}` unless the string contains them, in which case I'll use `//` or `@@`. My only exception appears to be `%w`, for which I tend to use `()`.

### Strings

`%` and `%Q` are the same as using double quotes, including string interpolation. Really useful when you want to create a string that contains double quotes, but without the hassle of escaping them.

    %{}                 # => ""
    %Q{}                # => ""
    
    %{caius}            # => "caius"
    %{caius #{5}}       # => "caius 5"
    %{some "foo" thing} # => "some \"foo\" thing"

`%q` is equivalent to using single quotes. Behaves exactly the same, no string interpolation.

    %q{}           # => ''
    %q{caius}      # => "caius"
    %q{caius #{5}} # => "caius \#{5}"

### Arrays

`%w` is the equivalent of using String#split. It takes a string and splits it on whitespace. With the added bonus of being able to escape whitespace too. `%W` allows string interpolation.

    %w(foo bar sed)  # => ["foo", "bar", "sed"]
    %w(foo\ bar sed) # => ["foo bar", "sed"]
    %W(foo #{5} bar) # => ["foo", "5", "bar"]

### Regexes

`%r` is just like using `//` to create a regexp object. Comes in handy when you're writing a regex containing `/` as you don't have to continually escape it.

    %r{foo|bar} # => /foo|bar/
    %r{foo/bar} # => /foo\/bar/

### Symbols

`%s` creates a symbol, just like writing `:foo` manually. It takes care of escaping the symbol, but unlike `:""` it doesn't allow string interpolation however.

    %s{foo}      # => :foo
    %s{foo/bar}  # => :"foo/bar"
    :"foo-#{5}"  # => :"foo-5"
    %s{foo-#{5}} # => :"foo-\#{5}"

### Shelling out

`%x` is the same as backticks (<code>``</code>), executes the command in a shell and returns the output as a string. And just like backticks it supports string interpolation.

    `echo hi`     # => "hi\n"
    %x{echo hi}   # => "hi\n"
    %x{echo #{5}} # => "5\n"
