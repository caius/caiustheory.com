---
title: "jj jj jj jj jj"
date: "2025-12-23T10:00:00Z"
tag:
  - "git"
  - "jj"
  - "unix"
---

In a similar vein to [git git git git git][], if you're using [jj][] and find you've accidentally typed one `jj` too many in the command line, it errors at you. In this case we're trying to pull the id of the current changeset we're editing:

```sh
$ jj jj show -T 'change_id.short()'
error: unrecognized subcommand 'jj'

Usage: jj [OPTIONS] <COMMAND>

For more information, try '--help'.
```

How annoying. Now we could solve this with a shell alias, but `jj` also allows us to define alias' in the configuration (much like git!), and combined with [`jj util exec`][jj util exec] we should be able to have it run the rest of the line nay bother.

Thinking it through, the initial `jj` will be exec'd by the shell, so that's gone already. The second `jj` is then evaluated as the alias, so that's gone too. The remaining arguments passed to the alias are `["show", "-T", "change_id.short()"]` so if we just exec those it'll error trying to run `show` as a binary. We can avoid that by having it exec jj then the arguments from the alias.

Drop the alias in a jj config file (`jj config edit` is super useful for editing these, or there's `jj config  set` to update it from the shell) and then we can test it works.

```toml
[aliases]
# jj all the way down
jj = ["util", "exec", "jj"]
```

Lets try our original nested command again and see if we get to see our sweet sweet change id:

```sh
$ jj jj show -T 'change_id.short()'
error: unexpected argument '-T' found

  tip: to pass '-T' as a value, use '-- -T'

Usage: jj util exec [OPTIONS] <COMMAND> [ARGS]...

For more information, try '--help'.
```

Oh. Our `-T` argument is being interpreted by `jj util exec`, not by the `jj` command we're running. Classic nested argument parsing when you're trying to invoke another command. Luckily shell/exec has a solution to this, passing `--` as an argument stops parsing all remaining arguments so they are passed along verbatim.

With that in mind we can amend our alias to run `jj util exec` and then stop interpreting any further arguments.

```toml
[aliases]
# jj all the way down
jj = ["util", "exec", "--", "jj"]
```

Now we should be able to see our change id without any issues, no matter how many nested `jj`s there are in the command!

```sh
$ jj show -T 'change_id.short()'
upvqxuzzvxtx

$ jj jj show -T 'change_id.short()'
upvqxuzzvxtx

$ jj jj jj jj jj show -T 'change_id.short()'
upvqxuzzvxtx

$ jj jj jj jj jj jj jj jj jj jj jj jj jj jj jj jj jj show -T 'change_id.short()'
upvqxuzzvxtx
```

Happy committing.

[git git git git git]: /git-git-git-git-git/
[jj]: https://www.jj-vcs.dev/
[jj util exec]: https://docs.jj-vcs.dev/latest/cli-reference/#jj-util-exec
