# Jarkom-Modul-5-E12-2022

Kelas Jaringan Komputer E - Kelompok E12
### Nama Anggota
- Amanda Salwa Salsabila        (5025201172)
- Michael Ariel Manihuruk       (5025201158)
- Azzura Mahendra Putra Malinus (5025201211)

# Modul 5
## VLSM (Variable Length Subnet Masking)

<img width="502" alt="Subnetting" src="https://user-images.githubusercontent.com/90702710/206747007-e93ff352-522c-4fbe-b896-728ad36dfd28.png">

Menentukan jumlah alamat IP yang dibutuhkan oleh tiap subnet dan melabel netmask berdasarkan jumlah IP yang dibutuhkan.

| Subnet | Alias | Jumlah IP | Netmask |
| --- | --- | --- | --- |
| A1	| Westalis - Eden - WISE |	3	| /29 |
| A2	| Westalis - Forger |	63 |	/25 |
| A3	| Westalis - Desmond |	701 |	/22 |
| A4	| Strix - Westalis |	2 |	/30 |
| A5	| Ostania - Garden - SSS |	3 |	/29 |
| A6	| Ostania - Briar |	201 |	/24 |
| A7	| Ostania - Blackbell |	256 |	/23 |
| A8	| Strix - Ostania |	2 |	/30 |
| TOTAL	|	| 1231	| /21 |

### Pohon IP

Subnet besar yang dibentuk memiliki NID 192.198.0.0 dengan netmask /21 sehingga pembagian IP berdasarkan NID dan netmask dihitung sesuai dengan pohon berikut.

![Tree](https://user-images.githubusercontent.com/90702710/206747386-d4de8fb0-c6ba-4757-8319-a58119931db5.jpg)

Pada VLSM, IP diturunkan sesuai dengan length atasnya. Pembagian IPnya mengikuti tabel. Jika ada subnet yang bisa digunakan, maka subnet langsung digunakan. Hal ini dilakukan berulang sampai semua subnet digunakan.

### Pembagian IP

Pembagian IP tiap node disesuaikan dengan pembagian subnet berdasarkan pohon di atas pada topologi.

<img width="909" alt="image" src="https://user-images.githubusercontent.com/90702710/206747694-d9b6a3e2-1889-4886-b9ef-e0548c00bfef.png">

### Konfigurasi Network Interfaces

- Strix
```
auto eth0
iface eth0 inet static
	address 192.168.122.50
	netmask 255.255.255.0
        gateway 192.168.122.1

auto eth1
iface eth1 inet static
	address 192.198.0.110
	netmask 255.255.255.252

auto eth2
iface eth2 inet static
	address 192.198.0.106
	netmask 255.255.255.252
```
- Ostania
```
auto eth0
iface eth0 inet static
	address 192.198.0.109
	netmask 255.255.255.252
        gateway 192.198.0.110

auto eth1
iface eth1 inet static
	address 192.198.2.1
	netmask 255.255.254.0

auto eth2
iface eth2 inet static
	address 192.198.0.121
	netmask 255.255.255.248

auto eth3
iface eth3 inet static
	address 192.198.1.1
	netmask 255.255.255.0
```
- Westalis
```
auto eth0
iface eth0 inet static
	address 192.198.0.105
	netmask 255.255.255.252
        gateway 192.198.0.106

auto eth1
iface eth1 inet static
	address 192.198.4.1
	netmask 255.255.252.0

auto eth2
iface eth2 inet static
	address 192.198.0.129
	netmask 255.255.255.128

auto eth3
iface eth3 inet static
	address 192.198.0.113
	netmask 255.255.255.248
```
- Eden
```
auto eth0
iface eth0 inet static
	address 192.198.0.114
	netmask 255.255.255.248
        gateway 192.198.0.113
```
- WISE
```
auto eth0
iface eth0 inet static
	address 192.198.0.115
	netmask 255.255.255.248
        gateway 192.198.0.113
```
- Garden
```
auto eth0
iface eth0 inet static
	address 192.198.0.122
	netmask 255.255.255.248
        gateway 192.198.0.121
```
- SSS
```
auto eth0
iface eth0 inet static
	address 192.198.0.123
	netmask 255.255.255.248
        gateway 192.198.0.121
```
- Client (Forger, Desmond, Blackbell, Briar)
```
auto eth0
iface eth0 inet dhcp
```

### Strix
Routing dan instalasi DHCP relay.
```
#!/bin/bash

route add -net 192.198.4.0 netmask 255.255.252.0 gw 192.198.0.105
route add -net 192.198.0.128 netmask 255.255.255.128 gw 192.198.0.105
route add -net 192.198.0.112 netmask 255.255.255.248 gw 192.198.0.105

route add -net 192.198.2.0 netmask 255.255.254.0 gw 192.198.0.109
route add -net 192.198.0.120 netmask 255.255.255.248 gw 192.198.0.109
route add -net 192.198.1.0 netmask 255.255.255.0 gw 192.198.0.109

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
```

### Ostania
Routing dan instalasi DHCP relay.
```
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
```

### Westalis
Routing dan instalasi DHCP relay.
```
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
```

### Eden
Instalasi bind9 dan konfigurasi DNS Server
#!/bin/bash

    echo nameserver 192.168.122.1 > /etc/resolv.conf # IP di nameserver Strix

    # Pengaturan DNS Server
    
    apt-get update
    apt-get install bind9 -y
    service bind9 start

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

    service bind9 restart
    ```
 
 ### WISE
 Instalasi isc-dhcp=server dan konfigurasi DHCP Server.
 ```
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
 ```
