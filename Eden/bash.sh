#!/bin/bash

    echo nameserver 192.168.122.1 > /etc/resolv.conf # IP di nameserver Strix

    # Pengaturan DNS Server
    
    apt-get update
    apt-get install bind9 -y

    echo "
    zone \"jarkom.e12.com\" {
    type master;
    file \"/etc/bind/jarkom/jarkom.e12.com\";
    };
    " > /etc/bind/named.conf.local

    mkdir /etc/bind/jarkom
    cp /etc/bind/db.local /etc/bind/jarkom/jarkom.e12.com
    echo "
    \$TTL    604800
@       IN      SOA     jarkom.e12.com. root.jarkom.e12.com. (
                     2022120801             ; Serial
                         604800             ; Refresh
                          86400             ; Retry
                        2419200             ; Expire
                         604800 )           ; Negative Cache TTL
;
@        IN      NS      jarkom.e12.com.
@        IN      A       192.198.0.114        ; IP Eden
@        IN      AAAA    ::1
" > /etc/bind/jarkom/jarkom.e12.com

    # Mem-forward DNS ke DNS Strix
    echo "options {
    directory \"/var/cache/bind\";

    forwarders {
        192.168.122.1; // IP nameserver dari Strix
    };

    allow-query { any; };

    auth-nxdomain no;   # conform to RFC1035
    listen-on-v6 { any; };
    };
    " > /etc/bind/named.conf.options

    service bind9 start

    service bind9 restart

    # D3

    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP

    service bind9 restart