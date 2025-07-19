---
title: "Download All Your Gists"
date: 2019-03-17T14:32:30Z
author: Caius Durling
tag:
  - github
  - git
  - bash
  - shell
---

Over time I've managed to build up quite the collection of [Gists][] over at Github, including secret ones there's about 1200 currently. Some of these have useful code in, some are just garbage output. I'd quite like a local copy either way, so I can easily search[^1] across them.

1. Install the `gist` command from Github

    ```shell
    brew install gist
    ```

2. Login to your Github Account through the gist tool (it'll prompt for your login credentials, then generate you an API Token to allow it future access.)

    ```shell
    gist --login
    ```

3. Create a folder, go inside it and download all your gists!

    ```shell
    mkdir gist_archive
    cd gist_archive
    for repo in $(gist -l | awk '{ print $1 }'); do git clone $repo 2> /dev/null; done
    ```

4. Now you have a snapshot of all your gists. To update them in future, you can run the above for any new gists, and update all the existing ones with:

    ```shell
    cd gist_archive
    for i in */; do (cd $i && git pull --rebase); done
    ```

Now go forth and search out your favourite snippet you saved years ago and forgot about!

[Gists]: https://gist.github.com/
[grep]: https://www.freebsd.org/cgi/man.cgi?query=grep&sektion=&n=1
[ripgrep]: https://github.com/BurntSushi/ripgrep
[ack]: https://beyondgrep.com
[ag]: https://geoff.greer.fm/ag/

[^1]: [ack][], [ag][], [grep][], [ripgrep][], etc. Pick your flavour.
