---
title: "GTranslate"
author: "Caius Durling"
date: 2009-01-04 09:40:59 +0000
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
  - "gtranslate"
  - "google"
  - "translation"
---

I finally wrapped up some code I've been meaning to write for a while, its a wrapper for the [Google Translate API][gtapi]. Its also the first serious time I've used `method_missing` in a class, in this case its to add methods for translating between all the various languages.

[gtapi]: http://translate.google.com/

Its fairly simple to use, there is an [examples.rb][eg] included with it, but the basic usage is just this:

[eg]: http://github.com/caius/gtranslate/tree/master/examples.rb

```ruby
# Convert from english to french
Google::Translate.english_to_french( "Hello" ) # => "Bonjour"

# There is also a short(er)-hand version
Google::Tr.en_to_fr( "Hello" )
```

As per usual with all my code its available on my [github account][GH], as the [GTranslate][gt] project. I'll throw some specs together for it and package it up as a gem soon.

[GH]: http://github.com/caius/
[gt]: http://github.com/caius/gtranslate/

