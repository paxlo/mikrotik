/certificate import passphrase=Admin182873 file-name=ca.crt
/certificate import passphrase=Admin182873 file-name=skyns-r.crt
/certificate import passphrase=Admin182873 file-name=skyns-r.key
/ip pool add name=ovpn-pool ranges=10.72.21.2-10.72.21.14
/ppp profile add name=ovpn remote-address=ovpn-pool local-address=10.72.21.1 use-encryption=required
/interface ovpn-server server set enabled=yes port=52236 mode=ethernet default-profile=ovpn \
certificate=skyns-r.crt_0 require-client-certificate=yes auth=sha1 cipher=aes256
/ip firewall filter add chain=input action=accept protocol=tcp in-interface-list=WAN place-before=0 dst-port=52236 comment=vpn
/ppp secret
add name=paxlo password=9CEryVrxfGSHarMyasyuFUvpsBsdGk profile=ovpn service=ovpn
