# This script blocks pupular proxies and vpn services 
# Very important to block other DNS servers! Otherwise client is able to connect to aforecited services. Just uncomment the below section about the DNS.
#
# (c) paxlo@paxlo.cc

# Further work. Hasn't done yet:
# 	SurfEasy
#	ultrasurf.us
#	onevpn.co
#       Hola VPN
#       Touch VPN
#       protonvpn.com
#       SetupVPN
#       fastproxy
#       https://chrome.google.com/webstore/detail/proxy-vpn-to-unblock-any/ookhnhpkphagefgdiemllfajmkdkcaim
#       TunnelBear
#       antizapret.prostovpn.org
#       DotVPN
#       vpn99.net


/ip firewall layer7-protocol
add name=proxyvpn regexp="^.*(antizapret.prostovpn.org|prostovpn.org|browsec.com|postlm.com|postls.com|api.zenguard.biz|zenmate.io\
|zenguard.zendesk.com|zendesk.com|zenguard.org|lunrac.com|tcdn.me|friproxy0.eu|fri-gate.biz|fri-gate0.biz|fri-gat\
e0.eu|fri-gate0.org|friproxy0.biz|friproxy0.eu|friproxy.biz|friproxy.eu|anonim.pro|pingway.ru|pinun.ru|anonimno.b\
iz|2ip.ru|kalarupa.com|anonymouse.org|hideme.ru|changeip.ru|seogadget.ru|mrchameleon.ru|cameleo.xyz|anonimno.biz|\
unlumen.ru|proxya.ru|anonimaiser.com|dostupest.ru|vkdor.ru|fastbuh.ru|serqus.ru|aradero.ru|recker.ru|spoolls.com|\
nezayti.ru|anonimajzer.com|nezayti.ru|anonimix.ru|websplatt.ru|unboo.ru|xy4-anonymizer.ru|anonymizer.ru|anonimajz\
er.ru|waitplay.ru|hellhead.ru|anonymouse.org|anonymox|windscribe.com|torproject.org|surfeasy.com|opera-proxy.net|\
api.sec-tunnel.com|opera-mini.net|sitecheck2.opera.com|freesafeip.com).*\$"
/ip firewall address-list
add address=37.140.239.0/24 comment=anonymox   list=proxyvpn
add address=37.140.238.0/24 comment=anonymox   list=proxyvpn
add address=37.140.232.0/21 comment=anonymox   list=proxyvpn
add address=185.56.136.0/22 comment=anonymox   list=proxyvpn
add address=185.52.52.0/22  comment=anonymox   list=proxyvpn
add address=185.28.191.0/24 comment=anonymox   list=proxyvpn
add address=185.28.190.0/24 comment=anonymox   list=proxyvpn
add address=185.28.189.0/24 comment=anonymox   list=proxyvpn
add address=185.28.188.0/24 comment=anonymox   list=proxyvpn
add address=148.251.55.147  comment=anonymox   list=proxyvpn
add address=146.185.16.0/20 comment=anonymox   list=proxyvpn
add address=209.95.32.0/19  comment=anonymox   list=proxyvpn
add address=198.96.95.183   comment=windscribe list=proxyvpn
add address=185.244.215.254 comment=windscribe list=proxyvpn
add address=185.236.200.23  comment=windscribe list=proxyvpn
add address=199.66.91.167   comment=windscribe list=proxyvpn
add address=104.218.63.38   comment=windscribe list=proxyvpn
add address=185.189.113.58  comment=windscribe list=proxyvpn
add address=185.189.112.119 comment=windscribe list=proxyvpn
add address=185.212.171.55  comment=windscribe list=proxyvpn
add address=185.253.97.183  comment=windscribe list=proxyvpn
add address=185.217.68.247  comment=windscribe list=proxyvpn
add address=82.102.24.55    comment=windscribe list=proxyvpn
add address=185.17.149.188  comment=windscribe list=proxyvpn
add address=27.122.14.87    comment=windscribe list=proxyvpn
add address=185.253.97.130  comment=windscribe list=proxyvpn
/ip firewall mangle
add action=mark-connection chain=prerouting comment=proxyvpn connection-mark=no-mark dst-address-list=proxyvpn \
    new-connection-mark=proxyvpn-conn passthrough=yes
add action=mark-connection chain=prerouting comment=proxyvpn connection-mark=no-mark dst-port=53 layer7-protocol=proxyvpn \
    new-connection-mark=proxyvpn-conn passthrough=yes protocol=udp
add action=mark-packet chain=prerouting comment=proxyvpn connection-mark=proxyvpn-conn new-packet-mark=proxyvpn-packet
/ip firewall filter
add action=reject chain=input comment="block proxyvpn" packet-mark=proxyvpn-packet reject-with=icmp-host-unreachable place-before=0
add action=reject chain=forward comment="block proxyvpn" packet-mark=proxyvpn-packet reject-with=icmp-host-unreachable place-before=0
/ip f co rem [f];/ip dn ca fl;

# DNS blocking section!
#
#/ip firewall address-list
#add address=1.1.1.1 list=allowed-dns
#add address=1.0.0.1 list=allowed-dns
#/ip firewall mangle
#add action=mark-connection chain=prerouting comment=dns connection-mark=no-mark dst-address-list=!allowed-dns dst-port=53 \
#    new-connection-mark=dns-conn passthrough=yes protocol=udp src-address-list=!allowed-dns
#add action=mark-connection chain=prerouting comment=dns connection-mark=no-mark dst-address-list=!allowed-dns dst-port=53 \
#    new-connection-mark=dns-conn passthrough=yes protocol=tcp src-address-list=!allowed-dns
#add action=mark-packet chain=prerouting comment=dns connection-mark=dns-conn new-packet-mark=dns-packet
#/ip firewall filter
#add action=reject chain=input comment="block other dns" packet-mark=dns-packet reject-with=icmp-host-unreachable place-before=0
#add action=reject chain=forward comment="block other dns" packet-mark=dns-packet reject-with=icmp-host-unreachable place-before=0
