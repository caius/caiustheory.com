---
title: "Compile & run swift files directly"
author: "Caius Durling"
date: 2014-06-06 14:32:18 +0000
tag:
  - "apple"
  - "swift"
  - "unix"
  - "shebang"
---

Turns out you can run a swift file without having to compile it into a binary somewhere and then run that binary. Makes swift behave a bit more like a scripting language like ruby or python when you need it to.

Using the `xcrun` binary, we can reach into the current Xcode `/bin` folder and run binaries within there. So `xcrun swift` lets you run the swift binary to compile files for instance. If you view the help with `-h`, there's a useful flag `-i` listed there:

> -i &nbsp;&nbsp; Immediate mode

Turns out immediate mode means "compile & run" in the same command, which is what we're after.

    $ cat hello.swift
    println("Hello World")

    $ xcrun swift -i hello.swift
    Hello World

Bingo. But what if we want to make hello.swift executable and call it directly without having to know it needs the swift binary to call it. Unix lets files define their shebang to say how the file needs to be executed, so lets go for that here too!

    $ cat hello2.swift
    #!/usr/bin/env xcrun swift -i
    println("Hello World 2")

    $ chmod +x hello2.swift
    $ ./hello2.swift
    Hello World 2

No more having to fire up Xcode for quick CLI tools, especially ones using the system frameworks!
