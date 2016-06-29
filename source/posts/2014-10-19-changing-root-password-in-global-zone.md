---
title: "Changing root password in global zone"
author: "Caius Durling"
created_at: 2014-10-19 17:44:20 +0000
tags:
  - SmartOS
---

SmartOS mounts `/etc/shadow` from `/usbkey/shadow` so we can change the root password for the global zone after install. Here's how:

1. Fire up a console or ssh session as root in the global zone
2. Check the existing permissions on the file

        $ ls -l /usbkey/shadow
        -r--------   1 root     root         560 Oct 19 16:45 /usbkey/shadow

3. Make the file writable

        $ chmod 600 /usbkey/shadow

4. Fire up `vi` to edit the file

        $ vi /usbkey/shadow

5. Edit the line containing root to change the crypted password. See [`shadow(4)`][man 4 shadow] if you need help with the format of `/etc/shadow` & use `/usr/lib/cryptpass` to generate a hash for the password you desire. *(Remember to clean the bash history!)*

6. Save the file and exit `vi`

7. Make the file readonly again

        $ chmod 400 /usbkey/shadow

8. Double check permissions are correct on the file again

        $ ls -l /usbkey/shadow
        -r--------   1 root     root         560 Oct 19 16:49 /usbkey/shadow

Job done. Verify by logging in as root (invoking `/usr/bin/login` from an ssh session makes this easy to verify.)

[man 4 shadow]: https://us-east.manta.joyent.com/smartosman/public/man4/shadow.4.html
