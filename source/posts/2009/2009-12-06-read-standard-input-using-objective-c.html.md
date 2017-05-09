---
title: "Read standard input using Objective-C"
author: "Caius Durling"
date: 2009-12-06 11:50:08 +0000
tags:
  - "geek"
  - "programming"
  - "code"
  - "cli"
  - "objective-c"
  - "google"
  - "objc"
---

On a couple of occasions now I've wanted to read from `STDIN` into an Objective-C command line tool, and both times I've had to hunt quite a bit to find the answer because nothing shows up in google for the search terms I used. "Objective-c read from stdin" and "objc read stdin" both turn up results ranging from using `NSInputStream` to dropping some C++ in there.

The answer is quite simple really, just use `NSFileHandle`. More specifically `+[NSFileHandle fileHandleWithStandardInput]`. You can then read all data currently in `STDIN`, monitor it for new data and anything else you can do with a normal `NSFileHandle`.

And here's some example code, reads all data from `STDIN` and stores it into an NSString:

```objc
NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
NSString *inputString = [[NSString alloc]
  initWithData:inputData encoding:NSUTF8StringEncoding];
```

*I'm using this in GarbageCollected apps, memory management without GC is left as an exercise to the user.*

