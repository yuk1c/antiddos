# IPtables AntiDDoS Rules ⚔️
This bash script adds rules to iptables, that protects you from Attacks on L4 OSI Model, like SYN Flood. Working only on Debian-based.
##### If you are under volumetric DDoS - this rules doesn't help to you, bc this attacks overwhelm internal network capacity of ur server. Use VPS/VDS/DS with AntiDDoS.

## Installation:
```
sudo apt install ipset iptables ufw git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

## He give you protection against:

SYN Flood;

Fraggle attack (UDP and TCP);

Spoofed attacks (UDP and TCP);

Attacks that using invalid packets;

TCP RST Flood;

UDP attacks, that not overwhelm ur network capacity.


#### Will be added protection for ICMP later.

