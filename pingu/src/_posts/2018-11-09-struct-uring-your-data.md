---
title: "Struct-uring your data"
date: 2018-11-09T00:31:00Z
author: Caius Durling
tag:
  - Code
  - Ruby
---

In Ruby it's easy to structure data in hashes and pass it around, and usually that leads to errors with calling methods on `nil`, or misspelling the name of a key, or some such silly bug that we might catch earlier given a defined object with a custom Class behind it. But it's so much work to create a Class just to represent some grab bag of data we've been handed, right? Well, maybe!

Lets say we have some event data that we're being sent and we want to do some stuff with it in memory, we could just represent this as an array of hashes:

```ruby
events = [
  {
    name: "Writing",
    duration: 15,
    started: true,
    finished: false,
  },
  {
    name: "Evening walk",
    duration: 60,
    started: true,
    finished: true,
  }
]
```

This is not a *bad* way to represent the data, but if we want to start asking questions of it like "find all events currently happening" it becomes trickier. We could filter the collection to just those "in progress" events with the following

```ruby
events.select { |event| event[:started] && !event[:finished] }
```

Next time someone reads this though, they have to figure out what it means to have an event that's started but not finished. Also what happens when someone in future misremembers `:finished` as `:completed` when running over the data in new code?[^1] Wouldn't it be better if we could do the following instead?[^2]

```ruby
events.select { |event| event.in_progress? }
```

An easy way to do this is to just create a Struct for the event, with the extra method defined internally. Whilst we're in there, we could add a couple more methods to make us querying the state of boolean attributes nicer to read(eh?)

```ruby
Event = Struct.new(:name, :duration, :started, :finished) do
  alias_method :started?, :started
  alias_method :finished?, :finished

  def in_progress?
    started? && !finished?
  end
end
```

And then to create the objects, we can either use the positional arguments to `.new` (same order as the symbols given to `Struct.new`), or tap the object and use the setters directly for each attribute.

```ruby
events = [
  Event.new("Writing", 15, true, false),
  Event.new.tap { |e|
    e.name = "Evening Walk"
    e.duration = 60
    e.started = true
    e.finished = false
  },
]
# => [#<struct Event
#      name="Writing",
#      duration=15,
#      started=true,
#      finished=false>,
#     #<struct Event
#      name="Evening Walk",
#      duration=60,
#      started=true,
#      finished=false>]
```

Now we can use our easier-to-read code for selecting all in-progress events, or ignoring all of those. Or if we just want to grab all finished events, we now have a method to call—`Event#finished?`—that conveys the intent of what it returns without having to look up the data structure of the hash to work out if that field is a `String` or `Boolean`.[^3]

For super-powered structs, you don't even need to assign them to a `Constant`. You can just assign them to normal variables and use them locally in that scope without needing to define a constant.

```ruby
class Grabber
  def call
    result = Struct.new(:success, :output) do
      alias_method :success?, :success
    end

    if (data = grab_data)
      result.new(true, data)
    else
      result.new(false, nil)
    end
  end
end
```

That'll handily return you an object you can interrogate for `success?` and ask for the `output` if it was successful. And no Constants were created in the making of this method. 🎉

Keep an eye out for where you can Struct-ure your data. It might be more often than you expect.

[^1]: It would always returns `true` - `!nil`.
[^2]: That's `events.select(&:in_progress?)` for the golfers amongst you.
[^3]: `…?` methods in ruby are truthy/falsy by convention.

[struct docs]: https://ruby-doc.org/core-2.5.0/Struct.html
