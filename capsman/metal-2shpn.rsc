/interface ethernet set 0 name=eth1
/interface wireless set 0 name=wlan1
/interface bridge add name=bridge0 auto-mac=yes
/interface bridge port
add bridge=bridge0 interface=eth1
/system clock set time-zone-autodetect=no time-zone-name=Europe/Moscow
/ip ssh set strong-crypto=yes
/ip neighbor discovery set discover=no [find]
/tool mac-server set disabled=yes [find]
/tool mac-server mac-winbox set disabled=yes [find]
/tool mac-server ping set enabled=no
/ip service
disable [find where name!=ssh]
set ssh port=65535
/user set 0 name=apn password=Admin182873
/ip dns static rem [find]
/ip dhcp-server rem [find]
/ip dhcp-server network rem [find]
/ip pool rem [find]
/ip dhcp-client set 0 interface=bridge0 disabled=no

######################################################################################################################################
# replace name, ntp, capsman address, capsman name
/system identity set name=chvkz-ap01
/system ntp client set enabled=yes primary-ntp=192.168.63.4 secondary-ntp=192.168.63.4
/interface wireless cap
set bridge=bridge0 caps-man-addresses=192.168.63.3 caps-man-names=chvkz-r01 discovery-interfaces=bridge0 enabled=yes interfaces=wlan1
######################################################################################################################################

/ip address rem [find]
