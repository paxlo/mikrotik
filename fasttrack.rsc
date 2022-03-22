# This script allows to unloacd CPU using FastTrack but keeps IPSec.

# paxlo@paxlo.cc

/ip firewall mangle
add action=mark-connection chain=forward comment="mark ipsec connections" ipsec-policy=out,ipsec new-connection-mark=ipsec
add action=mark-connection chain=forward comment="mark ipsec connections" ipsec-policy=in,ipsec new-connection-mark=ipsec

/ip firewall filter
add comment="FastTrack for all except ipsec" action=fasttrack-connection chain=forward connection-mark=!ipsec \
connection-state=established,related in-interface-list=WAN out-interface-list=LAN place-before=16
add comment="FastTrack for all except ipsec" action=fasttrack-connection chain=forward connection-mark=!ipsec \
connection-state=established,related in-interface-list=LAN out-interface-list=WAN place-before=16
