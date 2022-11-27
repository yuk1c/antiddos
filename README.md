<p align="center"> <h2 align="center">🍃 Fresh script for DDoS Mitigation with iptables & kernel tweaks</h2> </p> 


<a href="#"><img src="https://img.shields.io/github/forks/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/license/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/last-commit/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/contributors/yuk1c/antiddos"/></a></p>
[![DeepSource](https://deepsource.io/gh/yuk1c/antiddos.svg/?label=active+issues&show_trend=true&token=tVgsBqvfV3KBAOkyv3rCEYiV)](https://deepsource.io/gh/yuk1c/antiddos/?ref=repository-badge)

##### If you are under Volumetric DDoS – buy server with protection.
##### Update kernel to the latest version for best results.

<hr>

<p align="center"> <h3 align="center">⚙️ Installation:</p></h3>

```
apt update && apt install iptables iptables-persistent netfilter-persistent git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```
<hr>

### ✨️ He give you protection against:

* TCP SYN Flood

* TCP ACK Flood

* TCP SYN-ACK Flood

* TCP RST Flood

* [ToDo] TCP FIN Flood

* [ToDo] SIP Flood

* [ToDo] TOS Flood

* [ToDo] IP Null Attack

* TCP Null Attack

* TCP "Session Attack"

* Some simple HTTP attacks

* "Fragmented TCP" Attack

* "Fragmented UDP" Attack

* Ping Flood and some ICMP Floods

* SMURF Attack

* Fraggle Attack

* Spoofed Attacks

* [ToDo] IGMP and ARP attacks (sysctl+iptables+arptables)


#### ☘️ Requirements:

* iptables

* ipset

* iptables-persistent (to save rules after reboot)

* netfilter-persistent (to save rules on new distro's)

<hr>

#### To block ICMP (Not recommended):
```
cd ~/antiddos; sudo bash drop-icmp
```

#### Just want to drop echo-requests?
```
iptables -I INPUT -p icmp --icmp-type echo-request -j DROP
```


#### To update the script:
```
cd ~/antiddos && git pull && sudo bash antiddos-yuki
```

<hr>

#### To uninstall:
```
rm -fr ~/antiddos; sudo iptables -F; sudo iptables -Z; sudo iptables -X
```
Delete parameters from /etc/sysctl.conf manually


##### /etc/sysctl.conf tweaks not work on your system - use script named sysctl-tweaks. Execute as root, and add him to cron (because sysctl -w changes resets after reboot)

<hr>

#### If you want to support me:

##### Bitcoin
bc1qvuef0mzerxcv5t43puagtkw83ymjghuv6czkr5

##### Ethereum
0x33A109Ae4B7d77A105968Fb0aE6A9d69cd723Ed2

##### TON
EQARZzTYKAbo9GHS3jjTim-Hh2QLuTuCc3ilagv0YNTs-y5C


##### Thanks you for support 💙
