---
title: "View Raw Source"
author: "Caius Durling"
date: 2009-01-31 01:54:57 +0000
tag:
  - "quote"
  - "geek"
  - "tech"
  - "php"
  - "code"
  - "habari"
  - "modification"
  - "markdown"
---

So I write this blog using [Markdown][] because I'm a human and writing `stuff <strong>with</strong> tags` is just **WRONG**. Thankfully, [Gruber][] solved this problem by writing markdown.

[Markdown]: http://daringfireball.net/projects/markdown/
[Gruber]: http://daringfireball.net/

Now on the [markdown page][Markdown] he says:

> The best way to get a feel for Markdown’s formatting syntax is simply to look at a Markdown-formatted document. For example, you can view the Markdown source for the article text on this page here: <http://daringfireball.net/projects/markdown/index.text>

> (You can use this ‘.text’ suffix trick to view the Markdown source for the content of each of the pages in this section, e.g. the Syntax and License pages.)

And ever since I noticed that I've always read his articles using the '.text' trick. One of the plugins I've been meaning to write for [habari][] is one that replicates this '.text' behaviour. So tonight I decided to try and write it, started picking through the [Plugin documentation][plugindocs] in preparation. Got a bit stuck with it as I've been out of the habari development loop for a few months, popped into [#habari][hirc] and asked if I was thinking along the right lines.

Few minutes later [Owen][] pops up and sends me a link to [plaintext.plugin.php][plaintext], which does exactly what I was trying to do! Couple of tweaks later (switching it to '.text' instead of '.md') and its installed and working on this blog. Feel free to view the [raw source][postsource] of this post. Or any other post on this site.

[habari]: http://habariproject.org/
[plugindocs]: http://wiki.habariproject.org/en/Creating_A_Plugin
[hirc]: irc://irc.freenode.net/#habari
[Owen]: http://asymptomatic.net/
[plaintext]: http://pastoid.com/bn5
[postsource]: http://caiustheory.com/view-raw-source.text

### Updated 2009-01-31

Added to the habari-extras repo as the [Plaintext][] plugin.

[Plaintext]: http://svn.habariproject.org/habari-extras/plugins/plaintext/trunk/plaintext.plugin.php
