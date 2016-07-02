---
title: "Why I love DATA"
author: "Caius Durling"
date: 2013-01-08 19:09:42 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "code"
  - "cli"
  - "mac"
---

In a ruby script, there's a keyword `__END__` that for a long time I thought just marked anything after it as a comment. So I used to use it to store snippets and notes about the script that weren't really needed inline. Then one day I stumbled across the `DATA` constant, and wondered what flaming magic it was.

`DATA` is in fact an IO object, that you can read from (or anything else you'd do with an IO object). It contains all the content after `__END__` in that ruby script file<a href="#fn1">*</a>. (It only exists when the file contains `__END__`, and for the first file ruby invokes though. See <a href="#fn1">footnote</a> for more details.)

How can we use this, and why indeed do I love this fickle constant? I mostly use it for quick scripts where I need to process text data, rather than piping to STDIN.

Given a list of URLs that I want to open in my web browser and look at, I could do the following for instance:

    DATA.each_line.map(&:chomp).each do |url|
      `open "#{url}"`
    end

    __END__
    http://google.com/
    http://yahoo.com/

which upon running (on a mac) would open all the URLs listed in DATA in my default web browser. (For bonus points, use [Launchy][] for cross-platform compatibility.) Really handy & quick/simple when you've got 500+ URLs to open at once to go through. (I once had a job that required me to do this daily. Fun.)

[Launchy]: https://github.com/copiousfreetime/launchy#readme

Or given a bunch of CSV data that you just want one column for, you could reach for `cut` or `awk` in the terminal, but ruby has a really good CSV library which I trust and know how to use already. Why not just use that & `DATA` to pull out the field you want?

    require "csv"

    CSV.parse(DATA, headers: true).each do |row|
      puts row["kName"]
    end

    __END__
    kId,kName,kURL
    1,Google UK,http://google.co.uk
    2,"Yahoo, UK",http://yahoo.co.uk

    # >> Google UK
    # >> Yahoo, UK

I find when the data I want to munge is already in my clipboard, and I can run ruby scripts directly from text editors without having to save a file, it saves having to write the data out to a file, have ruby read it back in, etc just to do something with the data. I can just write the script reading from `DATA`, paste the data in and run it. Which also lets me run it iteratively and build up a slightly more complex script that I don't want to keep. Then do what I need with the output and close the file without saving it.

<span id="fn1">\*</span> technically DATA is an IO handler to read `__FILE__`, which has been wound forward to the start of the first line after `__END__` in the file. And it only exists for the first ruby file to be invoked by the interpreter.

    $ cat > tmp/data.rb <<RB
    p DATA.read
    __END__
    data.rb
    RB

    $ ruby tmp/data.rb
    "data.rb\n"

    $ cat > tmp/data-require.rb <<RB
    require "./tmp/data"
    RB

    $ ruby tmp/data-require.rb
    /Users/caius/tmp/data.rb:1:in `<top (required)>': uninitialized constant DATA (NameError)

And because it's a handle to `__FILE__` though, you can rewind it and read the entire ruby script into itself…

    $ ruby tmp/readself.rb 
    DATA.rewind
    print DATA.read

    __END__
    something goes here

