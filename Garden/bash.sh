#!/bin/bash

    echo nameserver 192.198.0.114 > /etc/resolv.conf

apt-get update
apt-get install apache2 -y
service apache2 start
apt-get install netcat -y

    # D4

    iptables -A INPUT -d 192.198.0.120/29 -m time --timestart 07:00 --timestop 16:00 --weekdays Mon,Tue,Wed,Thu,Fri -j ACCEPT 
    iptables -A INPUT -d 192.198.0.120/29 -j REJECT