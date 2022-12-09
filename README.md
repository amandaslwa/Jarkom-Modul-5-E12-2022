# Jarkom-Modul-4-E12-2022

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

### Konfigurasi

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
