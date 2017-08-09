---
title: "Upgrading Microserver G8 CPU"
date: 2017-08-09T00:30:23Z
author: Caius Durling
tag:
  - cpu
  - hardware
  - HP
  - microserver
---

My home server is a [HP Proliant Microserver Gen 8][g8], which is modestly powerful and runs everything I need at home in a fairly compact footprint without being too noisy or power hungry.

Both the G8 and the previous revision, the G7, are moderately expandable in terms of memory & storage devices. (Not least of which is an internal USB port, which is useful plugging the SmartOS boot device into, no chance of it being knocked out!) I've upgraded the memory and HDDs in the time I've had the machine. ([Here's how I upgraded the memory on the cheap][g8 memory upgrade]!)

The Gen 8 specifically is a little more upgradable however, as it comes with a 1155 CPU socket. Mine contained a [cpu][stock cpu] from new, which whilst quicker than the AMD one in the G7, was only two cores / two threads and not massively fast in the grand scheme of things.

Given I run a few different things on the home server, it acts as a NAS for a handful of laptops, [plex server][], [crashplan][] backup server, gathers various stats from network devices & runs the [unifi controller][]. Mostly it's fine, but transcoding in Plex specifically burns the CPU and on the odd occasion I've noticed it being slower than realtime and having to wait for the server to catch up.

So what to do? As you've no doubt guessed from the title of the post, I upgraded the CPU in it. I did some research and found [someone else who documented the upgrading process][upgrade process], as well as the [N40L wiki listing potential upgrade candidates][upgrade candidates]. I then pulled together my own table of processors, specs & price on fleabay to work out which I want.

My criteria were more than 2 cores/threads, ECC ram **has** to be supported and ideally not much higher TDP than the stock CPU. [Plex guidelines for CPU power][plex cpu] state that as a (very) rough guideline, you need a 2000 PassMark score per 1080p transcode. Given I would like other things running alongside Plex, allowing 2-3x that figure sounds ideal.

CPU         | Cores | Threads | TDP (W) | Passmark | Price (£)
------------|-------|---------|---------|----------|----------
G1610T      | 2     | 2       | 35      | 2322     | 12.00
E3-1220L v2 | 2     | 4       | 17      | 3701     | 120.00
E3-1220L    | 2     | 4       | 20      | 3563     | 60.00
E3-1260L    | 4     | 8       | 45      | 6534     | 80.00
E3-1265L    | 4     | 8       | 45      | 6054     | 64.00
E3-1265L v2 | 4     | 8       | 45      | 7733     | 133.00
E3-1230l v3 | 4     | 8       | 25      | 7207     | 167.00

*Stock CPU is first in the list for comparison*


After some deliberation, I decided to pick up the E3-1265L v2 from Ebay. It has a slightly higher TDP, but not so much that I'm worried about the temperature in the server. Most importantly it supports ECC ram & quadruples the physical cores, whilst providing a whopping eight threads for processing power. More than enough for a couple of concurrent Plex transcodes with cycles left over for other things at the same time.

I ordered it from a Hong Kong seller, and it arrived in the UK after 10 days or so as expected. It came with thermal paste, which I applied in a cross formation before refitting everything. The G8 is really easy to pull apart, HP really thought about that!

First boot with the processor went very smoothly, SmartOS recognises it quite happily.

        [root@oscar ~]# sysinfo | grep -i cpu
          "CPU Type": "Intel(R) Xeon(R) CPU E3-1265L V2 @ 2.50GHz",
          "CPU Virtualization": "vmx",
          "CPU Physical Cores": 1,
          "CPU Total Cores": 8,

I'm also happy with the temperatures, even after streaming a couple of videos via plex for an hour or so, whilst backing up a laptop via crashplan, as well as the usual stuff that's always running on the machine, everything was still well within normal ranges.

Sensor        | Value      | Units      | State
--------------|------------|------------|------
Inlet Ambient | 22.000     | degrees C  | ok
CPU           | 40.000     | degrees C  | ok
P1 DIMM 1-2   | 40.000     | degrees C  | ok
Chipset       | 56.000     | degrees C  | ok
Chipset Zone  | 44.000     | degrees C  | ok
VR P1 Zone    | 61.000     | degrees C  | ok
iLO Zone      | 49.000     | degrees C  | ok
PCI 1 Zone    | 40.000     | degrees C  | ok
Sys Exhaust   | 48.000     | degrees C  | ok
Fan 1         | 12.544     | percent    | ok

All in all, great success!

[g8]: https://www.hpe.com/uk/en/product-catalog/servers/proliant-servers/pip.hpe-proliant-microserver-gen8.5379860.html
[g8 memory upgrade]: /finding-cheap-microserver-g8-memory/
[stock cpu]: https://ark.intel.com/products/71074/Intel-Celeron-Processor-G1610T-2M-Cache-2_30-GHz
[plex server]: https://www.plex.tv/
[crashplan]: https://www.crashplan.com/
[unifi controller]: https://unifi-hd.ubnt.com
[upgrade process]: https://b3n.org/installed-xeon-e3-1230v2-in-gen8-hp-microserver/
[upgrade candidates]: http://n40l.wikia.com/wiki/Cpu_gen8
[plex cpu]: https://support.plex.tv/hc/en-us/articles/201774043
