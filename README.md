## 🛡️ *yuki-antiDDoS* - simple protection against DDoS-attacks.

### 📥 Installation
```
sudo apt update && sudo apt install iptables ipset netfilter-persistent ipset-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```

### 📋 Requirements
- Bash
- Ubuntu 20.04 or later.
<hr>

### ⛔ Blocked/patched attack types:
- [x] [TCP SYN Flood](https://github.com/yuk1c/antiddos/wiki/TCP-SYN-Flood)
- [x] [TCP ACK Flood](https://github.com/yuk1c/antiddos/wiki/TCP-ACK-Flood)
- [x] [TCP SYN-ACK Flood/TCP Reflection](https://github.com/yuk1c/antiddos/wiki/TCP-SYN-ACK-Flood)
- [x] [TCP STOMP Attack](https://github.com/yuk1c/antiddos/wiki/TCP-STOMP-ACKPSH-Flood)
- [x] [TCP RST Flood](https://github.com/yuk1c/antiddos/wiki/TCP-FIN-or-RST-Flood)
- [x] [TCP FIN Flood](https://github.com/yuk1c/antiddos/wiki/TCP-FIN-or-RST-Flood)
- [x] [Spoofed attacks](https://github.com/yuk1c/antiddos/wiki/Spoofing-or-Fraggle-attacks)
- [x] [UDP Flood](https://github.com/yuk1c/antiddos/wiki/UDP-Flood)
- [x] [ICMP Flood & PoD](https://github.com/yuk1c/antiddos/wiki/ICMP-Flood)
- [x] [GREIP, ESP, AH, IGMP Floods](https://github.com/yuk1c/antiddos/wiki/GREIP-and-ESP-and-AH-and-IGMP-Floods)
- [x] [Many sophisticated TCP attacks](https://github.com/yuk1c/antiddos/wiki/TCP-Sophiscated-Attacks)
- [x] [HANDSHAKE & Slowloris attacks](https://github.com/yuk1c/antiddos/wiki/HANDSHAKE-&-Slowloris-Attacks)
- [x] [Amplification DDoS](https://github.com/yuk1c/antiddos/wiki/Amplified-DDoS)
- [x] Potential IPv6 simple attacks

<hr>

### ✨ Other features:
- [ ] BitTorrent Amplification blocking
- [ ] SIP scanning blocking
- [ ] SSLv2/SSLv3 HTTPS blocking
- [ ] HTTP Trace method blocking
- [ ] FTP SITE EXEC blocking
- [ ] SQLi blocking
- [ ] Advanced spoofing blocking
- [ ] SSH/oVPN... whitelisting

### 🔄 Updating the script:
```
cd ~/antiddos && git pull && sudo bash antiddos-yuki && cd
```

### 🗑️ Uninstalling the script:
<code>sudo iptables-nft -P INPUT ACCEPT && sudo nft flush ruleset && sudo ipset destroy blacklist</code>
###### After this, restore the original sysctl.conf from a backup, and save changes: <code>sudo netfilter-persistent save</code>

<hr>

### 💾 Saving the rules:
```
sudo netfilter-persistent save
```

### ✅ Allowing needed ports:
<code>sudo iptables-nft -I INPUT -p [tcp/udp] -m multiport --dports [port,port...] (max – 15 ports) -j ACCEPT</code>
###### Example: sudo iptables-nft -I INPUT -p tcp -m multiport --dports 1194 -j ACCEPT (will allow tcp to 1194).

<hr>

### 🚩 Common issues/questions
| ❃ Issue/Question  | ❃ Fix/Answer  |
| ------------- |:------------------:|
| Slow TCP Network Speed | Increase ACK and ACK-PSH Limit |
| Slow UDP Network Speed | Increase UDP Limit |
| Why script doesn't help me? | You have a slow server, or you're just under a Volumetric DDoS attack. You might try lower limits. |
| I allowed the needed port, but the service on it won't work. | Your service probably works on UDP. Try allowing port on UDP. |
| Can i view the stats of the rules? | Yes, you can. Use the following command: sudo nft list ruleset. |
| Does this script works with complicated routing? | Nah, it's not. But to fix it, set rp_filter to 2. |
| I have other problems, what to do? | Open an issue or contact me via Telegram (@yuk1meow). |
| Network doesn't work after I applied the script, what to do? | Restart your server and never use my script again on the same host. Because this is unfixable - caused by unknown for my problem. |
