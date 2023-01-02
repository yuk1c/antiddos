<p align="center"> <h2 align="center">Fresh AntiDDoS Script based on iptables-nft & kernel tweaks</h2> </p> 

<a href="#"><img src="https://img.shields.io/github/last-commit/yuk1c/antiddos"/></a>
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

* iptables-persistent

* netfilter-persistent

<hr>


#### To block incoming ping requests:
```
sudo iptables -I INPUT -p icmp --icmp-type echo-request -j DROP
```


#### To update the script:
```
cd ~/antiddos && git pull && sudo bash antiddos-yuki
```

<hr>

##### if /etc/sysctl.conf tweaks not work on your system - use script named sysctl-tweaks. Execute as root, and add him to cron 
##### If you are under Volumetric DDoS – buy server with protection.
##### Update kernel to the latest version for best results.
##### You can use tweaks and rules on your upstream hardware to offload your server.

