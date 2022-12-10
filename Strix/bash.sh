#!/bin/bash

route add -net 192.198.4.0 netmask 255.255.252.0 gw 192.198.0.105
route add -net 192.198.0.128 netmask 255.255.255.128 gw 192.198.0.105
route add -net 192.198.0.112 netmask 255.255.255.248 gw 192.198.0.105

route add -net 192.198.2.0 netmask 255.255.254.0 gw 192.198.0.109
route add -net 192.198.0.120 netmask 255.255.255.248 gw 192.198.0.109
route add -net 192.198.1.0 netmask 255.255.255.0 gw 192.198.0.109

# D1
iptables -t nat -A POSTROUTING -s 192.198.0.0/21 -o eth0 -j SNAT --to-source 192.168.122.50

echo nameserver 192.168.122.1 > /etc/resolv.conf

# Pengaturan DHCP Relay
    apt-get update
    apt-get install isc-dhcp-relay -y
    service isc-dhcp-relay start

    dpkg --configure -a
    echo "
    SERVERS=\"192.198.0.115\" 
    INTERFACES=\"eth1 eth2\"
    "> /etc/default/isc-dhcp-relay  
    
    service isc-dhcp-relay restart

# D2

apt-get install netcat -y