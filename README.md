## A new firewall (antiDDoS) script based on ipt-nft & kernel tweaks

## Installation
```
sudo apt update && sudo apt install iptables ipset netfilter-persistent ipset-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

## Attack types blocked by script:
- Many Layer3 attacks like GRE Flood
- Many types of TCP Flood attacks
- Popular types of UDP Flood attacks

## To quickly update the script:
```
cd ~/antiddos && git pull && sudo bash antiddos-yuki && cd
```
## To report about new DDoS attack to a creator:
– Make sure you're under DDoS
```
sudo dmesg > dmesg.txt && sudo nft list ruleset > rules_stats.txt && sudo tcpdump -c 50000 -n -w capture_of_ddos.pcap
```
– Then send these files to @yuk1meow (telegram).

– Finally, attack will be patched, if it possible.

## You're under volumetric DDoS?
- You should buy a protected server because this DDoS Attack type can't be blocked normally on the server side.
- As a temporary solution, you can set lower rate limits. It will help a bit.

## Script work on:
- Ubuntu 20.04–22.04

## SSH not working or server won't boot?
- 1 - Restart your server and contact me via Telegram (@yuk1meow).
- 2 - Replace current sysctl.conf file with backup sysctl, or load another kernel.

## Script may cause problems, if:
- You use UFW or just DROP policy somewhere
- You use another antiDDoS script (uninstall it)
- You use a modified kernel (install the official kernel)
- You use complicated routing (don't use the script)
  You use it on a router
