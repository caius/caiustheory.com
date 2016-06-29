---
title: "+[NSObject load] in MacRuby"
author: "Caius Durling"
created_at: 2010-06-12 02:11:32 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "code"
  - "apple"
  - "objective-c"
  - "ruby1.9"
  - "os x"
  - "mac"
  - "objc"
  - "SIMBL"
  - "MacRuby"
---

*If you've not heard of it, [MacRuby][] is <q>an implementation of Ruby 1.9 directly on top of Mac OS X core technologies such as the Objective-C runtime and garbage collector, the LLVM compiler infrastructure and the Foundation and ICU frameworks.</q> Basically means you write in Ruby using Objective-C frameworks, and vice versa. It's pretty damn cool to be honest!*

[MacRuby]: http://www.macruby.org/

### What is +[NSObject load]?

From the [documentation][load docs]:

> Invoked whenever a class or category is added to the Objective-C runtime; implement this method to perform class-specific behavior upon loading.

[load docs]: http://developer.apple.com/mac/library/documentation/cocoa/reference/foundation/Classes/NSObject_Class/Reference/Reference.html#//apple_ref/occ/clm/NSObject/load

This means when your class is loaded, and implements the `load` method, you get a `load` message sent to your class. Which means you can start doing stuff as soon as your class is loaded by the runtime.

The main place I've seen it used (and used it myself) is in [SIMBL][] plugins. A SIMBL plugin is an NSBundle that contains code which is loaded (injected) into a running application shortly after said application is launched. It lets you extend (or "fix") cocoa applications with additional features. So you have this bundle of code, that gets loaded into a running application some point after it starts, and you want to run some code as the bundle is loaded - usually to kick off doing whatever you want to do in the plugin. This is where `load` becomes useful.

[SIMBL]: http://www.culater.net/software/SIMBL/SIMBL.php

Here's a quick implementation that just logs to the console:

    @implementation MainController
    
    + (void) load
    {
        NSlog(@"MainController#load called");
    }

### Now where does MacRuby come into this?

Well I came across a need to do the same in ruby, have some code triggered when the class is loaded into the runtime. Tried implementing `Class.load` but to no avail. Then remembered MacRuby is just ruby! And I can call any code from within my ruby class definition.

For continuity I still call it `Class.load`, but then call it as soon as I've defined it in the class. Eg:

    class MainController
    
        def self.load
            NSLog "MainController#load called"
        end
        self.load
    
    end

Of course, I'm not sure when the Objective-C method is called, it's probably after the entire class has been defined rather than as soon as `load` has been loaded into the runtime. So you might want to move the `self.load` call to just before the closing `end`.

