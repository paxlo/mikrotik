# APN's name
:global apnname "apn2";

# caps controller address
:global maincapaddr "192.168.1.1";

/in br po rem [f where interface=wlan1]
/in br po add bridge=bridge interface=ether1
/system clock set time-zone-autodetect=no time-zone-name=Europe/Moscow
/ip ssh
set strong-crypto=yes
set host-key-size=8192
/ip neighbor discovery-settings set discover-interface-list=none
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
/system logging action set 0 memory-lines=100
/ip service
disable [find where name!=ssh]
set ssh port=65535
/user add name=apn group=full password=Admin182873
/user rem [f where name=admin]
/ip dns static rem [find]
/ip dhcp-server rem [find]
/ip dhcp-server network rem [find]
/ip pool rem [find]
/ip dhcp-client set 0 interface=bridge disabled=no
/system identity set name=$apnname
/system ntp client set enabled=yes primary-ntp=$maincapaddr secondary-ntp=$maincapaddr
/interface wireless cap
set bridge=bridge caps-man-addresses=$maincapaddr discovery-interfaces=bridge enabled=yes interfaces=wlan1

# remove non-dynamic rules manually before using the string below !!
/ip f f rem [f]
/ip f n rem [f]
/ip address rem [find]
