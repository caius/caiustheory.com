---
title: "Sending Array elements as individual arguments in Ruby"
author: "Caius Durling"
date: 2008-12-26 07:25:15 +0000
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
---

Lets imagine we've got an array of strings, and we want to print it out as a list of strings using printf. *(If you're complaining about my logic here, hold fire for just a second good sir/madam.)*

So we start off with the array of strings, and then pass it to printf with the right amount of `%s`'s in the format string:

```ruby
arr = ["one", "two", "three"]

printf "%s, %s, %s", arr
# ~> -:3:in `printf': too few arguments (ArgumentError)
# ~>     from -:3
```

Oh whoops, we've actually only passed `"%s, %s, %s", ["one", "two", "three"]` to printf. So of course it whinges about not getting enough arguments. Now how do we fix this, how **do** we pass an array with each element a seperate argument to a method?

We use the `*` of course! Just prefix the variable name with `*` and the method is passed each element as separate arguments, rather than the whole array as one arguement.

Going back to our `printf` example above, we simply insert one character *(the lowly `*`)* and end up with a string being outputted.

```ruby
printf "%s, %s, %s", *arr
# >> one, two, three
```

Now I realise this is a partially stupid example, but it serves to explain the point I wanted to make. If you were complaining about my choice of printf earlier, here is the way I think most rubyists would solve this problem instead.

```ruby
arr = ["one", "two", "three"]

print arr.join(" ")
# >> one two three
```

And if I wanted to be slightly cleverer with the `printf` version, and print out an array containing an unknown number of strings, but of a set width, then I could do the following. *(NB: This is actually how I ran into this problem.)*

```ruby
arr = ["one", "two", "three"]

printf arr.map { "%6s" }.join, *arr
# >>    one   two three
```

And that is where the lowly `*` comes in.
