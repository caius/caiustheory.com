---
title: Remove OS X Disk Password
date: 2016-09-16T10:27:00Z
tag:
  - OS X
  - apple
  - mac
  - security
---

I recently reinstalled a laptop and in doing so setup full disk encryption in a slightly strange fashion. The basic flow I followed was:

1. Boot into Recovery mode (hold ⌘-R at boot)
2. Erase the internal HD as `HFS+ (Journaled, Encrypted)` and set a disk password
3. Install OS X onto the internal disk
4. During setup, use Migration Assistant to copy clone containing previous install data from backup disk

This worked great in the end, once I'd recompiling various utilities I had installed. (Downside of moving from one CPU arch to another - can't just copy all compiled binaries over.)

However, I failed at step 2 above and entered "password" as my disk password since it was only intended to be temporary. Usually OS X's full disk encryption (FileVault 2) allows the machine users to unlock the disk, and not a standalone password. Due to the slightly odd way I setup the machine, I had the option of either using the disk password or my user account's password.

Having hunted around trying to find how to change or remove this disk password and leave only my users password, I finally stumbled across the magic incantations in an apple discussion thread asking [How to disable "Disk Password" on boot?](https://discussions.apple.com/thread/5105759?start=0&tstart=0).

The magic incantations are as follows:

1. List all the passwords that can currently unlock the drive

    **Make sure there is a second password listed or removing the disk password will lock you out of the disk**.

        $ sudo fdesetup list -extended
        ESCROW  UUID                                                    TYPE USER
                28376DDE-B6E1-48BE-A06F-4212067581D6    Disk Passphrase User
                4DBF8CEF-40F7-4F00-902F-A47AA643C656                 OS User caius

2. Note the UUID of the "Disk Passphrase" entry, and remove that from the list

        sudo fdesetup remove -uuid 28376DDE-B6E1-48BE-A06F-4212067581D6

3. List the passwords again to make sure the Disk Passphrase entry was removed

        $ sudo fdesetup list -extended
        ESCROW  UUID                                                    TYPE USER
                4DBF8CEF-40F7-4F00-902F-A47AA643C656                 OS User caius

Hey presto, only your user is left being able to unlock the disk.
