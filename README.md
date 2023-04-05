## A new AntiDDoS script based on ipt-nft & kernel tweaks

## Installation
```
sudo apt update && sudo apt install iptables ipset netfilter-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

## Attack types that are blocked by script:
- Many Layer3 attacks like GRE Flood
- Many types of TCP Flood attacks
- Popular types of UDP Flood attacks
- Some Layer7 attacks like HTTP Flood

## To quickly update the script:
```
cd ~/antiddos && git pull && sudo bash antiddos-yuki && cd
```

## You're under volumetric DDoS?
- You should buy a protected server because this DDoS Attack type can't be blocked normally on the server side.
- As a temporary solution, you can "tune" the script, and set lower rate limits. It will help a bit.

## Script was tested on:
- Ubuntu 18-22.10
- Debian 11

## SSH not work or server wont boot?
- 1 - Restart your server and contact me via Telegram (@yuk1meow).
- 2 - Replace current sysctl.conf file with backup sysctl, or load another kernel.

## Script may cause problems, if:
- You use UFW or just DROP policy somewhere (set policy to ACCEPT)
- You use other antiDDoS script (uninstall it)
- You use modified kernel (install official kernel)
- You use assymetric routing (don't use the script)
