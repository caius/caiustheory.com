---
title: Ubuntu, ZFS root, and LXD
date: 2019-01-01T23:39:25Z
draft: true
---

Microserver, four HDDs, one SSD.

Install from server image on USB drive to HDD 4, reboot.

SSH into server, running from HDD 4

Install zfs bits

    apt install -y zfs-initramfs

Erase HDD 1 & 2, partitioned ready for Grub booting and ZFS partitions. Repeat with both drives.

    # Wipe partition table
    sgdisk --zap-all /dev/disk/by-id/ata-DISK
    # Create partition table
    sgdisk -o /dev/disk/by-id/ata-DISK
    # Create grub partition
    sgdisk -a1 -n2:34:2047 -t2:EF02 /dev/disk/by-id/ata-DISK
    # Create ZFS "partition"
    sgdisk     -n1:0:0      -t1:BF01 /dev/disk/by-id/ata-DISK

Create the root zpool, using the first two disks you just partitioned up. Note you need to pass partition 1 to them.

    zpool create -o ashift=12 \
          -O atime=off -O canmount=off -O compression=lz4 -O normalization=formD \
          -O xattr=sa -O mountpoint=/ -R /mnt \
          rpool mirror \
          /dev/disk/by-id/scsi-SATA_disk1-part1
          /dev/disk/by-id/scsi-SATA_disk2-part1

Create a bunch of zfs datasets to hold various things

    zfs create -o canmount=off -o mountpoint=none rpool/ROOT
    zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/ubuntu
    zfs mount rpool/ROOT/ubuntu
    zfs create -o setuid=off rpool/home
    zfs create -o mountpoint=/root rpool/home/root
    zfs create -o canmount=off -o setuid=off  -o exec=off rpool/var
    zfs create -o com.sun:auto-snapshot=false rpool/var/cache
    zfs create -o acltype=posixacl -o xattr=sa rpool/var/log
    zfs create rpool/var/spool
    zfs create -o com.sun:auto-snapshot=false -o exec=on  rpool/var/tmp

Copy the installed (running) system across to the zfs datasets (now mounted under /mnt)


    rsync -a --one-file-system / /mnt

Now we need to setup bits within the new filesystem, so grub boots from the correct places

    cd /mnt
    mount --bind /dev dev
    mount --bind /proc proc
    mount --bind /sys sys
    mount --bind /run run
    chroot .

Now we're inside the chroot of the new system, setup grub

Make sure grub probes the root fs correctly

    grub-probe /
    zfs

Then update the grub config, etc

    update-grub

Now for both disks in the root array (anything with grub partition on), we install grub so we can boot. (Specify disk, not partition.)

    grub-install /dev/disk/by-id/ata-DISK

Then reboot and enjoy your new system. Remember to whip disk 4 out before booting to make sure you boot off the correct system. Then wipe it.



Install LXD

    apt install -y lxd
    zfs create rpool/lxd


References

* <https://github.com/zfsonlinux/zfs/wiki/Ubuntu-18.04-Root-on-ZFS>
* <https://furneaux.ca/wiki/Ubuntu_ZFS_Root>
* <https://blog.heckel.xyz/2016/12/31/move-existing-linux-install-zfs-root/>
