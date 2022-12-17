<p align="center"> <h2 align="center">🍃 Fresh script for DDoS Mitigation with iptables-nft & kernel tweaks</h2> </p> 

<a href="#"><img src="https://img.shields.io/github/last-commit/yuk1c/antiddos"/></a>
<a href="#"><img src="https://img.shields.io/github/contributors/yuk1c/antiddos"/></a></p>
[![DeepSource](https://deepsource.io/gh/yuk1c/antiddos.svg/?label=active+issues&show_trend=true&token=tVgsBqvfV3KBAOkyv3rCEYiV)](https://deepsource.io/gh/yuk1c/antiddos/?ref=repository-badge)

<hr>

<p align="center"> <h3 align="center">⚙️ Installation:</p></h3>

```
apt update && apt install iptables iptables-persistent netfilter-persistent git netfilter -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```
<hr>

<p align="center"> <h3 align="center">☘️ Required packages:</p></h3>

* iptables

* ipset

* iptables-persistent (to save rules)

* netfilter-persistent (to save netfilter rules)

<hr>


#### Just want to drop ping?
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


##### if /etc/sysctl.conf tweaks not work on your system - use script named sysctl-tweaks. Execute as root, and add him to cron 

<hr>

##### If you are under Volumetric DDoS – buy server with protection.
##### Update kernel to the latest version for best results.
##### You can use tweaks and rules on your upstream hardware to offload your server.

