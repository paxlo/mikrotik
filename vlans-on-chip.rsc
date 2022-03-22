# Written by paxlo:
# This configuration must be used with old models like 951 with the switch chip feature.
# Because bridging vlans on these models loads CPU up to 100%
# Read https://forum.mikrotik.com/viewtopic.php?t=133129#p654102 to get more info.
#
# NOTE: This configuration example is not possible for devices with the Atheros8316 and Atheros7240 switch chips. 
# For devices with QCA8337 and Atheros8327 switch chips it is possible to use any other default-vlan-id as long 
# as it stays the same on switch-cpu and trunk ports. For devices with Atheros8227 switch chip only 
# default-vlan-id=0 can be used and trunk port must use vlan-header=leave-as-is
#
# Keep in mind that if you enable VLAN filtering on bridge (and without that VLANs essentially don't work), 
# you loose HW offload and every packet passes CPU. This kills performance on slower routerboards, such as RG951G.
# I advise the old way by using /interface ethernet switch section.

/interface vlan
add interface=bridge name=vlan40 vlan-id=40
add interface=bridge name=vlan50 vlan-id=50

/interface ethernet switch vlan
add independent-learning=no ports=switch1-cpu,ether4 switch=switch1 vlan-id=40
add independent-learning=no ports=switch1-cpu,ether5 switch=switch1 vlan-id=50

/ip address
add address=192.168.40.1/29 interface=vlan40 network=192.168.40.0
add address=192.168.50.1/29 interface=vlan50 network=192.168.50.0

/ip pool
add name=pool40 ranges=192.168.40.2-192.168.40.6
add name=pool50 ranges=192.168.50.2-192.168.50.6

/ip dhcp-server network
add address=192.168.40.0/29 dns-server=192.168.40.1 gateway=192.168.40.1 ntp-server=192.168.40.1
add address=192.168.50.0/29 dns-server=192.168.50.1 gateway=192.168.50.1 ntp-server=192.168.50.1

/ip dhcp-server
add address-pool=pool40 disabled=no interface=vlan40 name=dhcp40
add address-pool=pool50 disabled=no interface=vlan50 name=dhcp50

/interface ethernet switch port
set ether4 default-vlan-id=40 vlan-header=always-strip vlan-mode=secure
set ether5 default-vlan-id=50 vlan-header=always-strip vlan-mode=secure


# IMPORTANT! after this you'll lose access to router from non-vlan default network (default bridke with tag 1 on all ports)
# But without this section VLAN won't work on ports
/interface ethernet switch vlan
set switch1-cpu vlan-mode=secure                                         

# If you want to restore access from ether2
add independent-learning=yes ports=switch1-cpu,ether2 switch=switch1 vlan-id=1
