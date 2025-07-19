---
title: "Install capybara-webkit gem on Ubuntu"
author: "Caius Durling"
date: 2012-03-01 11:01:34 +0000
tag:
  - "geek"
  - "programming"
  - "code"
  - "fix"
  - "cli"
  - "bash"
  - "gem"
  - "rubygems"
  - "ubuntu"
  - "installing"
  - "deployment"
  - "webkit"
  - "aptitude"
  - "apt-get"
  - "linux"
  - "capybara"
  - "capybara-webkit"
  - "install"
---

Dear future Caius searching for this issue,

The apt package you need to install to use the capybara-webkit rubygem on ubuntu (tested on 10.04 and 11.10) is `libqt4-dev`. That is, to `gem install capybara-webkit`, you need to run `aptitude install libqt4-dev`.

Yours helpfully,  
Past Caius
