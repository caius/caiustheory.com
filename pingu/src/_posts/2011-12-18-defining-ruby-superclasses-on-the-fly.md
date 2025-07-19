---
title: "Defining Ruby Superclasses On The Fly"
author: "Caius Durling"
date: 2011-12-18 01:13:14 +0000
tag:
  - "geek"
  - "ruby"
  - "code"
  - "ruby19"
  - "hack"
---

Any rubyist that's defined a class should understand the following class definition:

```ruby
class Foo < Object
end
```

It creates a new Constant (`Foo`) that is a subclass of `Object`. Pretty straightforward. But what you might not know is that ruby executes each line it reads in as it reads them. So we could do the following to show that:

```ruby
class Foo < Object
  puts "we just defined object!"
end
```

And get the following output when we run that file:

```ruby
# >> we just defined object!
```

So.. we know ruby is executing things on the fly whilst defining classes for us. How can we use this for profit and shenanigans?! (Err, use this for vanquishing evil and creating readable code I mean. Honest.)

How about if we've got a couple of opinionated people who like to think they've got the biggest ego in the interpreter? The last one to be loaded likes to have any new people ushered into the interpreter to be a subclass of themselves. Lets abuse a global for storing it in, and use a method to choose that on the fly when creating a new class.

```ruby
def current_awkward_bugger
  $awkward_bugger
end

class Simon
end
$awkward_bugger = Simon

class Fred < current_awkward_bugger()
end
Fred.superclass # => Simon

class Harold
end
$awkward_bugger = Harold

class John < current_awkward_bugger()
end
John.superclass # => Harold

Fred.superclass # => Simon
```

Okay, so that looks a bit different to normally defined classes. We create `Simon`, assign him to the awkward bugger global then create `Fred`, who subclasses the return value of the `current_awkward_bugger` method which happens to be `Simon` currently. Then `Harold` muscles his way into the interpreter and decides he's going to be the current awkward bugger, so poor `John` gets to subclass `Harold` even though he's defined in the same way as `Fred`. (And as you can see on the last line, Fred's superclass is unchanged even though we changed the `awkward_bugger` global.)

On a somewhat related note there's a lovely method called `const_missing` that gets invoked when you call a Constant in ruby that isn't defined. (Much like `method_missing` if you're familiar with that.) Means you can do even more shenanigans with non-existent superclasses for classes you're defining.

```ruby
class Simon
end
class Harold
end

class Object
  def self.const_missing(konstant)
    [Simon, Harold].shuffle.first
  end
end

class Fred < ArrogantBastard
end
Fred.superclass # => Simon

class Albert < ArrogantBastard
end
Albert.superclass # => Harold
```

So here we're choosing from Simon and Harold on the fly each time a missing constant is referenced (in this case the aptly named `ArrogantBastard` constant.) If you run this code yourself you'll see the superclasses change on each run according to what your computer picks that time.
