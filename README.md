<div align="center">
  <img src="https://github.com/user-attachments/assets/96b9d177-fe29-41f4-8a6e-7731d5696409"
       alt="banner"
       style="width: 7%; height: auto;" />
    <h1> yuki-antiddos</h1>
</div>



<p align="center">
  <img src="https://img.shields.io/badge/Backend-nftables-red?style=for-the-badge" alt="Backend: nftables"/>
  <img src="https://img.shields.io/badge/License-MIT-blueviolet?style=for-the-badge" alt="License: MIT"/>
  <img src="https://img.shields.io/badge/Protection-L3--L4-critical?style=for-the-badge&logo=linux" alt="Protection Level: L3-L4"/>
  <img src="https://img.shields.io/badge/Ubuntu-24.04%2B-orange?style=for-the-badge&logo=ubuntu" alt="OS: Ubuntu 24.04+"/>
</p>


## ❔ What this is?
yuki-antiddos is a simple project aimed at mitigating most of the L3-L4 attacks by using just nftables and kernel tweaks. It's made for servers, desktops (what if you need more security in public networks on your Linux laptop?), and routers (additional configuration needed in this case). It's capable of filtering even the most sophisticated attacks at the same time leaving your legitimate traffic untouched and not impacting the overall performance and CPU load. To know how is this possible, continue reading.

## ⏩ **Optimization**
Most of ruleset makers forget about optimization; We don't.
Our custom techniques allow for filtering out attacks with massive PPS rates without causing unnecessary strain on your server’s CPU.

## ⚙️ **Features**
- 🛡️ Split-chain system
- ⛔ Default drop policy
- 📶 Two-stage UDP stateful ratelimiting
- 🧩 Sysctl-level kernel tuning

## 📦 **Installation**
```
sudo apt update && sudo apt purge ufw firewalld -y && sudo apt install nftables git -y && git clone https://github.com/yuk1c/antiddos && cd antiddos && sudo ./antiddos-yuki && cd ..
```

## 🧪 **Compatibility**

| Distribution       | Status                 |
|--------------------|------------------------|
| **Ubuntu 24.04+**   | Fully supported and recommended  |
| **Ubuntu < 24.04**  | Not recommended                  |
| **Debian 12+**      | Partially supported              |
| **Other distros**   | Not supported                    |


## 📋 **Dependencies**
- Nftables, for packet filtering
- Git, to clone the repository

## ⁉️ <a href="https://github.com/yuk1c/antiddos/wiki/FAQ">FAQ</a>
