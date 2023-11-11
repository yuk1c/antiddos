## 🛡️ *yuki-antiDDoS* - simple protection against DDoS-attacks.

### 📥 Installation
```
sudo apt update && sudo apt install iptables ipset netfilter-persistent ipset-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo bash antiddos-yuki && cd ..
```
###### You can add --autosave argument to save the rules automatically.

### 🔽 Debian installation (root)
```
apt update && apt install iptables ipset netfilter-persistent ipset-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && bash antiddos-yuki && cd ..
```

### 📋 Requirements
- Bash
- Ubuntu 20.04+ / [BETA] Debian 11+
###### Requirements for optional (advanced) rules: ebtables, arptables, xtables-addons-common (it is needed for antiSpoof rules)
<hr>

### ⛔ Blocked/patched attack types:
- [x] [TCP SYN Flood](https://github.com/yuk1c/antiddos/wiki/TCP-SYN-Flood)
- [x] [TCP Out-Of-State Flood](https://github.com/yuk1c/antiddos/wiki/TCP-Out%E2%80%90Of%E2%80%90State)
- [x] [TCP SYN-ACK Flood/TCP Reflection](https://github.com/yuk1c/antiddos/wiki/TCP-SYN-ACK-Flood)
- [x] [Spoofed attacks](https://github.com/yuk1c/antiddos/wiki/Spoofing-or-Fraggle-attacks)
- [x] [UDP Flood](https://github.com/yuk1c/antiddos/wiki/UDP-Flood)
- [x] [ICMP Flood & PoD](https://github.com/yuk1c/antiddos/wiki/ICMP-Flood)
- [x] [GREIP, ESP, AH, IGMP Floods](https://github.com/yuk1c/antiddos/wiki/GREIP-and-ESP-and-AH-and-IGMP-Floods)
- [x] [Many sophisticated TCP attacks](https://github.com/yuk1c/antiddos/wiki/TCP-Sophiscated-Attacks)
- [x] [HANDSHAKE & Slowloris attacks](https://github.com/yuk1c/antiddos/wiki/HANDSHAKE-&-Slowloris-Attacks)
- [x] [Amplification DDoS](https://github.com/yuk1c/antiddos/wiki/Amplified-DDoS)
- [x] [Null Payload Flood](https://github.com/yuk1c/antiddos/wiki/Null-Payload-Flood)
- [x] Potential IPv6 simple attacks

<hr>

### ✨ Other features:
- [ ] BitTorrent Amplification blocking
- [ ] SIP Scanning blocking
- [ ] SSLv2/SSLv3 HTTPS blocking
- [ ] HTTP Trace method blocking
- [ ] FTP SITE EXEC blocking
- [ ] SQLi Blocking
- [ ] Advanced Spoofing blocking
- [ ] DNS/NTP Filtering
- [ ] IP Option Filter
- [ ] HTTP Filter
- [ ] SSH Filter/Whitelist
- [ ] OpenVPN Filter/Whitelist
- [ ] IPtables proxying
- [ ] SYN/ACK Challenge
- [ ] Zero TTL Blocking
- [ ] SourcePort 1 or 0 Blocking
- [ ] STUN Blocking 

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
| Slow UDP Network Speed | Increase UDP Limit |
| Why script doesn't help me? | You have a slow server, or you're just under a Volumetric DDoS attack. You might try lower limits and optional rules (advanced ruleset). |
| I allowed the needed port, but the service on it doesn't work. | Your service probably works on UDP. Try allowing port on UDP. |
| Can I view the stats of the rules? | Yes, you can. Use the following command: sudo nft list ruleset. |
| Does this script work with complicated routing? | Nah, it's not (by default). But to fix it, set rp_filter to 2. (sysctl tweaks) |
| How can I start the script with automatic ruleset saving? | Use --autosave argument. |
| VPN Doesn't work... | Try to determine needed protocols and allow them in the script with -A or with -I If you want just apply the iptables command. Do not forget to save the changes! |
| How to tune the script? | Check the config.sh, it contains some variables, if you have good knowledge, you can tune the config for your needs to mitigate attacks a bit better. |
| I have other problems, what to do? | Open an issue or contact me via Telegram (@yuk1meow). |
| Network doesn't work after I applied the script, what to do? | After applying the script, if your network stops working, try restarting your server. Avoid using the script on the same host again, as the root cause of the issue is unknown and may persist. |

### 🗨 Telegram group:
– [@yukiscript](https://t.me/yukiscript)
