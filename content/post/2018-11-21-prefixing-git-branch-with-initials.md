---
title: "Prefixing Git Branch With Initials"
date: 2018-11-21T20:30:40+00:00
author: Caius Durling
reviewers:
  - James Inman
tag:
  - shell
  - git
---

Working somewhere where we prefix our branches with the creator's initials, I sometimes forget to do so.[^1] This leads to me having to rename the branch, typing out the whole name again after adding `cd/` to the start of it.

Computers are meant to solve repetitive problems for us, so let's put it to work in this case too. My [~/bin][binfiles] contains [`git current-branch`][git-current-branch], which returns the current branch name.

If we hardcode the initials, this becomes a simple command to recall from our history:[^2]

```shell
git branch --move --force cd/$(git current-branch)
```

But computers are supposed to solve all repetitive work, including knowing who I am, right? Correct, my local user account knows my full name, so we can work out my initials from that. Lets lean on the `id(1)` command to lookup the user's details then strip it down to just the initials.[^3][^4]

```shell
id -F
# => "Caius Durling"

id -F | sed -Ee 's/(^| )(.)[^ ]+/\2/g' | tr 'A-Z' 'a-z'
# => cd
```

Bingo, we can wrap that into a subshell passed to the branch move command and we're done in a one-liner.

```shell
git branch --move --force "$(id -F | sed -Ee 's/(^| )(.)[^ ]+/\2/g' | tr 'A-Z' 'a-z')/$(git current-branch)"
```


[^1]: I don't follow that policy for my personal repos, or working on forks of other people's code. And I'm human, so I forget.
[^2]: You can also replace `--move --force` with `-M`: `git branch -M newname`
[^3]: On macOS you can use `id -F` to return the full name of the user. Doing this on other platforms is left as an exercise for the reader.
[^4]: Yes, this is an incredibly naive way to initialize a name, but it's good enough for the people I work with. Handling edge cases is left as … you got it, an exercise for the reader.

[binfiles]: https://github.com/caius/BinFiles
[git-current-branch]: https://github.com/caius/BinFiles/blob/c7c5c6ababd70e65fa4d072bf8392aaa014c607c/git-current-branch
