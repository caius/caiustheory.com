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



```
$ cat .git-hooks/pre_commit/puppet_validate.rb
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

```
$ cat .overcommit.yml
# Use this file to configure the Overcommit hooks you wish to use. This will
# extend the default configuration defined in:
# https://github.com/brigade/overcommit/blob/master/config/default.yml
#
# For a complete list of hooks, see:
# https://github.com/brigade/overcommit/tree/master/lib/overcommit/hook
#
# For a complete list of options that you can use to customize hooks, see:
# https://github.com/brigade/overcommit#configuration

PreCommit:
  BundleCheck:
    enabled: true

  JsonSyntax:
    enabled: true

  LocalPathsInGemfile:
    enabled: true

  PuppetLint:
    enabled: true

  PuppetValidate:
    enabled: true
    description: 'Validates puppet syntax'
    include: '**/*.pp'

  ShellCheck:
    enabled: true

  TrailingWhitespace:
    enabled: true

  YamlSyntax:
    enabled: true
    on_warn: fail

PostCommit: &PostHandlers
  BundleInstall:
    enabled: true

  SubmoduleStatus:
    enabled: true

PostCheckout:
  <<: *PostHandlers

PostMerge:
  <<: *PostHandlers

PostRewrite:
  <<: *PostHandlers
```
