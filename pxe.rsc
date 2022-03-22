/ip dhcp-server option
add code=66 name=option66 value="'192.168.0.2'"
add code=67 name=option67 value="'pxelinux.0'"
/ip dhcp-server option sets
add name=pxe options=option66,option67
/ip dhcp-server
add address-pool=default dhcp-option-set=pxe disabled=no interface=bridge name=default
/ip dhcp-server network
add address=192.168.0.0/24 boot-file-name=pxelinux.0 dhcp-option-set=pxe dns-server=192.168.0.1 gateway=192.168.0.1 next-server=192.168.0.2
