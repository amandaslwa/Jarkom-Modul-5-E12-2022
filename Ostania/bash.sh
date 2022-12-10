#!/bin/bash

route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.198.0.110

echo nameserver 192.168.122.1 > /etc/resolv.conf

# Pengaturan DHCP Relay
    apt-get update
    apt-get install isc-dhcp-relay -y
    service isc-dhcp-relay start

    dpkg --configure -a
    echo "
    SERVERS=\"192.198.0.115\"
    INTERFACES=\"eth0 eth1 eth3\"
    " > /etc/default/isc-dhcp-relay  
    
    service isc-dhcp-relay restart

# D5
iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 80 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 192.198.0.123:80
iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 80 -j DNAT --to-destination 192.198.0.122:80
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.123 --dport 80 -j SNAT --to-source 192.198.0.114:80
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.122 --dport 80 -j SNAT --to-source 192.198.0.114:80

iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 443 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 192.198.0.122:443 
iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 443 -j DNAT --to-destination 192.198.0.123:443 
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.122 --dport 443 -j SNAT --to-source 192.198.0.114:443 
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.123 --dport 443 -j SNAT --to-source 192.198.0.114:443