# Jarkom-Modul-5-E12-2022

Kelas Jaringan Komputer E - Kelompok E12
### Nama Anggota
- Amanda Salwa Salsabila        (5025201172)
- Michael Ariel Manihuruk       (5025201158)
- Azzura Mahendra Putra Malinus (5025201211)

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

## Konfigurasi Network Interfaces

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

    echo nameserver 192.168.122.1 > /etc/resolv.conf

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
 Instalasi isc-dhcp-server dan konfigurasi DHCP Server.
 ```
 #!/bin/bash

    echo nameserver 192.198.0.114 > /etc/resolv.conf

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
 ### Garden dan SSS
 Instalasi apache2, php, serta libapache2-mod-php7.0 dan konfigurasi Web Server.
 ```
 #!/bin/bash

    echo nameserver 192.168.122.1 > /etc/resolv.conf     # IP Default Strix

    # Instalasi Web server
    apt-get update
    apt-get install apache2 -y
    apt-get install php -y
    apt-get install libapache2-mod-php7.0 -y
    service apache2 restart

    cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wise.e12.com
    echo " <VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/wise.e12.com

    a2ensite wise.e12.com

    service apache2 restart
 ```
### Client (Forger, Desmond, Blackbell, Briar)
```
#!/bin/bash

    echo nameserver 192.198.0.114 > /etc/resolv.conf
```

## Soal
### 1. Agar topologi yang kalian buat dapat mengakses keluar, kalian diminta untuk mengkonfigurasi Strix menggunakan iptables, tetapi Loid tidak ingin menggunakan MASQUERADE.

- Strix
```
ip_eth0=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source $ip_eth0 -s 192.198.0.0/16
```
Variabel ip_eth0 berisi IP address dari interface eth0 router Strix. Perintah iptables di atas mirip dengan yang pernah diberikan pada modul GNS3, hanya saja `MASQUERADE` diganti dengan `-j SNAT --to-source $ip_eth0` yang artinya IP sumber dari paket yang keluar dari eth0 akan diganti menjadi IP eth0.

```
iptables -t nat -A POSTROUTING -s 192.198.0.0/21 -o eth0 -j SNAT --to-source 192.168.122.50
```
- Hasil
<img width="433" alt="image" src="https://user-images.githubusercontent.com/90702710/206855052-88e950fc-1156-4add-a249-3c586f372725.png">

### 2. Kalian diminta untuk melakukan drop semua TCP dan UDP dari luar Topologi kalian pada server yang merupakan DHCP Server demi menjaga keamanan.
- WISE
```
iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -p udp --dport 80 -j DROP
```
- Hasil
Test ping google.com(https) vs ping monta.if.its.ac.id(http)
<img width="422" alt="image" src="https://user-images.githubusercontent.com/90702710/206855206-2f0acf83-f4f2-40f7-b3d6-583ef3856bd6.png">

### 3. Loid meminta kalian untuk membatasi DHCP dan DNS Server hanya boleh menerima maksimal 2 koneksi ICMP secara bersamaan menggunakan iptables, selebihnya didrop.
- WISE dan Eden
```
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP
```
- Hasil
<img width="960" alt="image" src="https://user-images.githubusercontent.com/90702710/206854263-182628f6-9b2c-4816-8332-55c86cf6b3ab.png">

### 4. Akses menuju Web Server hanya diperbolehkan disaat jam kerja yaitu Senin sampai Jumat pada pukul 07.00 - 16.00.
- Garden dan SSS
```
    iptables -A INPUT -d 192.198.0.120/29 -m time --timestart 07:00 --timestop 16:00 --weekdays Mon,Tue,Wed,Thu,Fri -j ACCEPT 
    iptables -A INPUT -d 192.198.0.120/29 -j REJECT
```
- Hasil
<img width="322" alt="image" src="https://user-images.githubusercontent.com/90702710/207018780-2bccd825-8a23-4ac9-9b08-951933c65dba.png">

### 5. Karena kita memiliki 2 Web Server, Loid ingin Ostania diatur sehingga setiap request dari client yang mengakses Garden dengan port 80 akan didistribusikan secara bergantian pada SSS dan Garden secara berurutan dan request dari client yang mengakses SSS dengan port 443 akan didistribusikan secara bergantian pada Garden dan SSS secara berurutan.
- Ostania
```
iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 80 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 192.198.0.123:80
iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 80 -j DNAT --to-destination 192.198.0.122:80
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.123 --dport 80 -j SNAT --to-source 192.198.0.114:80
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.122 --dport 80 -j SNAT --to-source 192.198.0.114:80

iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 443 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 192.198.0.122:443 
iptables -A PREROUTING -t nat -p tcp -d 192.198.0.114 --dport 443 -j DNAT --to-destination 192.198.0.123:443 
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.122 --dport 443 -j SNAT --to-source 192.198.0.114:443 
iptables -t nat -A POSTROUTING -p tcp -d 192.198.0.123 --dport 443 -j SNAT --to-source 192.198.0.114:443
```
- Hasil

Pada Web Server dan Client
```
apt-get install netcat -y
```
Testing pada Web Server
```
nc -l -p 80
```
<img width="175" alt="Nomor 5 Server" src="https://user-images.githubusercontent.com/90702710/207027053-fff49173-05d8-4cb4-9c0c-4114687c14ed.png">

Testing pada Client
```
nc 192.198.0.114 80
```
<img width="242" alt="Nomor 5 Client" src="https://user-images.githubusercontent.com/90702710/207027097-7ec326ca-da9b-4617-bac2-03ea7909074f.png">


## Kendala
- Masih bingung mengerjakan nomor 6
