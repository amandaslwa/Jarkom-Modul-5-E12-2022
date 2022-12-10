#!/bin/bash

    echo nameserver 192.198.0.114 > /etc/resolv.conf             # IP Eden

    # Pengaturan DHCP Server
    apt-get update
    apt-get install isc-dhcp-server -y
    echo "INTERFACES=\"eth0\"" > /etc/default/isc-dhcp-server

    # Setting untuk setiap subnet
    echo "
    #}

subnet 192.198.0.128 netmask 255.255.255.128 {
    range 192.198.0.130 192.198.0.254;
    option routers 192.198.0.129;
    option broadcast-address 192.198.0.255;
    option domain-name-servers 192.198.0.114;
    default-lease-time 3600;
    max-lease-time 6900;
}

subnet 192.198.4.0 netmask 255.255.252.0 {
    range 192.198.4.2 192.198.7.254;
    option routers 192.198.4.1;
    option broadcast-address 192.198.7.255;
    option domain-name-servers 192.198.0.114;
    default-lease-time 3600;
    max-lease-time 6900;
}

subnet 192.198.2.0 netmask 255.255.254.0 {
    range 192.198.2.2 192.198.3.254;
    option routers 192.198.2.1;
    option broadcast-address 192.198.3.255;
    option domain-name-servers 192.198.0.114;
    default-lease-time 3600;
    max-lease-time 6900;
}

subnet 192.198.1.0 netmask 255.255.255.0 {
    range 192.198.1.2 192.198.1.254;
    option routers 192.198.1.1;
    option broadcast-address 192.198.1.255;
    option domain-name-servers 192.198.0.114;
    default-lease-time 3600;
    max-lease-time 6900;
}

subnet 192.198.0.112 netmask 255.255.255.248 {
    option routers 192.198.0.113;
}
" > /etc/dhcp/dhcpd.conf

    service isc-dhcp-server start

    service isc-dhcp-server restart
    
    # D2

    iptables -A INPUT -p tcp --dport 80 -j DROP
    iptables -A INPUT -p udp --dport 80 -j DROP 

    apt-get install netcat -y

    # D3

    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP

    service isc-dhcp-server restart