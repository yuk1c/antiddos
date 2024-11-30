## yuki-antiDDoS - simple host AntiDDoS.

### Quick Installation
```
sudo apt update && sudo apt purge ufw -y && sudo apt install nftables git -y && git clone -b beta https://github.com/yuk1c/antiddos && cd antiddos && sudo ./antiddos-yuki && cd ..
``` 

This command completely removes UFW and its config since the script isn't compatible with it. Make sure you don't rely on UFW before running it.

### Dependencies
The basic dependencies are <code>nftables</code> (for the rules) and <code>git</code> (so you can download the script, update it, etc.). Nothing else.
For the advanced ruleset, you'll need <code>xtables-addons-common</code> (cool things for iptables), <code>iptables</code> itself, <code>ebtables</code> for L2 rules, and <code>arptables</code> for ARP filtering rules.
Please note that if you won't use the advanced ruleset you don't need these additional dependencies and only the basic ones are required.
For the monitoring script, you'd need to have Python 3 installed.

### Compatibility
- Ubuntu 22.04+
- Debian 11+ [Beta]

Probably compatible with other Debian-based distros.
Use the newest LTS Ubuntu release for the script to perform at its best.
Also, you can use the script on your Linux laptop, for example, so you'll care less about being targeted with L3-L4 attacks in public networks.

<hr>

### Quick Update
```
cd ~/antiddos && git pull && sudo ./antiddos-yuki && cd
```

### Real-time monitoring
```
sudo python3 monitoring.py
```

### Opening ports
Add a rule to the beginning of the user-rules.nft file. Here's an example of one: (allow TCP to port 25565, for Minecraft servers) <code>add rule ip yuki-script prerouting <u>tcp</u> dport <u>25565</u> counter accept</code>
There are already some pre-defined rules; just uncomment needed and re-apply the script.
