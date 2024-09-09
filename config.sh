#################
# CONFIGURATION #
#################

# Binary routes.
nft="/sbin/nft"
IP="/sbin/iptables-nft"
IP6="/sbin/ip6tables-nft"
sc_reload="/sbin/sysctl -p"

# For working with sysctl.conf
sysctl_conf="/etc/sysctl.conf"
backup_dir="/etc/sysctl_backups"
num_backups=$(find "$backup_dir" -maxdepth 1 -type f | wc -l)
max_backups=5
timestamp=$(date "+%Y%m%d%H%M%S")
backup_file="$backup_dir/sysctl.conf_$timestamp"

# SSH server port. (TCP only)
# You can comment it if you don't have SSH.
# Default: 22 (ssh)
SSH="22"
# SSH="2222" # For port 2222 (commonly used)

# All ports of running webservers.
# Ignore this if you don't have them.
# If you wanna add a port, it should look like "80,443,8080".
# Default: 80 (http)
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

# Packet state filter
ST="invalid, untracked"

# Limited UDP source ports (against amplification)
LUSP="19, 53, 111, 123, 137, 389, 1900, 3702, 5353"

# Colors
BGray="\033[1;37m"
BRed="\033[1;31m"