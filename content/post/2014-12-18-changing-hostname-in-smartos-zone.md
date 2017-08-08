---
title: "Changing hostname in SmartOS Zone"
author: "Caius Durling"
date: 2014-12-18 10:00:00
tag:
  - SmartOS
---

Given a non-global zone in SmartOS that we want to change the hostname of, we need to make sure to edit the following files to change it:

* `/etc/hosts`
* `/etc/nodename`

A quick way to do that is with `sed` *(renaming "fred" to "beth" here)*:

```shell
sed -e 's/fred/beth/g' -i /etc/hosts /etc/nodename
```

Then shutdown & start the zone *(from my testing a restart doesn't apply it)*.
