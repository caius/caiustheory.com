---
title: "git git git git git"
date: 2017-09-26T11:00:23Z
author: Caius Durling
tag:
  - git
  - unix
---

Ever found you've accidentally entered too many `git`s in your terminal and wondered if there's a solution to it? I quite often type `git` then go away and come back, then type a full `git status` after it. This leads to a lovely (annoying) error out the box:

```shell
$ git git status
git: 'git' is not a git command. See 'git --help'.
```

What a git.

My initial thought was overriding the `git` binary in my `$PATH` and having it strip any leading arguments that match `git`, so we end up running just the `git status` at the end of the arguments. An easier way is to just use [`git-config`][gitconfig]'s `alias.*` functionality to expand the first argument being `git` to a shell command.

```shell
git config --global alias.git '!exec git'
```

Which adds the following git config to your `.gitconfig` file

```ini
[alias]
  git = !exec git
```

And then you'll find you can `git git` to your heart's content

```shell
$ git sha
cc9c642663c0b63fba3964297c13ce9b61209313

$ git git sha
cc9c642663c0b63fba3964297c13ce9b61209313

$ git git git git git git git git git git git git git git git git git git git git git git git git git git sha
cc9c642663c0b63fba3964297c13ce9b61209313
```

(`git sha` is an alias for `git rev-parse HEAD`.)

See what other git alias' I have in my [`~/.gitconfig`][gitconfig], and laugh at all the typo corrections I have in there. (Yes, git provides autocorrection if you enable it, but I'm used to these typos working!)

Now `git` back to doing useful things!

[git-config]: https://git-scm.com/docs/git-config
[gitconfig]: https://github.com/caius/zshrc/blob/master/dotfiles/gitconfig
