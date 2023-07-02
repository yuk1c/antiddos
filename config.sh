#################
# CONFIGURATION #
#################
#
# Binary routes: ipt-nft, ip6t-nft, ipset, nft
IP="/sbin/iptables-nft"
IP6="/sbin/ip6tables-nft"
IPS="/sbin/ipset"
NFT="/sbin/nft"

# SSH Port.
# Ignore this if you don't use SSH.
# Default: 22 (ssh)
SSH="22"

# All ports of running webservers.
# Ignore this if you don't have them.
# Default: 80
HTTP="80"

# Connection limit (per one IP)
# Recommended: 100 connections
CL="100"

# Connection limit action
# Recommended: DROP
CLA="DROP"

# UserAgent block action
# Recommended: DROP
# You should use WAF if you're under attack
# Or if you're using HTTPS+HSTS
UBA="DROP"

# Proto block action
# Recommended: DROP
PBA="DROP"

# IP Block action
# Recommended: DROP
# No need to change it without reason.
IBA="DROP"

# SYN PPS limit (per IP)
# Recommended: 5/s
SPL="5/s"

# ACK PPS limit (per IP)
# Recommended: 4900/s
APL="4900/s"

# SYN-ACK PPS limit (per IP)
# Recommended: 5/s
SAPL="5/s"

# ACK-PSH PPS limit (per IP)
# Recommended: 1000/s
APPL="1000/s"

# RST PPS limit (per IP)
# Recommended: 2/s
RPL="2/s"

# FIN PPS limit (per IP)
# Recommended: 2/s
FPL="2/s"

# UDP PPS limit (per IP)
# Recommended: 3000/s
UPL="3000/s"

# Color
BYellow="\033[1;33m"
BRed="\033[1;31m"
