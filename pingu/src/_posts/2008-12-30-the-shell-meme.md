---
title: "The Shell Meme"
author: "Caius Durling"
date: 2008-12-30 18:29:35 +0000
tag:
  - "geek"
  - "tech"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "brightbox"
---

I ran across [The Shell Meme][tsm] on [Lincoln Stoll's][stoll] blog, and figured I'd, uh, *borrow* it.

[tsm]: http://lstoll.net/2008/04/shell-meme/
[stoll]: http://lstoll.net/

Run this command in a new shell:

```shell
history | awk '{ a[$2]++ } END { for(i in a){printf "%5d\t%s\n ",a[i],i} }' | \
  sort -rn | head
```

I get this as the output

    379    git
    221    cd
    181    ssh
    77    sudo
    69    ruby
    66    ls
    34    rake
    33    m
    32    bb
    31    m.

`bb` changes directory straight into my [BrightBox][bb] source directory. `m` and `m.` are [TextMate][tm] alias's to open files or directories in TextMate for editing.

[bb]: http://www.brightbox.co.uk/
[tm]: http://macromates.com/
