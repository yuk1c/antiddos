## A new firewall (antiDDoS) script based on ipt-nft & kernel tweaks

## Installation
```
sudo apt update && sudo apt install iptables ipset netfilter-persistent ipset-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

## Blocked/patched attack types:
- [x] TCP SYN Flood
- [x] TCP SYN src-port <1024 
- [x] TCP ACK Flood
- [x] TCP SYN-ACK Flood/TCP Reflection
- [x] TCP STOMP Attack
- [x] TCP RST Flood
- [x] TCP FIN Flood
- [x] Spoofed attacks
- [x] UDP Flood
- [x] ICMP Flood & PoD
- [x] GREIP, ESP, AH, IGMP Floods
- [x] Many sophisticated TCP attacks
- [x] HANDSHAKE & Slowloris attacks
- [x] Simple HTTP Flood with high requests volume
- [x] Amplification DDoS
- [x] IP Malformed Header attack
- [x] IP Invalid Fragmentation attacks
- [x] SNMP-Based attacks
- [x] Potential IPv6 simple attacks

### Other features:
- [ ] BitTorrent Amplification blocking
- [ ] SIP scanning blocking
- [ ] SSLv2/SSLv3 HTTPS blocking
- [ ] HTTP Trace method blocking
- [ ] FTP SITE EXEC blocking
- [ ] SQLi blocking
- [ ] Advanced spoofing blocking
- [ ] SSH/oVPN... whitelisting

### Updating the script:
```
cd ~/antiddos && git pull && sudo bash antiddos-yuki && cd
```
### To report about new DDoS attack to a creator:
– Make sure you're under DDoS
```
sudo dmesg > dmesg.txt && sudo tcpdump -c 5000 -n -w capture_of_ddos.pcap
```
– Then send these files to @yuk1meow (telegram).

– Finally, the attack will be patched, if possible.

### You're under volumetric DDoS?
- You should buy a protected server because this DDoS Attack type can't be blocked normally on the server side.
- As a temporary solution, you can set lower rate limits. It will help a bit.

### Script work on:
- Ubuntu 20.04–23.04

### Have some problems?
- Restart your server and contact me via Telegram (@yuk1meow).

### Script may cause problems, if:
- You use another antiDDoS script (uninstall it)
- You use a modified kernel (install the official kernel)
- You use complicated routing (don't use the script)
- You use it on a router
- You use it with VPN
  
### Allowing needed ports:
```
sudo iptables-nft -A INPUT -p [tcp/udp] -m multiport --dports [port,port...] (max – 15 ports) -j ACCEPT
```
Example: sudo iptables-nft -A INPUT -p tcp -m multiport --dports 1194 -j ACCEPT (will allow tcp to 1194)

### To save rules:
```
sudo netfilter-persistent save
```

### Slow TCP Download speed?
Then try to increase the limit for ACK and ACK-PSH packets.

