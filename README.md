## yuki-antiDDoS - simple host-level nftables-based protection against DDoS attacks.

### 📥 Ubuntu Installation
```
sudo apt update && sudo apt remove ufw -y && sudo apt install netfilter-persistent nftables git xtables-addons-common -y && git clone -b beta https://github.com/yuk1c/antiddos && cd antiddos && sudo ./antiddos-yuki && cd ..
``` 

### 📋 Requirements
- Bash
- Ubuntu 20.04+ (24.04 and newer is recommended), [BETA] Debian 11+
###### Requirements for optional (advanced) rules: iptables, ebtables, arptables
###### Requirements for the monitoring.py script: python3

<hr>

### 🔄 Updating the script:
```
cd ~/antiddos && git pull && sudo ./antiddos-yuki && cd
```
<hr>

### 💾 Saving the rules:
```
sudo netfilter-persistent save
```
###### You need to execute this for the rules to persist across reboots.

### [NEW] 🔍 Real-time monitoring:
```
sudo python3 monitoring.py
```
###### You need to have python3 installed for it to work properly.

### ✅ Opening ports:
<code>sudo nft add rule ip yuki-script prerouting tcp dport [port] accept</code>
###### Example: sudo nft add rule ip yuki-script prerouting tcp dport 1194 accept (this is how a rule will look that allows incoming TCP to port 1194)
###### (after adding custom rules, you need to test everything - if the rules work as expected, you can save them, so they will persist across reboots) 
###### 22/tcp (SSH default port) is already allowed so you won't lose connection to your server. Edit this in the config before running the script if your SSH is running on a different port.

<hr>

### 🚩 Common issues/questions
| ❃ Issue/Question  | ❃ Fix/Answer  |
| ------------- |:------------------:|
| Why doesn't the script help me? | Not each attack can be patched on the host-level. If you think that the script don't help you but it still can be fixed on the host level, you can try the optional rules. To enable a optional rule, uncomment it. Also, it's not recommended to enable a rule if you don't know what does it do. |
| I allowed the needed port, but the service on it doesn't work. | You probably chose the wrong protocol or the service needs both TCP and UDP. This can be done via two rules to allow both protocols on a port. |
| Is it possible to view the ruleset' stats | Yes, you can. Use the following command: 'sudo nft list ruleset'. Not every rule has counters enabled, but it's possible to enable them for all the rules manually by editing the script. |
| Does the script work with complicated routing? | Nah, it's not (by default). But to fix it, set rp_filter to 2 in the sysctl tweaks. Makes your server more prone to spoofed attacks. |
| VPNs don't work with this script. How to fix that? | Try to determine all the needed protocols and allow them. Preferably, do this in the script itself. You might need to allow ones such as ESP, AH, L2TP. |
| How to tune the script? | There is a config file 'config.sh' in the repository, you can tune the config, and after all changes, re-apply the script. |
| I have another problem, what to do? | Open an issue or contact me via Telegram (@mintyYuki). |
| My server has networking problems after applying the script. How to fix? | If you started the script, it applied everything, and the SSH stopped working, or you have another problem, and you didn't explicitly save the rules, just restart the server. If you're sure that nothing is wrong, and you didn't modify anything, the problem may be caused by the hoster or the server, or the software running on it. Try to resolve the possible conflicts. If the problem still persist, there may be a problem with your server's hoster. |
