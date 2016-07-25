mounting zones/usbkey on SmartOS recovery

zpool import zones
mkdir /usbkey
mount -F zfs zones/usbkey /usbkey
