---
title: "Capitalise \"ringer\" on the iPhone Volume Bezel"
author: "Caius Durling"
created_at: 2009-06-20 15:44:04 +0000
tags:
  - "geek"
  - "tech"
  - "programming"
  - "bug"
  - "fix"
  - "cli"
  - "bash"
  - "modification"
  - "apple"
  - "picture"
  - "google"
  - "ssh"
  - "iphone"
  - "jailbreak"
---

**Backstory:** Got myself a first generation iPhone second hand and unlocked it to work on my existing T-Mobile (Official iPhone network in the UK is O2.) Noticed after a week or so of owning it that when you change the volume on the phone, the bezel that comes up says "ringer" across the top. But when you have headphones plugged in, it says "Headphones". *(Note the capitalisation difference.)*

Now I'm not usually bothered by stuff like this (honest!) but as soon as I'd noticed the *"bug"*, I couldn't help but think of it everytime I changed the volume, whether I was looking at the screen or not. Seeing as I'm running a jailbroken phone, and therefore have SSH access to it, I figured the string would be defined in a .strings file somewhere in the `/System` folder. And I'd be able to change it!

Fast-forward a few months and I install the iPhone OS 3.0 update (jailbroken of course), and finally decide to turn the phone's SSH server on and go looking for the setting. To do so I figured I'd just need `grep` installed on the phone - I could copy the file itself to my mac and edit it there.

So I connect to the phone, have a poke around the filesystem and then start a search to find the correct file:

    # On the iPhone
    $ cd /System/Library/
    $ grep -r "ringer" *
    Binary file CoreServices/SpringBoard.app/English.lproj/SpringBoard.strings matches
    Binary file CoreServices/SpringBoard.app/M68AP.plist matches
    Binary file CoreServices/SpringBoard.app/SpringBoard matches
    Binary file Frameworks/CFNetwork.framework/CFNetwork matches
    Binary file Frameworks/CFNetwork.framework/da.lproj/Localizable.strings matches
    Binary file Frameworks/CFNetwork.framework/no.lproj/Localizable.strings matches
    Binary file Frameworks/Foundation.framework/da.lproj/URL.strings matches

At which point I stopped the grep search (`^C`) because I know the home screen of the iPhone is the SpringBoard.app, so I figured it would be in the file `SpringBoard.app/English.lproj/SpringBoard.strings`. Making sure to have SSH enabled on your mac, a simple `scp CoreServices/SpringBoard.app/English.lproj/SpringBoard.strings user@your_mac.local:` later and the file is sat in my home folder on my mac.

Switching to the mac, now I try and open the file with TextMate, only to realise its in binary format. I need it in the nice XML format to edit it, so a quick google later and I've found a hint on [MacOSXHints][] telling me how to convert from [binary to xml plist format][converthint].

[MacOSXHints]: http://macosxhints.com
[converthint]: http://www.macosxhints.com/article.php?story=20050430105126392

    # On the mac
    $ plutil -convert xml1 SpringBoard.strings

Then opening the file in TextMate was a bit more successful! I can actually understand what its defining now. Search through the file for "ringer" and I found the following lines:

    <key>RINGER_VOLUME</key>
    <string>ringer</string>

Change the "ringer" to "Ringer" between the `<string>` and my editing work is complete! Yes, it really is that easy to edit an interface string that is defined in a `.string`. Now I just need to convert the file back to binary, and copy it back to the phone. Converting back to binary file is one line, just change the `xml1` in the previous command to `binary1`.

    # On the mac
    $ plutil -convert binary1 SpringBoard.strings

And then scp it back to the phone, make a backup of the existing file, and overwrite the existing file with the new one I've edited:

    # On the iPhone
    $ cd ~
    $ scp user@mac_name.local:SpringBoard.strings .
    $ cd /System/Library/CoreServices/SpringBoard.app/English.lproj/
    $ mv SpringBoard.strings SpringBoard.strings.bak
    $ cp ~/SpringBoard.strings SpringBoard.strings

And then restart the phone, either in the usual manner or just run `reboot` on the phone via SSH. Lo and behold once its rebooted and I changed the volume, it read "Ringer"!

![Screenshot of Volume bezel](http://caius.name/images/ringer.jpg)

