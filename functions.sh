. ./config.sh

mitigate_tcp_flood () {
"$IP" -t raw -a prerouting -p tcp \
$1 --match hashlimit --hashlimit-above \
$2 --hashlimit-mode srcip \
--hashlimit-burst $3 \
--hashlimit-name $4 \
-m comment --comment $5 -j drop
}

mitigate_udp_flood () {
"$IP" -t raw -a PREROUTING -p udp \
$1 \
-m comment --comment $2 -j drop $3
}

icmp_block () {
"$IP" -t raw -A PREROUTING -p icmp \
--icmp-type $1 \
$2 \
-j $3
}

tcp_filter () {
"$IP" -t raw -A PREROUTING -p tcp \
--tcp-flags $1 \
-m comment --comment "INVALID TCP FLAGS" -j DROP

}
