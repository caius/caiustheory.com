---
title: "Automatically Deploying Website From Remote Git Repository"
author: "Caius Durling"
date: 2009-05-30 02:30:40 +0000
tag:
  - "geek"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "git"
  - "website"
  - "deployment"
  - "ssh"
---

Before I start, I'll just quickly run through where I put stuff on my server. Apache logs and config are in the ubuntu default folders: `/var/log/apache2` and `/etc/apache2/` respectively.

    Websites:  /home/caius/vhosts/<domain name>/htdocs
    Git Repos: /home/caius/git/<domain name>.git

So I have a git repo locally, `~/projects/somesite.com/`, and want to deploy it to my webserver. I'll keep the git repo in `~/git/` and set it up so that when I push to the repo *(over ssh)* it will automatically checkout the new changes into the website's htdocs folder.

I'm assuming DNS is already setup (or I've used [ghost][] to map it locally.) And that I've setup the virtualhost in apache pointing at `/home/caius/vhosts/somesite.com/htdocs` and reloaded apache so the config is in place.

[ghost]: http://github.com/bjeanes/ghost/tree/master

## Remote Machine

We create a bare git repo, then point the working tree at the docroot of our website. This means all the git stuff is kept in the `somesite.git` folder, but the files themselves are checked out to the website's folder. Then we setup a post-receive hook to update the worktree folder after new changes have been pushed to the repo.

    $ cd git
    $ mkdir somesite.git
    $ cd somesite.git/
    $ git init --bare
    Initialized empty Git repository in /home/caius/git/somesite.git/
    $ git --bare update-server-info
    $ git config core.worktree /home/caius/vhosts/somesite.com/htdocs
    $ git config core.bare false
    $ git config receive.denycurrentbranch ignore
    $ cat > hooks/post-receive
    #!/bin/sh
    git checkout -f
    ^D
    $ chmod +x hooks/post-receive

## Local Machine

And now on the client machine we add the remote repo as a git remote, and then push to it.

    $ git remote add web ssh://myserver/home/caius/git/somesite.git
    $ git push web +master:refs/heads/master
    Counting objects: 3, done.
    Writing objects: 100% (3/3), 229 bytes, done.
    Total 3 (delta 0), reused 0 (delta 0)
    To ssh://myserver/home/caius/git/somesite.git
     * [new branch]      master -> master

## All Done

And now if you go to *somesite.com* you'll see the contents of your git repo there. (*somesite.com* is just an example url though, I don't actually own it!)

### Helpful URLs

* <http://toroid.org/ams/git-website-howto>
* <http://www.mblondel.org/journal/2008/05/25/git-memo/>
* <http://tatey.com/2009/04/29/jekyll-meets-dreamhost-automated-deployment-for-jekyll-with-git.html>
