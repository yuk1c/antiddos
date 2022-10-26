### DDoS Mitigation using iptables
This bash script adds rules to iptables, that protects you from Attacks on L4 OSI Model, like SYN Flood. Working only on Debian-based.
##### If you are under volumetric DDoS - this rules doesn't help to you, bc this attacks overwhelm internal network capacity of ur server. Use VPS/VDS/DS with AntiDDoS.

### ⚙️ Installation:
```
sudo apt install ipset iptables ufw git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

### ⚔️ He give you protection against:

* TCP Flood attacks

* Fraggle attacks

* Spoofed attacks

* Attacks, that using invalid packets

* ICMP attacks

* UDP attacks, that not overwhelm ur network capacity.


### ❓️ Want to drop all ICMP?
```
chmod +x drop-icmp && sudo bash drop-icmp
```

I recommend you use drop-icmp script only if u under ICMP attack, or u want to make your server invisible for ICMP.
