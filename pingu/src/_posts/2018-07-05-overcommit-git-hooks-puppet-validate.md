---
title: "Overcommit git hooks: puppet validate"
date: 2018-07-05T14:44:41Z
author: Caius Durling
tag:
  - bash
  - cli
  - code
  - git
  - overcommit
  - ruby
---

Computers are great at automatically checking things, and git has a mechanism for running hooks before events happen. Bosh these two things together and you can have git trigger anything you like before you're allowed to commit, which in turn means you can sanity check exactly what you're committing to make sure it meets whatever criteria you have.

To make it easy to manage my git hooks in a consistent fashion, I use a tool called [overcommit][]. This comes with a config file to tell it what you want triggered when, and a bunch of standard plugins to choose from.

In a [puppet][] repo for instance, I have it check

* [bundler][] is happy everything's installed
* [puppet-lint][] is happy with any changed puppet files
* Any JSON or YAML files involved in the commit have valid syntax
* Any shell scripts are valid (according to [shellcheck][])
* There is no trailing whitespace left in files

This usually means something like the following in `.overcommit.yml` in the git repo

```yaml
PreCommit:
  BundleCheck:
    enabled: true

  JsonSyntax:
    enabled: true

  PuppetLint:
    enabled: true

  ShellCheck:
    enabled: true

  YamlSyntax:
    enabled: true
    on_warn: fail
```

For the most part this works absolutely great. I have on occasion noticed that [puppet-lint][] will let invalid puppet syntax slip through though which is irritating to find after you've pushed the changes up to the puppetmaster. The [puppet][] command line tool has a validate subcommand however, so we can hook that into overcommit as a custom hook in the repo.

To do this we need to add our custom hook into the right directory, and we're adding a hook to run before commits, so it goes into `.git-hooks/pre_commit`. Lets name it for what it does, validating puppet syntax. So into `puppet_validate.rb` we put the following:

```ruby
# .git-hooks/pre_commit/puppet_validate.rb
module Overcommit::Hook::PreCommit
  class PuppetValidate < Base
    def run
      errors = []

      result = execute(%w(puppet parser validate), :args => applicable_files)
      return :pass if result.success?

      [:fail, result.stderr]
    end
  end
end
```

Then we need to tell [overcommit][] that it needs to run this custom hook as a check whenever we commit, that goes into `.overcommit.yml` under the `PreCommit` key:

```yaml
PreCommit:
  PuppetValidate:
    enabled: true
    description: 'Validates puppet syntax'
    include: '**/*.pp'
```

Hey voila, along with all our other safety checks we're now checking that any puppet files added or changed in the repo have valid syntax.


[overcommit]: https://github.com/brigade/overcommit
[puppet-lint]: http://puppet-lint.com
[puppet]: https://puppet.com
[bundler]: https://bundler.io
[shellcheck]: https://www.shellcheck.net
