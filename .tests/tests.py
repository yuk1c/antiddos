#!/usr/bin/env python3

import os
import subprocess
import sys
import time
import socket
from datetime import datetime
from scapy.all import IP, TCP, sr1, conf

# -----------------------------
# Config
# -----------------------------
REQUIRED_FILES = [
    "antiddos-yuki",
    "user-rules.nft",
    "default-rules.nft",
    "script.conf",
    "sysctl.conf",
    "functions.sh",
]

NFTABLES_CONF = "/etc/nftables.conf"
SYSCTL_CONF = "/etc/sysctl.d/99-yuki.conf"

SYN_TEST_IP = "127.0.0.1"
SYN_TEST_PORT = 22
SYN_RATE_PPS = 4
SYN_DURATION = 3  # seconds

# -----------------------------
# Utils
# -----------------------------
def check_exists_and_nonempty(file_path):
    print(f"🔍 Checking {file_path}...")
    if not os.path.isfile(file_path):
        sys.exit(f"❌ {file_path} does not exist")
    print("✅ File exists")
    if os.path.getsize(file_path) == 0:
        sys.exit(f"❌ {file_path} is empty")
    print("✅ File not empty")
    with open(file_path, 'rb') as f:
        if b'\r\n' in f.read():
            sys.exit(f"❌ {file_path} uses CRLF line endings")
    print("✅ File uses LF line endings")
    with open(file_path, 'r', errors='ignore') as f:
        if 'TODO: ' in f.read():
            sys.exit(f"❌ {file_path} contains TODO comments")
    print("✅ No TODOs in file")


def check_network():
    def run(name, cmd):
        print(f"🔌 {name}: ", end="")
        start = time.time()
        result = subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if result.returncode != 0:
            sys.exit("❌ failed")
        print(f"✅ success in {int((time.time() - start)*1000)}ms")

    run("Ping 1.1.1.1", "ping -c1 1.1.1.1")
    run("Ping google.com", "ping -c1 google.com")
    run("Curl Google", "curl -s https://google.com")
    run("DNS resolve", "getent hosts example.com")
    run("APT update", "apt update -qq")


def run_antiddos():
    print("🚀 Running antiddos-yuki...")
    subprocess.run(["sudo", "bash", "antiddos-yuki"], check=True)


def validate_ruleset():
    print("🧾 Checking ruleset...")
    output = subprocess.check_output(["sudo", "nft", "list", "ruleset"], text=True)
    required_patterns = [
        "goto user-ruleset",
        "chain user-ruleset",
        "ct state new tcp dport 22",
        "chain prerouting {",
        "chain ingress {",
        "table inet yuki {",
    ]
    for pattern in required_patterns:
        if pattern not in output:
            sys.exit(f"❌ Missing '{pattern}'")
        print(f"✅ Found '{pattern}'")

def systemd_nftables_check():
    print("🔧 Verifying systemd starts nftables without errors...")
    result = subprocess.run(["sudo", "systemctl", "start", "nftables"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print(result.stderr.decode())
        sys.exit("❌ systemctl failed to start nftables")
    print("✅ nftables started successfully via systemd")


# -----------------------------
# Main
# -----------------------------
def main():
    os.chdir("..")
    print("📦 Starting tests...")

    for file in REQUIRED_FILES:
        check_exists_and_nonempty(file)

    run_antiddos()
    check_exists_and_nonempty(NFTABLES_CONF)
    validate_ruleset()
    check_network()
    check_exists_and_nonempty(SYSCTL_CONF)
    run_antiddos()
    systemd_nftables_check()

    print("🎉 All tests passed!")


if __name__ == "__main__":
    main()
