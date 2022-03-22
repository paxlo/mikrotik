/caps-man interface rem [find]

/caps-man access-list
add action=accept interface=any comment="Canon MF4780w" mac-address=24:0A:64:7F:46:11 
add action=accept interface=any comment=Phones  mac-address=F4:D6:20:00:00:00 mac-address-mask=FF:FF:FF:00:00:00
add action=reject interface=any

/caps-man channel
add band=2ghz-g/n control-channel-width=20mhz extension-channel=XX name=24g tx-power=16
add band=5ghz-onlyac control-channel-width=20mhz extension-channel=XXXX name=5g tx-power=16

/caps-man datapath
add bridge=bridge client-to-client-forwarding=yes name=datapath1

/caps-man security
add authentication-types=wpa2-psk disable-pmkid=yes encryption=aes-ccm name=sec1 passphrase=BVBVputow*26

/caps-man configuration
add channel=24g country=russia3 datapath=datapath1 hide-ssid=no installation=any mode=ap name=cfg1 security=sec1 ssid=BVOFFICE24
add channel=5g country=russia3 datapath=datapath1 hide-ssid=no installation=any mode=ap name=cfg2 security=sec1 ssid=BVOFFICE5

/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=b,g,gn master-configuration=cfg1 name-format=prefix name-prefix=cap24GHz
add action=create-dynamic-enabled hw-supported-modes=a,an,ac master-configuration=cfg2 name-format=prefix name-prefix=cap5GHz

/caps-man manager
set enabled=yes

/interface wireless cap
set bridge=bridge caps-man-addresses=127.0.0.1 discovery-interfaces=bridge enabled=yes interfaces=wlan1
