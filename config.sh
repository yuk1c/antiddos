#################
# CONFIGURATION #
#################
#
# Binary routes.
IP="/sbin/iptables-nft"
IP6="/sbin/ip6tables-nft"
IPS="/sbin/ipset"
NFT="/sbin/nft"
SC="/sbin/sysctl"

# SSH Port.
# Ignore this if you don't use SSH.
# Default: 22 (ssh)
SSH="22"

# All ports of running webservers.
# Ignore this if you don't have them.
# Default: 80
HTTP="80"

# Connection limit
# Default: 100 connections
CL="100"

# Connection limit action
# Default: DROP
CLA="DROP"

# IP Block action
# Default: DROP
IBA="DROP"

# SYN PPS limit
# Default: 5/s
SPL="5/s"

# SYN-ACK PPS limit
# Default: 5/s
SAPL="5/s"

# RST PPS limit
# Default: 2/s
RPL="2/s"

# UDP PPS limit
# Default: 3000/s
UPL="3000/s"

# ICMP PPS limit
# Default: 2/s
IPL="2/s"

# Hashtable size (buckets)
# Default: 65536
HTS="65536"

# Hashtable max entries in the hash
# Default: 65536
HTM="65536"

# Hashtable expire (ms)
# Default: 5 minutes (300000 ms)
HTE="300000"

# MSS limit
# Default: 536:65535
MSS="536:65535"

# Packet state filter
# Default: INVALID
# Add "UNTRACKED" for additional protection. But this may cause problems!
ST="INVALID"

# Limited UDP source ports (against amplification
# Default: 19,53,123,111,123,137,389,1900,3702,5353
LUSP="19,53,123,111,123,137,389,1900,3702,5353"

# Invalid TCP Flag packet action
# Default: DROP
ITFPA="DROP"

# Outgoing port-unreach limit
# Default: 5/m
OPL="5/m"

# Outgoing TCP RST limit
# Default: 10/s
OTRL="10/s"

# Colors
BGray="\033[1;37m"
BRed="\033[1;31m"
