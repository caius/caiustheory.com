---
title: "Wireguard on Edgerouter: Client to Site"
date: 2020-02-11T21:23:28Z
author: Caius Durling
draft: true
tag:
  - 
---

Stop folks sniffing your traffic in a coffee shop. Send it all home instead.

* Install wireguard on edgerouter - https://community.ui.com/t5/EdgeRouter/Release-WireGuard-for-EdgeRouter/td-p/1904764

* Pick an ip range to stick your VPN in. I'm using 192.168.3.0/24 with the router at IP 192.168.3.254.

* Firstly generate a key for the router (private key on line one, public key on line two.)

        $ wg genkey | tee /dev/stderr | wg pubkey
        aOIg6R/TGKc4yM0JKzJZSKrjbfMtAY/Q1tl7nJm6Jl4=
        wNyNuyVmhPOt24jAMDyJPQFTGQQstMSmTKAFGJgJrwg=

* Bring up the wireguard interface on the router, using the private key we just generated

    (NB: It's important to get the netmask correct on the router's interface address. The `/24` is important.)

        $ configure
        # set interfaces wireguard wg0 address 192.168.3.254/24
        # set interfaces wireguard wg0 listen-port 51820
        # set interfaces wireguard wg0 private-key aOIg6R/TGKc4yM0JKzJZSKrjbfMtAY/Q1tl7nJm6Jl4=
        # set interfaces wireguard wg0 route-allowed-ips false

* You'll need to allow UDP traffic on port 51820 through to the router (local firewall on your WAN interface.)

        # set firewall name pppoe-local rule 220 action accept
        # set firewall name pppoe-local rule 220 description "Allow Wireguard"
        # set firewall name pppoe-local rule 220 destination port 51820
        # set firewall name pppoe-local rule 220 log disable
        # set firewall name pppoe-local rule 220 protocol udp

* Commit the config thus far and make sure `wg0` shows up correctly

        caius@earl:~$ show interfaces 
        Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down
        Interface    IP Address                        S/L  Description                 
        ---------    ----------                        ---  -----------                 
        [ snip ]
        wg0          192.168.3.254/24                  u/u                              

* Now switch to your client machine you want to connect in, install wireguard there (I'll assume wireguard on a mac, but is similar on any OS.) Generate the following config for it (the PrivateKey should already be there.)

    `[Interface]` is local client config, `PrivateKey` is the client's Private Key, not the router's. Address is any single IP (note `/32`) under the subnet picked above.

    `[Peer]` is your router, so PublicKey there is the one you generated above, your home IP needs filling in, etc. `AllowedIPs` here is the ranges you want to route across the tunnel, so we define everything as a "send all traffic over VPN" tunnel.

        [Interface]
        PrivateKey = XXXXXXXXXX
        Address = 192.168.3.2/32
        DNS = 192.168.3.254

        [Peer]
        PublicKey = wNyNuyVmhPOt24jAMDyJPQFTGQQstMSmTKAFGJgJrwg=
        AllowedIPs = 0.0.0.0/0, ::/128
        Endpoint = your.home.ip.here:51820
        PersistentKeepalive = 25

* Now we need to tell the router about the client as a Peer too. We don't give an Endpoint for it - wireguard figures that out at connection time. Just need to configure which IP the peer is allowed to assign itself.

    `YYY` is the public key from the mac.

        # set interfaces wireguard wg0 peer "YYY" address 192.168.3.2/32
        # set interfaces wireguard wg0 peer "YYY" description Mac1
        # commit

Now connect (activate!) wireguard connection from your mac and it should tunnel across to your router.
