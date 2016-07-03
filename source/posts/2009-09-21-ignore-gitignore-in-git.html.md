---
title: "Ignore .gitignore in Git"
author: "Caius Durling"
date: 2009-09-21 06:00:00 +0000
tags:
  - "geek"
  - "tech"
  - "programming"
  - "cli"
  - "bash"
  - "modification"
  - "git"
  - "tips"
  - "hack"
---

Recently I ran into an issue where I was working on a project which had files I wanted git to ignore, but I didn't want to commit a `.gitignore` file into the project. In case you don't know, any files matching a pattern in `.gitignore` in a git repository are ignored by git. (Unless the file(s) have already been committed, then they need removing from git before they are ignored.)

Initially I figured I could just throw the patterns I needed excluded into my global `~/.gitignore`, but quickly realised that I needed files matching these patterns to show up in other git repos, so going the global route really wasn't an option. After some thought I wondered if you could make git ignore `.gitignore`, whilst still getting it to ignore files matching the other patterns in the `.gitignore`.

Lets create a new empty repo to test this crazy idea in:

    $ mkdir foo
    $ cd foo
    $ git init
    Initialized empty Git repository in /Volumes/Brutus/Users/caius/foo/.git/

And create a couple of files for us to play with:

    $ touch bar
    $ touch baz

Ignore one of the files so we can check other matches are still ignored later on:

    $ echo "baz" >> .gitignore
    $ git status
    # On branch master
    #
    # Initial commit
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #       .gitignore
    #       bar
    nothing added to commit but untracked files present (use "git add" to track)

Ok so far, but we can still see .gitignore in git, so now for the crazy shindig, ignore the ignore file:

    $ echo ".gitignore" >> .gitignore 

Lets see if it worked, or if we can still see our .gitignore:

    $ git status
    # On branch master
    #
    # Initial commit
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #       bar
    nothing added to commit but untracked files present (use "git add" to track)

And lets just double-check that `.gitignore` and `baz` still exist on the filesystem:

    $ ls -a
    .  ..  .git  .gitignore  bar  baz

Fantastic! Turns out adding ".gitignore" to `.gitignore` works perfectly. The file is still parsed by git to ignore everything else too, so it does exactly what I needed in this instance.
