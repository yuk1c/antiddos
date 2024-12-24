## yuki-antiDDoS - simple host AntiDDoS.

### Quick Installation
```
sudo apt update && sudo apt purge ufw firewalld -y && sudo apt install nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo ./antiddos-yuki && cd ..
``` 

This command removes UFW/firewalld completely as the script isn't compatible with them. Make sure you don't rely on them before running it.

### Dependencies
The mandatory dependencies are <code>nftables</code> (for the rules) and <code>git</code> (so you can download the script, update it, etc.). Nothing else.
For the monitoring script, you'd need to have Python 3 installed.

### Compatibility
- Ubuntu 22.04+
- Debian 11+ [Beta]

Probably compatible with other Debian-based distros.
Use the newest LTS Ubuntu release for the script to perform at its best.
Also, you can use the script on your Linux laptop, for example, so you'll care less about being targeted with L3-L4 attacks in public networks.

### Quick Update
```
cd ~/antiddos && git pull && sudo ./antiddos-yuki && cd
```

### Real-time monitoring
```
sudo python3 monitoring.py
```

### Opening ports
Add a rule to the beginning of the user-rules.nft file. Here's an example of one to allow TCP to port 25565 (for Minecraft servers):

<code>add rule ip yuki-script prerouting <u>tcp</u> dport <u>25565</u> counter accept</code>

#### There are some pre-defined rules already; just uncomment ones you need and re-apply the script.
