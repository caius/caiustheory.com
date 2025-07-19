---
title: "Programatically invoke rake task with --trace enabled"
date: "2024-10-01T22:42:00Z"
author: "Caius Durling"
tag:
  - "code"
  - "geek"
  - "ruby"
  - "programming"
---

[Rake][] is a Make-like program implemented in Ruby _(to quote the website.)_ It contains tasks written in ruby code you can invoke from the command line. These can run prequisite tasks first too, in this case we configure the `setup` task to be invoked before the `work` task is ever invoked.

```ruby
task :setup do
  puts "Setting up"
end

task work: :setup do
  puts "Doing work"
end
```

```sh
$ rake work
Setting up
Doing work
```

Rake also supports `--trace` as an argument which outputs a bunch of debugging information, allowing you to see which tasks have been executed in which order and how often they were invoked.


```sh
$ rake --trace work
** Invoke work (first_time)
** Invoke setup (first_time)
** Execute setup
Setting up
** Execute work
Doing work
```

From the `--trace` output we can see calling the same task multiple times in the same rake process doesn't execute the task multiple times, but it is invoked the correct number of times.

```sh
$ rake --trace work setup work
** Invoke work (first_time)
** Invoke setup (first_time)
** Execute setup
Setting up
** Execute work
Doing work
** Invoke setup
** Invoke work
```

For performance reasons ([Rails][RoR] apps can take multiple seconds to start a new process), we might want to run multiple tasks within the same `rake` process.

```ruby
task :create_assets do
  puts "Created some assets"
end
```

We're now stuck in a catch-22 from the shell in terms of tracing however, if we run both tasks in the same process we can only trace both, or trace neither.

```sh
$ rake --trace create_assets work
** Invoke create_assets (first_time)
** Execute create_assets
Created some assets
** Invoke work (first_time)
** Invoke setup (first_time)
** Execute setup
Setting up
** Execute work
Doing work

$ rake create_assets work
Created some assets
Setting up
Doing work
```

If we've previously been calling multiple tasks in different commands and only tracing some of them, we want to maintain the same output in our CI system logs but also reap the performance benefit of not booting the app multiple times over. This means having tracing enabled for some tasks, but not others which we can't do from the shell.

Luckily there's another mechanism to invoke multiple rake tasks, we define a new rake task that can then call the other rake tasks and setup tracing before calling the last one by [mimicking the internals of `rake --trace`][rake--trace].

(`Rake::Task.[]` lets you find rake tasks by their labels, and then `Rake::Task#invoke` calls the code defined for the task as if you'd run `rake whatever` on the cli.)

```ruby
task :ci_perform do
  Rake::Task["create_assets"].invoke

  # Enable `--trace` programatically for remaining tasks invoked
  Rake.application.options.trace = true
  Rake.application.options.backtrace = true
  Rake.application.options.trace_output = $stderr
  Rake.verbose(true)

  Rake::Task["work"].invoke
end
```

Et voila, we get our trace output for the `work` task but not until that's invoked.

```sh
$ rake ci_perform
Created some assets
** Invoke work (first_time)
** Invoke setup (first_time)
** Execute setup
Setting up
** Execute work
Doing work
```

[Rake]: https://ruby.github.io/rake/
[RoR]: https://rubyonrails.org
[rake--trace]: https://github.com/ruby/rake/blob/4538838a4b9d2cbfa1e231716a2183e65241b52e/lib/rake/application.rb#L613-L622
