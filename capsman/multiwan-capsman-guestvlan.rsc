/caps-man channel
add band=2ghz-b/g/n extension-channel=Ce frequency=2412 name=channel1 \
    tx-power=25 width=20
/interface bridge
add admin-mac=4C:5E:0C:F2:40:2D mtu=1500 name=bridge-local
/interface ethernet
set [ find default-name=ether3 ] mac-address=00:00:00:10:10:13 name=eth3
set [ find default-name=ether4 ] mac-address=00:00:00:10:10:14 master-port=\
    eth3 name=eth4
set [ find default-name=ether5 ] mac-address=00:00:00:10:10:15 master-port=\
    eth3 name=eth5
set [ find default-name=ether1 ] mac-address=00:00:00:10:10:11 name=wan1
set [ find default-name=ether2 ] mac-address=00:00:00:10:10:12 name=wan2
/interface wireless
# managed by CAPsMAN
# channel: 2412/20-Ce/gn(20dBm), SSID: hotel, CAPsMAN forwarding
set [ find default-name=wlan1 ] radio-name="" ssid=MikroTik
/ip neighbor discovery
set eth3 discover=no
set eth4 discover=no
set eth5 discover=no
set wan1 discover=no
set wan2 discover=no
set bridge-local discover=no
/interface vlan
add interface=bridge-local l2mtu=1594 name=vlan99 vlan-id=99
add interface=bridge-local l2mtu=1594 name=vlan101 vlan-id=101
add interface=bridge-local l2mtu=1594 name=vlan102 vlan-id=102
/caps-man datapath
add bridge=bridge-local client-to-client-forwarding=no name=datapath1 \
    vlan-id=102 vlan-mode=use-tag
add bridge=bridge-local client-to-client-forwarding=yes name=datapath2 \
    vlan-id=101 vlan-mode=use-tag
/ip neighbor discovery
set vlan99 discover=no
set vlan101 discover=no
set vlan102 discover=no
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm name=sec1 passphrase=\
    chekhov2015
add authentication-types=wpa2-psk encryption=aes-ccm name=sec2 passphrase=\
    Ralv&ofKueb4
/caps-man configuration
add country=russia datapath=datapath1 datapath.vlan-mode=use-tag hide-ssid=no \
    mode=ap name=cfg1 security=sec1 ssid=hotel
add country=russia datapath=datapath2 datapath.vlan-id=101 \
    datapath.vlan-mode=use-tag hide-ssid=no mode=ap name=private security=\
    sec2 ssid=private
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip firewall layer7-protocol
add name=anonymizers regexp="^.+(anonim.pro|pingway.ru|pinun.ru|anonimno.biz|2\
    ip.ru|kalarupa.com|anonymouse.org|hideme.ru|changeip.ru|seogadget.ru|mrcha\
    meleon.ru|anonimno.biz|unlumen.ru|proxya.ru|anonimaiser.com|dostupest.ru|v\
    kdor.ru|fastbuh.ru|serqus.ru|aradero.ru|recker.ru|spoolls.com|nezayti.ru|a\
    nonimajzer.com|nezayti.ru|anonimix.ru|websplatt.ru|unboo.ru|xy4-anonymizer\
    .ru|anonymizer.ru|anonimajzer.ru|waitplay.ru|hellhead.ru|anonymouse.org).*\
    \$"
add name=torrent regexp="\\.(torrent)"
/ip ipsec proposal
set [ find default=yes ] enc-algorithms=aes-128-cbc
/ip pool
add name=default-dhcp ranges=192.168.111.100-192.168.111.254
add name=guest-pool ranges=172.20.111.2-172.20.111.254
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=vlan101 name=default
add address-pool=guest-pool disabled=no interface=vlan102 name=guest-dhcp
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw
/caps-man manager
set enabled=yes
/caps-man provisioning
add action=create-dynamic-enabled master-configuration=cfg1 \
    slave-configurations=private
/interface bridge port
add bridge=bridge-local
add bridge=bridge-local interface=eth3
/ip firewall connection tracking
set tcp-established-timeout=3h
/interface wireless cap
set bridge=bridge-local caps-man-addresses=127.0.0.1 discovery-interfaces=\
    bridge-local enabled=yes interfaces=wlan1
/ip address
add address=192.168.111.1/24 comment="default configuration" interface=\
    vlan101 network=192.168.111.0
add address=172.20.111.1/24 interface=vlan102 network=172.20.111.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-client
add add-default-route=no dhcp-options=hostname,clientid disabled=no \
    interface=wan1 use-peer-dns=no
add add-default-route=no dhcp-options=hostname,clientid disabled=no \
    interface=wan2 use-peer-dns=no
/ip dhcp-server network
add address=172.20.111.0/24 dns-server=172.20.111.1 gateway=172.20.111.1
add address=192.168.111.0/24 comment="default configuration" dns-server=\
    192.168.111.1 gateway=192.168.111.1
/ip dns
set allow-remote-requests=yes servers=77.88.8.7,77.88.8.3
/ip dns static
add address=192.168.88.1 name=router
/ip firewall address-list
add address=192.168.111.1 list=allowed-dns
add address=172.20.111.1 list=allowed-dns
/ip firewall filter
add chain=input comment="allow router ssh" dst-port=65535 in-interface=wan1 \
    protocol=tcp
add chain=input comment="allow router ssh" dst-port=65535 in-interface=wan2 \
    protocol=tcp
add action=drop chain=input comment="block icmp" disabled=yes protocol=icmp
add chain=input comment="default configuration" connection-state=established
add chain=input comment="default configuration" connection-state=related
add action=drop chain=input comment="deny all other from input" in-interface=\
    wan1
add action=drop chain=input comment="deny all other from input" in-interface=\
    wan2
add chain=forward disabled=yes out-interface=wan1
add chain=forward disabled=yes out-interface=wan2
add action=reject chain=forward disabled=yes reject-with=\
    icmp-host-unreachable src-address=192.168.111.0/24
add action=reject chain=forward disabled=yes reject-with=\
    icmp-host-unreachable src-address=172.20.111.0/24
add action=drop chain=forward comment="block other dns" dst-address-list=\
    !allowed-dns dst-port=53 protocol=tcp
add action=drop chain=forward comment="block other dns" dst-address-list=\
    !allowed-dns dst-port=53 protocol=udp
add action=drop chain=forward comment="block torrents" p2p=all-p2p
add action=drop chain=forward comment="block torrents" content=d1:ad2:id20: \
    dst-port=1025-65535 packet-size=95-190 protocol=udp
add action=drop chain=forward comment="block torrents" content="info_hash=" \
    dst-port=2710,80 protocol=tcp
add action=reject chain=forward comment="block torrents" content=\
    "\r\
    \nContent-Type: application/x-bittorrent" protocol=tcp reject-with=\
    tcp-reset src-port=80
add action=drop chain=forward comment="block torrents" content=\
    "\r\
    \nInfohash: " dst-port=6771 protocol=udp
add action=reject chain=forward comment="block torrents" layer7-protocol=\
    torrent protocol=tcp reject-with=tcp-reset
add action=reject chain=forward comment="block anonymizers" layer7-protocol=\
    anonymizers protocol=tcp reject-with=tcp-reset
add chain=forward comment="default configuration" connection-state=\
    established
add chain=forward comment="default configuration" connection-state=related
add action=drop chain=forward comment="default configuration" \
    connection-state=invalid
/ip firewall mangle
add action=mark-routing chain=prerouting new-routing-mark=isp1 src-address=\
    192.168.111.0/24
add action=mark-routing chain=prerouting new-routing-mark=isp2 src-address=\
    172.20.111.0/24
/ip firewall nat
add action=masquerade chain=srcnat out-interface=wan1
add action=masquerade chain=srcnat out-interface=wan2
/ip ipsec policy
set 0 dst-address=0.0.0.0/0 src-address=0.0.0.0/0
/ip route
add distance=1 gateway=109.172.104.1%wan1 routing-mark=isp1
add distance=1 gateway=109.172.104.1%wan2 routing-mark=isp2
add distance=1 gateway=109.172.104.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh port=65535
set api disabled=yes
set winbox disabled=yes
set api-ssl disabled=yes
/ip ssh
set strong-crypto=yes
/system clock
set time-zone-autodetect=no time-zone-name=Europe/Moscow
/system identity
set name=chekhov-r01
/system ntp client
set enabled=yes primary-ntp=85.30.248.106 secondary-ntp=95.213.132.254
/system routerboard settings
set cpu-frequency=750MHz
/system scheduler
add interval=1d name=ntpupdate on-event=ntpupdate policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive start-date=\
    nov/16/2015 start-time=10:00:00
/system script
add name=ntpupdate owner=router policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source="/system\
    \_ntp client set primary-ntp=[:resolve 0.pool.ntp.org] secondary-ntp=[:res\
    olve 1.pool.ntp.org]"
add name=backup owner=router+c policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source="\
    \n/file remove [find where name~\".backup\"]\
    \n/file remove [find where name~\".rsc\"]\
    \n:local curdate [([/sy identity get name].\"-\".[:pick [/system clock get\
    \_date] 7 11].[:pick [/system clock get date] 0 3].[:pick [/system clock g\
    et date] 4 6].\"-\".[:pick [/system clock get time] 0 2].[:pick [/system c\
    lock get time] 3 5].[:pick [/system clock get time] 6 8])]\
    \n/system backup save name=\$curdate\
    \n/export file=\$curdate\
    \n"
/tool mac-server
set [ find default=yes ] disabled=yes
add disabled=yes interface=wan2
add disabled=yes interface=eth3
add disabled=yes interface=eth4
add disabled=yes interface=eth5
add disabled=yes
add disabled=yes interface=bridge-local
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add disabled=yes interface=wan2
add disabled=yes interface=eth3
add disabled=yes interface=eth4
add disabled=yes interface=eth5
add disabled=yes
add disabled=yes interface=bridge-local
/tool mac-server ping
set enabled=no
/tool romon port
add
/tool user-manager database
set db-path=user-manager
