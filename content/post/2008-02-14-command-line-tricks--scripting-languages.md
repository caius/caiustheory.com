---
title: "Command line tricks: Scripting Languages"
slug: command-line-tricks--scripting-languages
author: "Caius Durling"
date: 2008-02-14 16:24:27 +0000
tag:
  - "geek"
  - "ruby"
  - "php"
  - "programming"
  - "code"
  - "cli"
  - "bash"
---

To search your php.ini file quickly and easily with the option to use regular expressions, I tend to drop back to the <acronym title="command line interface">cli</acronym>.  The reason for this is I can easily parse the output of `phpinfo()` with `grep`, and can do various things with the output, could even pass it to a script if I really wanted to.

Here is the line I use to search `phpinfo()`

```shell
echo "<?php phpinfo() ?>" | php | grep -i $search_string
```

It passes the string through the php interpreter and then searches through it with grep.

You can also do other nifty things with the shell & php + ruby especially (though I imagine python & perl work in the same way.) For instance I wanted to see if the following ruby would return the number of seconds since the [epoch][] till now.

[epoch]: http:/en.wikipedia.org/wiki/Unix_Time

```ruby
puts Time.now.to_i
```

Now I could fire up a PHP page and do something like the following

```php
<?php
  echo "php: " . time() . "\n";
  echo "ruby: " . `ruby -e 'print Time.now.to_i'` . "\n";
?>
```

But what if I've not got a web server with PHP running on the machine I'm using? Well then I could drop back to the shell and run it through `php` using `cat` as a way to insert multiple lines, and it would look like the following

```shell
cat <<PHP | php
<?php
  echo "php: " . time() . "\n";
  echo "ruby: " . `ruby -e 'print Time.now.to_i'` . "\n";
PHP

php: 1203004463
ruby: 1203004463
```

Now this works, but why do I want to remember all that php, and seeing as I have to drop back to the shell to access the ruby statement, why not just let the shell do all the work? So after a few seconds thinking, I came up with this

```shell
ruby -e 'puts "ruby: #{Time.now.to_i}"' && \
  echo '<?php echo "PHP: " . time() . "\n" ?>' | php
```

This runs the ruby code through `ruby` and the php code through `php` without dropping back to the shell from within a language interpreter :)

### Update:

Fangel pointed out `php -r` is the equivilent of `ruby -e` so the final commands could just be:

```shell
ruby -e 'puts "ruby: #{Time.now.to_i}"' && \
php -r 'echo "PHP: ".time()."\n";'
```
