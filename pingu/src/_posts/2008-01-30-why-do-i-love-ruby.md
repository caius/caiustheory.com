---
title: "Why do I love Ruby?"
author: "Caius Durling"
date: 2008-01-30 14:15:24 +0000
tag:
  - "geek"
  - "tech"
  - "mother"
  - "ruby"
  - "php"
  - "programming"
---

So mother (who can't program) just posed me the question

> Why is Ruby your favourite programming language?

Me being a show off jumped straight into [TextMate][tm] and banged out some code in real time to show her.  First up, a quick little one-liner of Ruby code to output a String:

```ruby
puts "Hello World"
# => "Hello World"
```

So she goes, "Sure, but whats so brilliant about that?" So I just decide to reverse the string, have it output in reverse order:

```ruby
puts "Hello World".reverse
# => "dlroW olleH"
```

Then the next question comes, "So what makes that so much easier than in other languages?" Well now I was thinking on the spot about which other language I can bang out a quick example in without having to look up too much information.  PHP seems the logical choice, being the language I know best behind Ruby.

Thinking about how to do it in PHP, I can't think of a function to reverse the content of a string, but I know that `array_reverse()` exists, so I just split it into an array and reverse that array.  Only problem is I can't remember how to split a string by `""`, I don't think `explode( "", $var )` does the job.  So I quickly jump in and write the following code to test my concern.

```php
<?php
  $a = "Hello World"
  $b = explode( "", $a );
  $c = array_reverse( $b );
  echo implode( "", $c );
?>
# => ERROR
```

The reason for the error is because I've missed a semi colon off the end of line 2, to this I get the response, "well thats certainly not as nice as ruby." Just because one little character is missing!

So I fix the semi colon and run it again, now I get an error complaining about explode not being able to split by a missing delimiter (the empty string - `""`)  So I go hunting through the [php.net][php] docs and find `str_split()`, which does exactly what I want it to.

In replacing `explode()` with `str_split()` and running it via the `php` command line binary, I realise that I haven't got any `\n` (newlines) at the end of it, so it doesn't display nicely in the terminal.  I thus update the script to the following and show her the result:

```php
<?php
  $a = "Hello World";
  $b = explode( "", $a );
  $c = array_reverse( $b );
  echo implode( "", $c )."\n";
?>
# => "dlroW olleH"
```

And so she goes away seeing why I prefer Ruby to other languages for _most_ programming I do. There are things Ruby fails at (and don't get me started on why rails isn't going to replace php!) and other places where it succeeds very well.

But each to their own, and my own favourite is Ruby!

[tm]: http://macromates.com/
[php]: http://php.net/

### Update

As pointed out in the comments, if I had looked a bit further I would've found `strrev()` which does the same as the `reverse` method in Ruby.  So in fact the final code would be:

```ruby
puts "Hello World".reverse
```

vs

```php
<?php
  echo strrev( "Hello World" );
?>
```

So it turns out this was a bad way to show why I prefer Ruby to PHP code wise to mother, think I might have to just bite the bullet and write about why I prefer `object.method` to `method( object )`!
