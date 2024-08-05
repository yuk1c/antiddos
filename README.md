## yuki-antiDDoS - simple host-level nftables-based protection against DDoS attacks.

### 📥 Ubuntu Installation
```
sudo apt update && sudo apt install netfilter-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo ./antiddos-yuki && cd ..
``` 

### 🔽 Debian Installation (experimental)
###### Please note that the command needs to be run as "root"
```
apt update && apt install iptables ipset netfilter-persistent ipset-persistent nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && bash antiddos-yuki && cd ..
```

### 📋 Requirements
- Bash
- Ubuntu 20.04+ / [BETA] Debian 11+
###### Requirements for optional (advanced) rules: iptables, ebtables, arptables, xtables-addons-common (it is needed for antiSpoof rules)
<hr>

### ⛔ Mitigated attack types:
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

<hr>

### ✨ Advanced RuleSet Features:
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
cd ~/antiddos && git pull && sudo ./antiddos-yuki && cd
```

<hr>

### 💾 Saving the rules:
```
sudo netfilter-persistent save
```
###### Execute this, if after you ran the script, you don't have any problems, so the rules will survive reboots. Currently, this must be done manually.

### ✅ Allowing needed ports:
<code>sudo nft add rule ip yuki-script prerouting tcp dport <port> accept</code>
###### Example: sudo nft add rule ip yuki-script prerouting tcp dport 1194 accept (this is how a rule will look that allows incoming TCP to port 1194)
###### (after adding custom rules, you need to test everything - if the rules work as expected, you can save them, so they won't get deleted after a reboot) 
###### 22/tcp (SSH default port) is already allowed so you won't lose connection to your server. Edit this in the config before running the script if you have SSH on a different port.

<hr>

### 🚩 Common issues/questions
| ❃ Issue/Question  | ❃ Fix/Answer  |
| ------------- |:------------------:|
| Why doesn't the script help me? | Not each attack can be patched on the host-level. If you think that the script don't help you but it still can be fixed on the host level, you can try the optional rules. To enable a optional rule, uncomment it. Also, it's not recommended to enable a rule if you don't know what does it do. |
| I allowed the needed port, but the service on it doesn't work. | You probably chose the wrong protocol or the service needs both TCP and UDP. This can be done via two rules to allow both protocols on a port. |
| Can I view the statistics of the rules? | Yes, you can. Use the following command: 'sudo nft list ruleset'. Not every rule has counters enabled, but it's possible to enable them for all the rules, if you want. |
| Does this script work with complicated routing? | Nah, it's not (by default). But to fix it, set rp_filter to 2 in the sysctl tweaks. Makes your server more prone to spoofed attacks. |
| A VPN doesn't work with this script. How do I fix that? | Try to determine all the needed protocols and allow them. Preferably, do this in the script itself. You might need to allow ones such as ESP, AH, L2TP. |
| How to tune the script? | There is a config file 'config.sh' in the repository, you can tune the config, and after all changes, re-apply the script. |
| I have another problem, what to do? | Open an issue or contact me via Telegram (@mintyYuki). |
| My server has networking problems after applying the script. How to fix? | If you started the script, it applied everything, and the SSH stopped working, or you have another problem, and you didn't explicitly save the rules, just restart the server. If you sure that nothing is wrong, and you didn't modify anything, the problem may be caused by the hoster or the server, or the software running on it. Try to resolve the possible conflicts. If the problem still persist, there may be a problem with your server's hoster. |
| |
