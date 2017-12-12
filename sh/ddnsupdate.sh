#!/bin/bash
IPV4=$(curl -s "http://v4.ipv6-test.com/api/myip.php")
NS="ns1.ddns.pozzi.me"
ZONE="ddns.pozzi.me."
DOMAIN="csolvenessusbox.ddns.pozzi.me."
KEY="/ddns/Kddns.pozzi.me.+157+17768.key"
nsupdate -k $KEY -v << EOF
debug yes
server $NS
zone $ZONE
update delete $DOMAIN A
update add $DOMAIN 86400 A $IPV4
show
send
EOF
