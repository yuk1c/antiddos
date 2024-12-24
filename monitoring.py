import subprocess
import time
import re
import os

RESET = "\033[0m"
BOLD = "\033[1m"
RED = "\033[38;5;203m"
GREEN = "\033[38;5;114m"
BLUE = "\033[38;5;68m"
MAGENTA = "\033[38;5;139m"
CYAN = "\033[38;5;72m"
YELLOW = "\033[38;5;179m"
WHITE_TEXT_ON_DARK_GRAY_BG = "\033[37m\033[48;5;235m"

def parse_nft_output(output):
    total_bytes = 0
    total_packets = 0
    blocked_bytes = 0
    blocked_packets = 0
    allowed_bytes = 0
    allowed_packets = 0

    byte_match = re.compile(r"packets (\d+) bytes (\d+)")

    for line in output.splitlines():
        match = byte_match.search(line)
        if match:
            packets_count = int(match.group(1))
            bytes_count = int(match.group(2))

            if "drop" in line:
                blocked_bytes += bytes_count
                blocked_packets += packets_count
            elif "accept" in line:
                allowed_bytes += bytes_count
                allowed_packets += packets_count

    total_bytes = blocked_bytes + allowed_bytes
    total_packets = blocked_packets + allowed_packets

    return total_bytes, total_packets, blocked_bytes, blocked_packets, allowed_bytes, allowed_packets

def calculate_speed(new_bytes, old_bytes, elapsed_time):
    return (new_bytes - old_bytes) * 8 / 1024 / elapsed_time

def calculate_pps(new_packets, old_packets, elapsed_time):
    return (new_packets - old_packets) / elapsed_time

def parse_netstat_tcp_udp(output):
    tcp_data = {}
    udp_data = {}
    
    tcp_regex = re.compile(r"Tcp:\s*\n\s*(\d+) active connection openings\n\s*(\d+) passive connection openings\n\s*(\d+) failed connection attempts\n\s*(\d+) connection resets received\n\s*(\d+) connections established\n\s*(\d+) segments received\n\s*(\d+) segments sent out\n\s*(\d+) segments retransmitted\n\s*(\d+) bad segments received\n\s*(\d+) resets sent")
    udp_regex = re.compile(r"Udp:\s*\n\s*(\d+) packets received\n\s*(\d+) packets to unknown port received\n\s*(\d+) packet receive errors\n\s*(\d+) packets sent\n\s*(\d+) receive buffer errors\n\s*(\d+) send buffer errors\n\s*IgnoredMulti: (\d+)")

    tcp_match = tcp_regex.search(output)
    udp_match = udp_regex.search(output)

    if tcp_match:
        tcp_data = {
            'connections_established': int(tcp_match.group(5)),
            'segments_received': int(tcp_match.group(6)),
            'segments_sent_out': int(tcp_match.group(7)),
            'segments_retransmitted': int(tcp_match.group(8)),
        }

    if udp_match:
        udp_data = {
            'packets_received': int(udp_match.group(1)),
            'packets_sent': int(udp_match.group(4)),
        }

    return tcp_data, udp_data

def display_stats(nft_stats, netstat_tcp_diff, netstat_udp_diff, averages):
    total_speed_kbps, blocked_speed_kbps, allowed_speed_kbps, blocked_pps, allowed_pps = nft_stats
    blocked_bytes, allowed_bytes = netstat_tcp_diff.get('blocked_bytes', 0), netstat_tcp_diff.get('allowed_bytes', 0)
    total_bytes = blocked_bytes + allowed_bytes

    blocked_percent = (blocked_speed_kbps / total_speed_kbps * 100) if total_speed_kbps > 0 else 0
    allowed_percent = (allowed_speed_kbps / total_speed_kbps * 100) if total_speed_kbps > 0 else 0

    avg_blocked_speed = averages['blocked_speed_kbps']
    avg_allowed_speed = averages['allowed_speed_kbps']
    avg_blocked_pps = averages['blocked_pps']
    avg_allowed_pps = averages['allowed_pps']

    avg_blocked_percent = (avg_blocked_speed / (avg_blocked_speed + avg_allowed_speed) * 100) if (avg_blocked_speed + avg_allowed_speed) > 0 else 0
    avg_allowed_percent = (avg_allowed_speed / (avg_blocked_speed + avg_allowed_speed) * 100) if (avg_blocked_speed + avg_allowed_speed) > 0 else 0

    clear_console()

    print(f"{RESET}{BOLD}{WHITE_TEXT_ON_DARK_GRAY_BG}--- Yuki's AntiDDoS Network Monitor ---{RESET}")
    print(f"{BOLD}{YELLOW}Total:{RESET} {total_speed_kbps:.2f} kbps")
    print(f"{BOLD}{RED}Blocked:{RESET} {blocked_speed_kbps:.2f} kbps, {blocked_pps:.2f} pps ({blocked_percent:.2f}%)")
    print(f"{BOLD}{GREEN}Allowed:{RESET} {allowed_speed_kbps:.2f} kbps, {allowed_pps:.2f} pps ({allowed_percent:.2f}%)\n")

    print(f"{BOLD}{WHITE_TEXT_ON_DARK_GRAY_BG}~ Averages ~ {RESET}")
    print(f"{BOLD}{RED}Blocked:{RESET} {avg_blocked_speed:.2f} kbps, {avg_blocked_pps:.2f} pps ({avg_blocked_percent:.2f}%)")
    print(f"{BOLD}{GREEN}Allowed:{RESET} {avg_allowed_speed:.2f} kbps, {avg_allowed_pps:.2f} pps ({avg_allowed_percent:.2f}%)\n")

    print(f"{BOLD}{WHITE_TEXT_ON_DARK_GRAY_BG}TCP Netstat (per second):{RESET}")
    for key, value in netstat_tcp_diff.items():
        print(f"{BOLD}{YELLOW}{key.replace('_', ' ').title()}:{RESET} {value}")

    print(f"\n{BOLD}{WHITE_TEXT_ON_DARK_GRAY_BG}UDP Netstat (per second):{RESET}")
    for key, value in netstat_udp_diff.items():
        print(f"{BOLD}{YELLOW}{key.replace('_', ' ').title()}:{RESET} {value}")

def clear_console():
    os.system('cls' if os.name == 'nt' else 'clear')

def calculate_diff(new_data, old_data):
    diff_data = {}
    for key in new_data:
        diff_data[key] = new_data[key] - old_data.get(key, 0)
    return diff_data

def main():
    old_nft_data = (0, 0, 0, 0, 0, 0)
    old_tcp_data = {}
    old_udp_data = {}

    total_speed_sum = 0
    blocked_speed_sum = 0
    allowed_speed_sum = 0
    blocked_pps_sum = 0
    allowed_pps_sum = 0
    count = 0

    while True:
        nft_output = subprocess.getoutput("nft list ruleset")
        netstat_output = subprocess.getoutput("netstat -s")

        total_bytes, total_packets, blocked_bytes, blocked_packets, allowed_bytes, allowed_packets = parse_nft_output(nft_output)

        elapsed_time = 1

        total_speed_kbps = calculate_speed(total_bytes, old_nft_data[0], elapsed_time)
        blocked_speed_kbps = calculate_speed(blocked_bytes, old_nft_data[2], elapsed_time)
        allowed_speed_kbps = calculate_speed(allowed_bytes, old_nft_data[4], elapsed_time)

        blocked_pps = calculate_pps(blocked_packets, old_nft_data[3], elapsed_time)
        allowed_pps = calculate_pps(allowed_packets, old_nft_data[5], elapsed_time)

        tcp_data, udp_data = parse_netstat_tcp_udp(netstat_output)

        if old_tcp_data:
            tcp_diff = calculate_diff(tcp_data, old_tcp_data)
            udp_diff = calculate_diff(udp_data, old_udp_data)

            total_speed_sum += total_speed_kbps
            blocked_speed_sum += blocked_speed_kbps
            allowed_speed_sum += allowed_speed_kbps
            blocked_pps_sum += blocked_pps
            allowed_pps_sum += allowed_pps
            count += 1

            averages = {
                'total_speed_kbps': total_speed_sum / count,
                'blocked_speed_kbps': blocked_speed_sum / count,
                'allowed_speed_kbps': allowed_speed_sum / count,
                'blocked_pps': blocked_pps_sum / count,
                'allowed_pps': allowed_pps_sum / count
            }

            display_stats((total_speed_kbps, blocked_speed_kbps, allowed_speed_kbps, blocked_pps, allowed_pps), tcp_diff, udp_diff, averages)

        old_nft_data = (total_bytes, total_packets, blocked_bytes, blocked_packets, allowed_bytes, allowed_packets)
        old_tcp_data = tcp_data
        old_udp_data = udp_data

        time.sleep(1)

if __name__ == "__main__":
    main()
