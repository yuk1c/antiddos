#################
# CONFIGURATION #
#################

# Binary routes.
IP="/sbin/iptables-nft"
IP6="/sbin/ip6tables-nft"
nft="/sbin/nft"
SC="/sbin/sysctl"

# For working with sysctl.conf
sysctl_conf="/etc/sysctl.conf"
backup_dir="/etc/sysctl_backups"
num_backups=$(find "$backup_dir" -maxdepth 1 -type f | wc -l)
max_backups=5
timestamp=$(date "+%Y%m%d%H%M%S")
backup_file="$backup_dir/sysctl.conf_$timestamp"

# SSH server Port.
# Ignore this if you don't use/don't have an SSH server.
# Default: 22 (ssh)
SSH="22"

# All ports of running webservers.
# Ignore this if you don't have them.
# If you wanna add a port, it should look like "80,443,8080".
# Default: 80
HTTP="80"

# Connection limit
# Default: 50 connections
CL="50"

# Connection limit action
# Default: DROP
CLA="drop"

# SYN PPS limit
# Default: 5/second
SPL="5/second"

# SYN-ACK PPS limit
# Default: 5/second
SAPL="5/second"

# RST PPS limit
# Default: 2/second
RPL="2/second"

# UDP PPS limit
# Default: 3000/second
UPL="3000/second"

# ICMP PPS limit
# Default: 2/second
IPL="2/second"

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
ST="invalid,untracked"

# Limited UDP source ports (against amplification)
LUSP="19, 53, 111, 123, 137, 389, 1900, 3702, 5353"

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
