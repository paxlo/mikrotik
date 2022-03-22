# !! Set name !!
/system identity set name=vishsad-ap10

/ip ssh set strong-crypto=yes
/ip service
disable [find where name!=ssh]
set ssh port=65535
/system clock set time-zone-autodetect=no time-zone-name=Europe/Moscow
/system ntp client set enabled=yes primary-ntp=192.168.112.1 secondary-ntp=192.168.112.1
/user set 0 name=apn password=Admin182873
/interface vlan
add interface=bridge-local name=vlan101 vlan-id=101
add interface=bridge-local name=vlan102 vlan-id=102
/ip neighbor discovery set discover=no [find]
/tool mac-server set disabled=yes [find]
/tool mac-server mac-winbox set disabled=yes [find]
/tool mac-server ping set enabled=no

# !! set CAPs name & ip
/interface wireless cap
set bridge=bridge-local caps-man-addresses=192.168.112.1 caps-man-names=vishsad-r01 discovery-interfaces=bridge-local enabled=yes interfaces=wlan1

/interface ethernet set ether1-gateway name=ether1
/interface bridge port add bridge=bridge-local interface=ether1
/ip dhcp-server rem [find]
/ip dhcp-server network rem [find]
/ip pool rem [find]
/ip dns static rem [find]
/ip address rem [find]