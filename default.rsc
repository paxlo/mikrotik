# SYSTEM
/system identity set name=hbryzn-r01
/system routerboard settings set auto-upgrade=yes
/ip cloud set ddns-enabled=yes
/ip dns set allow-remote-requests=yes cache-max-ttl=1d servers=9.9.9.9,149.112.112.112
/ip dns static
rem [find where name~"router.lan"]
add address=172.22.23.1 name=time.windows.com
add address=172.22.23.1 name=time.nist.gov
add address=172.22.23.1 name=time-nw.nist.gov
add address=172.22.23.1 name=time-a.nist.gov
add address=172.22.23.1 name=time-b.nist.gov
/system clock set time-zone-autodetect=no time-zone-name=Europe/Moscow
/system ntp client set enabled=yes mode=unicast
/system ntp server set enabled=yes
/system script
add name=ntpupdate source="/system\
    \_ntp client set servers=[:resolve 0.ru.pool.ntp.org]"
add name=backup source="\
    \n/file remove [find where name~\".backup\"]\
    \n/file remove [find where name~\".rsc\"]\
    \n:local curdate [([/sy identity get name].\"-\".[:pick [/system clock get date] 7 11].\\\
    \n[:pick [/system clock get date] 0 3].[:pick [/system clock get date] 4 6].\"-\".[:pick\\ \
    \n [/system clock get time] 0 2].[:pick [/system clock get time] 3 5])]\
    \n/system backup save encryption=aes-sha256\
    \n/export compact file=\$curdate\
    \n"

/system scheduler
add name=ntp-at-startup on-event=ntpupdate policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
add interval=1d name=ntp-at-time on-event=ntpupdate policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=jun/28/2018 start-time=08:00:00

# SECURITY
/ip settings set tcp-syncookies=yes
/ip ssh
set forwarding-enabled=both host-key-size=8192 strong-crypto=yes
set host-key-size=8192
/ip service
disable [find where name!=ssh]
set ssh port=65535
/ip neighbor discovery-settings set discover-interface-list=none
/system logging action set 0 memory-lines=500
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
/user add name=router group=full password=Admin182873
/user rem [f where name=admin]

# FIREWALL
/ip firewall service-port disable sip
/ip firewall connection tracking set tcp-established-timeout=3h
/ip firewall address-list
add address=172.22.23.1 list=allowed-dns
/ip firewall mangle
add action=mark-connection chain=prerouting comment=dns connection-mark=no-mark dst-address-list=!allowed-dns dst-port=53 new-connection-mark=dns-conn \
    passthrough=yes protocol=udp src-address-list=!allowed-dns
add action=mark-connection chain=prerouting comment=dns connection-mark=no-mark dst-address-list=!allowed-dns dst-port=53 new-connection-mark=dns-conn \
    passthrough=yes protocol=tcp src-address-list=!allowed-dns
add action=mark-packet chain=prerouting comment=dns connection-mark=dns-conn new-packet-mark=dns-packet
add action=mark-connection chain=forward comment="mark ipsec connections" ipsec-policy=out,ipsec new-connection-mark=ipsec
add action=mark-connection chain=forward comment="mark ipsec connections" ipsec-policy=in,ipsec new-connection-mark=ipsec
/ip firewall filter
# remove and modify useless rules
rem [find where action=fasttrack-connection]
set [find where chain=input and action=drop and in-interface-list~"!LAN"] comment="defconf: drop all coming from WAN" in-interface-list=WAN
add comment="FastTrack for all except ipsec" action=fasttrack-connection chain=forward connection-mark=!ipsec \
connection-state=established,related in-interface-list=WAN out-interface-list=LAN place-before=6
add comment="FastTrack for all except ipsec" action=fasttrack-connection chain=forward connection-mark=!ipsec \
connection-state=established,related in-interface-list=LAN out-interface-list=WAN place-before=6
# custom rules
add chain=input comment="router ssh" dst-port=65535 in-interface-list=WAN protocol=tcp place-before=0
add action=reject chain=input comment="block other dns" packet-mark=dns-packet reject-with=icmp-host-unreachable place-before=0
add action=reject chain=forward comment="block other dns" packet-mark=dns-packet reject-with=icmp-host-unreachable place-before=0
/ip firewall nat
add action=dst-nat chain=dstnat comment="redirect ntp" dst-port=123 in-interface=bridge protocol=udp src-address=172.22.23.2-172.22.23.254 \
    to-addresses=172.22.23.1
/ip firewall raw
add action=drop chain=prerouting comment="block dns flood" dst-port=53 in-interface-list=WAN protocol=udp
add action=drop chain=prerouting comment="block dns flood" dst-port=53 in-interface-list=WAN protocol=tcp

# INTERFACES
/ip dhcp-client set [find] use-peer-dns=no
/interface ethernet set [find where name=ether1] name=wan
/interface bridge set 0 auto-mac=yes

# WIFI
/interface wireless nstreme
set wlan1 enable-polling=no
/interface wireless
set [ find default-name=wlan1 ] adaptive-noise-immunity=ap-and-client-mode wps-mode=disabled band=2ghz-onlyn channel-width=20/40mhz-Ce \
    country=russia3 disabled=no distance=indoors guard-interval=long hide-ssid=yes mode=ap-bridge radio-name="" ssid=SUSI_INT \
    tx-power=10 tx-power-mode=all-rates-fixed wireless-protocol=802.11 default-authentication=no
/interface wireless security-profiles
set [ find default=yes ] disable-pmkid=yes management-protection=allowed authentication-types=wpa2-psk mode=dynamic-keys supplicant-identity="" wpa2-pre-shared-key="duc#acapt-8Drerr"
/interface wireless access-list
add authentication=yes comment=pxsmart mac-address=74:D2:1D:0A:51:DD

## INTERNET STATIC IP
#/ip route add distance=1 gateway=93.91.116.1 dst-address=0.0.0.0/0

# ADDRESSES
/ip pool set 0 ranges=172.22.23.100-172.22.23.254
/ip dhcp-server network
set 0 address=172.22.23.0/24 dns-server=172.22.23.1 gateway=172.22.23.1 ntp-server=172.22.23.1
/ip dhcp-server lease
add server=defconf address=172.22.23.11 comment=kt01 mac-address=00:11:11:11:11:11
add server=defconf address=172.22.23.12 comment="buh" mac-address=00:22:22:22:22:22

# FINAL
# ATTENTION! AFTER THIS COMMAND, ACCESS VIA OLD DEFAULT ADDRESS 192.168.88.1 WILL BE DENIED!
/ip address set 0 address=172.22.23.1/24 comment="" interface=bridge network=172.22.23.0
