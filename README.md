## A new AntiDDoS script based on ipt-nft & kernel tweaks

## Installation
```
sudo apt update && sudo apt install iptables ipset netfilter-persistent git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

## Attack types that blocked by script:
- Many Layer3 attacks like GRE Flood
- Many types of TCP Flood attacks
- Popular types of UDP Flood attacks
- Some Layer7 attacks: HTTP Flood

## To quickly update the script:
```
cd ~/antiddos && git pull
```

## You're under volumetric DDoS?
- You should buy protected server, because this DDoS Attack type can't be blocked normally on server-side.
- As a temporary solution, you can "tune" script, and set lower ratelimits. It will help a bit.

## Tweaks works bad?
- Try to update kernel. Tweaks are working normally on new kernel versions.
