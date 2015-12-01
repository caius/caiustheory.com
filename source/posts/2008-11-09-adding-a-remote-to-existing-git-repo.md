---
title: "Adding a remote to existing git repo"
author: "Caius Durling"
date: 2008-11-09 18:32:55 +0000
tags:
  - "geek"
  - "programming"
  - "code"
  - "cli"
  - "bash"
  - "git"
---

Usually for me this happens when I have an existing project and I setup a [github][] repo for it. As part of the setup for the github project, it gives you the commands to run to add the github repo as a remote to my local git repo.

[github]: http://github.com/

    cd existing_git_repo
    git remote add origin git@github.com:caius/foo.git
    git push origin master
  
The problem then is you've added the remote account, but the local master branch isn't tracking the remote master branch, so when you try and just `git pull` it will fail with a message telling you to set the remote refs up.

> Julius:foo(master) caius$ git pull  
> You asked me to pull without telling me which branch you  
> want to merge with, and 'branch.master.merge' in  
> your configuration file does not tell me either.  Please  
> name which branch you want to merge on the command line and  
> try again (e.g. 'git pull <repository> <refspec>').  
> See git-pull(1) for details on the refspec.  
> 
> If you often merge with the same branch, you may want to  
> configure the following variables in your configuration  
> file:
> 
>     branch.master.remote = <nickname>
>     branch.master.merge = <remote-ref>
>     remote.<nickname>.url = <url>
>     remote.<nickname>.fetch = <refspec>
> 
> See git-config(1) for details.

The answer is to do what it says funnily enough, and add the remote refs tracking to the config file. The easiest way I've found of doing this is to edit `.git/config` and add the following at the bottom of it.

    [branch "master"]
        remote = origin
        merge = refs/heads/master

*Remember to change the branch or remote names if you need to.*

Once you've added that to the config you can run `git pull` on the master branch and it'll do the usual automagical thing and pull the remote master branch changes into the local one!

#### Updated 2008-11-09

See CiarÃƒÂ¡n's comment below for an all-inclusive command to do the above.
