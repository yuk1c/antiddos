<a href="#"><img src="https://img.shields.io/github/forks/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/license/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/last-commit/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/contributors/yuk1c/antiddos"/></a>
[![DeepSource](https://deepsource.io/gh/yuk1c/antiddos.svg/?label=active+issues&show_trend=true&token=tVgsBqvfV3KBAOkyv3rCEYiV)](https://deepsource.io/gh/yuk1c/antiddos/?ref=repository-badge)
### DDoS Mitigation using iptables
This bash script adds rules to iptables, that protects you from Attacks on L4 OSI Model, like SYN Flood. Working only on Debian-based.
##### If you are under volumetric DDoS - this rules doesn't help to you, bc this attacks overwhelm network capacity of ur server. Use VPS/VDS/DS with AntiDDoS.

### ⚙️ Installation:
```
sudo apt install ipset iptables ufw git iptables-persistent -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
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

### You can update this script, using:
```
sudo iptables -F; cd ~/antiddos && git pull && sudo bash antiddos-yuki
```

### For deleting all rules and this script, write:
```
rm -fr ~/antiddos; sudo iptables -F
```
Delete parameters from /etc/sysctl.conf manually (if u need)
