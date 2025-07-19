---
title: "Some Small Refactorings in Ruby"
author: "Caius Durling"
date: 2013-01-16 12:23:54 +0000
tag:
  - "geek"
  - "tech"
  - "ruby"
  - "code"
---

Here's a few things I refactor as I write code down initially. Not entirely convinced it's strictly refactoring, but it's how I amend from one pattern I see in a line or three of code into a different structure that I feel achieves the same result with cleaner or more concise code.

### Multiple equality comparisons

Testing the equality of an object against another is fairly simple, just do `foo == "bar"`. However, I usually try to test against multiple objects in a slightly different way. Your first thought might be that the easiest way is just to chain a series of `==` with the OR (`||`) operator.

```ruby
foo == "bar" || foo == "baz" || foo == :sed || foo == 5
```

I much prefer to flip it around, think of the objects I'm testing against as a collection (`Array`), and then ask them if they contain the object I'm checking. And for that, I use `Array#include?`

```ruby
["bar", "baz", :sed, 5].include?(foo)
```

*(And if you're only testing against strings, you could use `%w(bar baz)` as a shortcut to create the array. Here's more [ruby shortcuts][].)*

[ruby shortcuts]: http://caiustheory.com/ruby-shortcuts

### Assigning multiple items from a nested hash to variables

Occasionally I find myself needing to be given a hash of a hash of data (most recently, an [omniauth][] auth hash) and assign some values from it to separate variables within my code. Given the following hash, containing a nested hash:

[omniauth]: https://github.com/intridea/omniauth/wiki

```ruby
details = {
  uid: "12345",
  info: {
    name: "Caius Durling",
    nickname: "caius",
  },
}
```

Lets say we want to extract the name and nickname fields from `details[:info]` hash into their own local variables (or instance variables within a class, more likely.) We should probably handle the case of `details[:info]` not being a hash, and try not to read from it if that's the case - so we might end up with something like the following:

```ruby
name = details[:info] && details[:info][:name]
nickname = details[:info] && details[:info][:nickname]

name # => "Caius Durling"
nickname # => "caius"
```

And then in the spirit of [DRYing][] up our code, we see there's duplication in both lines in checking `details[:info]` exists (not actually that it's a hash, but hey ho, we rely on upstream to send us `nil` or a hash.) So we reduce it down using an if statement and give ourselves slightly less to type at the same time.

[DRYing]: http://en.wikipedia.org/wiki/Don't_repeat_yourself

```ruby
if (( info = details[:info] ))
  name = info[:name]
  nickname = info[:nickname]
end

name # => "Caius Durling"
nickname # => "caius"
```

### Returning two values conditionally

Sometimes a method will end with a ternary, where depending on a condition it'll either return one or another value. If this conditional returns true, then the first value is returned. Otherwise it returns the second value. You could quite easily write it out as an if/else longer-form block too.

```ruby
def my_method
  @blah == foo ? :foo_matches : :no_match
end
```

My brain finds picking the logic in this apart slightly harder mentally, than if I drop a [return early][] bomb on the method. Then it reads more akin to how I'd think through the logic. Return the first value if this conditional returns true. Otherwise the method returns this second value. I think the second value being on a completely separate line helps me make this mental distinction quicker too.

[return early]: http://en.wikipedia.org/wiki/Return_early

So I'd write it this way:

```ruby
def my_method
  return :foo_matches if @blah == foo
  :no_match
end
```

### Returning nil or a value conditionally

Following on from the last snippet, but taking advantage of the ruby runtime a bit more, is when you're wanting to return a value if a conditional is true, or otherwise false. The easy way is to just write `nil` in the ternary:

```ruby
def my_method
  @foo == :bar ? :foo_matches : nil
end
```

However, we know ruby returns the result of the last expression in the method. And that if a single line conditional isn't met, it returns nil from the expression. Combining that, we can rewrite the previous example into this:

```ruby
def my_method
  :foo_matches if @foo == :bar
end
```

And it will still return nil in the case that `@foo` doesn't match `:bar`.

### Returning a boolean

Sometimes you have a method that returns the result of a conditional, but it's written to return true/false in a conditional instead.

```ruby
def my_method
  @foo == :bar ? true : false
end
```

The really easy refactor here is to just remove the ternary and leave the conditional.

```ruby
def my_method
  @foo == :bar
end
```

And of course if you were returning `false` when the conditional evaluates to `true`, you can either negate the comparison (use `!=` in that example), or negate the entire conditional result by prepending `!` to the line.
