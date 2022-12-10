#!/bin/bash

route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.198.0.106

echo nameserver 192.168.122.1 > /etc/resolv.conf

# Pengaturan DHCP Relay
    apt-get update
    apt-get install isc-dhcp-relay -y
    service isc-dhcp-relay start

    dpkg --configure -a
    echo "
    SERVERS=\"192.198.0.115\"     
    INTERFACES=\"eth0 eth1 eth2 eth3\"
    " > /etc/default/isc-dhcp-relay  
    
    service isc-dhcp-relay restart