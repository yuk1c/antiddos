print_info() {
    # For printing gradient messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "ⓘ $1" | lolcat
        tput sgr0
	else
		echo -e "${BGray}ⓘ $1"
        tput sgr0
	fi
}

print_info2() {
    # For printing gray messages.
    echo -e "${BGray}ⓘ $1"
    tput sgr0
}

print_success() {
    # For printing gradient success messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "✓ $1" | lolcat
        tput sgr0
	else
		echo -e "${BGray}✓ $1"
        tput sgr0
	fi
}

print_warning() {
    # For printing gradient warning messages with auto-fallback.
    if command -v lolcat &>/dev/null; then
        echo -e "⚠︎ $1" | lolcat >&2
        tput sgr0
    else
        echo -e "${BGray}⚠︎ $1" >&2
        tput sgr0
    fi
}

print_error() {
    # For printing gradient error messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "✗ $1" | lolcat >&2
        tput sgr0
	else
		echo -e "${BRed}✗ $1" >&2
        tput sgr0
	fi
}

rootcheck() {
    if [[ $EUID -ne 0 ]]; then
        if [[ -n "${SUDO_USER:-}" ]]; then
            print_error "The script is already running with sudo privileges."
            tput sgr0
            exit 1
        fi

        if command -v sudo &> /dev/null; then
            print_info2 "This script must be run as root; Using 'sudo' for automatic elevation."
            tput sgr0
            sudo -E bash "$0" "$@"
            exit $?

        elif command -v su &> /dev/null; then
            print_info2 "This script must be run as root; Using 'su' for automatic elevation."
            tput sgr0
            script_path="$(readlink -f "$0")"
            su -c "$script_path" -- "${@}"
            exit $?

        else
            print_error "Neither sudo nor su were found. Exiting."
            tput sgr0
            exit 1
        fi
    fi
}

detect_interface() {
    local valid_prefixes="eno|eth|enp|wlo|wlan"
    local cache_file="$cache_dir/interface"

    # Check cache (valid for 1 day)
    if [[ -f "$cache_file" && $(find "$cache_file" -mtime -1) ]]; then
        interface=$(<"$cache_file")
        return
    fi

    interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E "^($valid_prefixes)" | sort | head -n 1)

    if [[ -z "$interface" ]]; then
        print_error "No valid network interface found. Expected prefix: eno/eth/enp/wlo/wlan"
        exit 1
    fi

    echo "$interface" > "$cache_file"
}

is_first_run() {
    local marker_file="$cache_dir/.first_run_done"

    if [[ ! -f "$marker_file" ]]; then
        return 0  # yes, first run
    fi

    return 1
}

check_for_updates() {

    is_first_run && {
        return
    }

    local cache_file="$cache_dir/updates"
    local cache_ttl_days=14
    local cache_ttl_sec=$((cache_ttl_days * 86400))
    local now_ts
    now_ts=$(date +%s)

    local should_check_updates=true

    # Cache TTL check.
    if [[ -f "$cache_file" ]]; then
        local last_check_ts
        last_check_ts=$(<"$cache_file")
        local age=$((now_ts - last_check_ts))

        if (( age < cache_ttl_sec )); then
            should_check_updates=false
        fi
    fi

    # Update check.
    if $should_check_updates; then
        if ! timeout 5 git fetch; then
            print_warning "Git fetch timed out or failed. Skipping update check..."
        else
            echo "$now_ts" > "$cache_file"

            local script_previous_ver
            script_previous_ver="$(git rev-parse HEAD)"

            if [ "$script_previous_ver" != "$(git rev-parse @"{u}")" ]; then
                local script_backup_timestamp
                script_backup_timestamp="$(date +%Y%m%d-%H%M%S)"
                local script_backup_path="$script_dir/backups/before-update-$script_backup_timestamp"

                rsync -a --exclude='backups/' "$script_dir/" "$script_backup_path/"

                if timeout 5 git pull; then
                    print_warning "Unable to update script. Skipping..."
                else
                    local script_new_ver
                    script_new_ver="$(git rev-parse HEAD)"
                    print_success "Auto-updated script: $script_previous_ver → $script_new_ver ($script_backup_timestamp)"
                    exec "$script_dir/$(basename "$0")" "$@"
                    exit 0
                fi
            fi
        fi
    fi
}

nftables_backup() {
    local now_str backup_base target_file total_backups recent_backups latest_backup

    now_str="$(date +%m-%d-%Y-%H%M%S)"
    backup_base="$script_dir/backups/nftables"
    target_file="$backup_base/nftables.conf-$now_str"

    mkdir -p "$backup_base"

    # Validate config before backup.
    if ! nft -c -f /etc/nftables.conf &>/dev/null; then
        return
    fi

    total_backups=$(find "$backup_base" -type f | wc -l)
    recent_backups=$(find "$backup_base" -type f -cmin -5 | wc -l)

    if (( recent_backups >= 5 )); then
        print_warning "Too many recent backups (≥5 in 5 min). Skipping."
        return
    fi

    if (( total_backups >= 20 )); then
        print_info2 "Cleaning up old backups..."
        find "$backup_base" -type f -printf "%T@ %p\n" | sort -n | head -n $((total_backups - 19)) | cut -d' ' -f2- | xargs rm -f
    fi

    latest_backup=$(find "$backup_base" -type f -printf "%T@ %p\n" | sort -nr | head -n 1 | cut -d' ' -f2-)
    if [[ -n "$latest_backup" && -f "$latest_backup" && $(cmp -s /etc/nftables.conf "$latest_backup"; echo $?) -eq 0 ]]; then
        return
    fi

    cp /etc/nftables.conf "$target_file"
}

check_distro() {
    local id version pretty_name kernel_version

    if command -v lsb_release &>/dev/null; then
        id=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
        version=$(lsb_release -rs)
        pretty_name=$(lsb_release -ds)
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        id=${ID,,}
        version=${VERSION_ID}
        pretty_name=${PRETTY_NAME}
    else
        print_error "Cannot determine the distribution. Aborting."
        exit 1
    fi

    kernel_version=$(uname -sr)

    print_info2 "Running on $pretty_name, kernel $kernel_version"

    case "$id" in
        ubuntu)
            if [[ $(echo "$version < 24.04" | bc) -eq 1 ]]; then
                print_warning "Ubuntu version $version is older than 24.04."
                read -rp "▶️ It is strongly recommended to upgrade. Continue anyway? [y/N]: " confirm
                [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
            fi
            ;;
        debian)
            print_warning "Debian is not officially supported by this script."
            read -rp "▶️ Continue anyway? [y/N]: " confirm
            [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
            ;;
        *)
            echo "❌ Unsupported distro: $id. Aborting."
            exit 1
            ;;
    esac
}

mark_first_run_complete() {
    touch "$cache_dir/.first_run_done"
}

check_dependencies() {
    local cache_file="$cache_dir/dependencies-present"
    local cache_ttl=600

    if [[ -f "$cache_file" && $(( $(date +%s) - $(stat -c %Y "$cache_file") )) -lt $cache_ttl ]]; then
        return
    fi

    local dependencies=("nftables" "git")
    local missing_dependencies=()

    for dep in "${dependencies[@]}"; do
        if ! dpkg -s "$dep" &>/dev/null; then
            missing_dependencies+=("$dep")
        fi
    done

    if [ "${#missing_dependencies[@]}" -gt 0 ]; then
        print_warning "The following dependencies are missing: ${missing_dependencies[*]}"

        if sudo -v >/dev/null 2>&1; then
            print_info2 "Do you want to install them with sudo? (y/n)"
            read -r install_response
            case "$install_response" in
                [yY])
                    sudo apt install -y "${missing_dependencies[@]}"
                    ;;
                [nN])
                    print_error "The script cannot continue without these dependencies. Exiting..."
                    exit 1
                    ;;
                *)
                    print_error "Invalid input. Please respond with 'y' or 'n'."
                    exit 1
                    ;;
            esac
        else
            print_error "Sudo is not available. Please install the missing dependencies manually:"
            for dep in "${missing_dependencies[@]}"; do
                echo "  - $dep"
            done
            exit 1
        fi
    fi

    touch "$cache_file"
}

check_network() {
    local test_host="1.1.1.1"
    local dns_host="1.1.1.1"
    local dns_port=53

    # Try ICMP ping.
    if ping -c 1 -W 1 "$test_host" >/dev/null 2>&1; then
        return 0
    fi

    # Try DNS over TCP.
    if timeout 2 bash -c "echo | nc -w 1 $dns_host $dns_port" >/dev/null 2>&1; then
        return 0
    fi

    return 1
}

smart_flush() {
    if ! "$nft" flush ruleset; then
        print_error "Failed to flush nftables ruleset."
        exit 1
    fi

    if ! check_flush; then
        print_error "Ruleset not emptied after flush. Manual intervention required."
        exit 1
    fi
}

rollback_nftables() {
    local backup_dir="$script_dir/backups/nftables"
    local latest_file

    # Check if backup directory exists.
    if [[ ! -d "$backup_dir" ]]; then
        print_error "Backup directory not found: $backup_dir"
        return 1
    fi

    # Find the latest backup file by timestamp.
    latest_file=$(ls -t "$backup_dir" | head -n 1)

    if [[ -z "$latest_file" || ! -f "$backup_dir/$latest_file" ]]; then
        print_error "No valid backup file found for rollback."
        return 1
    fi

    # Copy the latest backup to /etc/nftables.conf.
    if ! cp "$backup_dir/$latest_file" /etc/nftables.conf; then
        print_error "Failed to restore nftables.conf from backup."
        return 1
    fi

    smart_flush

    # Apply the restored nftables rules.
    if ! "$nft" -o -f /etc/nftables.conf >/dev/null; then
        print_error "Failed to apply restored nftables rules."
        return 1
    fi

    print_info2 "Rollback completed successfully."
    return 0
}

apply_nftables_safe() {
    nftables_backup
    local default_file="$script_dir/ruleset/10-main.nft"
    local user_file="$script_dir/ruleset/20-user.nft"
    local deploy_dir="/etc/yukiscript"
    local tmp_default="$deploy_dir/10-main.nft.unready"
    local tmp_user="$deploy_dir/20-user.nft.unready"
    local combined_file="/tmp/nft-combined-$$.nft"

    [[ ! -f "$default_file" ]] && print_error "Missing default ruleset: $default_file." && exit 1
    [[ ! -f "$user_file" ]] && print_error "Missing user ruleset: $user_file." && exit 1
    [[ -z "$interface" ]] && print_error "Interface variable is not set." && exit 1

    mkdir -p "$deploy_dir"

    # Get the SSH port.
    local ssh_port=22
    if [[ -f /etc/ssh/sshd_config ]]; then
        ssh_port=$(awk '/^\s*Port\s+[0-9]+/ { print $2 }' /etc/ssh/sshd_config | head -n1)
        ssh_port=${ssh_port:-22}
    fi
    ssh_port=${ssh_port:-22}

    sed "s/__IFACE__/${interface}/g" "$default_file" > "$tmp_default"
    sed "s/__SSHPORT__/${ssh_port}/g" "$user_file" > "$tmp_user"

cat > "$combined_file" <<EOF
table inet yuki {
EOF

    cat "$tmp_default" >> "$combined_file"
    echo -e "\n\t" >> "$combined_file"
    cat "$tmp_user" >> "$combined_file"

    echo "}" >> "$combined_file"

    # Debugging
    #cat "$combined_file" > 1.txt

    if ! "$nft" -c -f "$combined_file"; then
        print_error "Syntax check failed for combined nftables rules (from .unready files)."
        rm -f "$tmp_default" "$tmp_user" "$combined_file"
        exit 1
    fi

    smart_flush

    if ! "$nft" -f "$combined_file"; then
        print_error "Failed to apply combined nftables ruleset."
        rollback_nftables
        rm -f "$tmp_default" "$tmp_user" "$combined_file"
        exit 1
    fi

    mv -f "$tmp_default" "${tmp_default%.unready}"
    mv -f "$tmp_user" "${tmp_user%.unready}"

    echo "include \"/etc/$deploy_dir/*.nft\"" > /etc/nftables.conf

    cat > /etc/nftables.conf <<EOF

table inet yuki {
    include "$deploy_dir/*.nft"
}
EOF

    if ! "$nft" list ruleset | grep -q "chain user-ruleset"; then
        print_error "User-ruleset chain is missing in nftables ruleset."
        rollback_nftables
        exit 1
    fi

    if ! check_network; then
        print_warning "Connectivity lost after applying rules. Attempting rollback..."
        rollback_nftables || {
            print_error "Rollback failed. Manual intervention required."
            exit 1
        }
    fi

    rm -f "$combined_file"
}

check_flush() {
    # Check that the ruleset is actually empty after flush.
    if [[ -n "$("$nft" list ruleset)" ]]; then
        print_error "Failed to flush nftables rules. Ruleset is not empty."
        return 1
    fi
    return 0
}

flush_ruleset_handler() {
    print_error "Unable to clear nftables ruleset. Flushing did not work properly.\nYou can try updating your kernel or removing possibly conflicting services."
    exit 1
}

apply_sysctl() {
    local src="$script_dir/sysctl.conf"
    local dst="/etc/sysctl.d/99-yuki.conf"
    local hash_file="$cache_dir/.sysctl.hash"

    [[ ! -f "$src" ]] && print_error "Missing sysctl file: $src" && exit 1

    local hash_now hash_old=""
    hash_now=$(md5sum "$src" | cut -d' ' -f1)
    [[ -f "$hash_file" ]] && hash_old=$(< "$hash_file")

    if [[ "$hash_now" != "$hash_old" || ! -f "$dst" ]]; then
        cp "$src" "$dst"
        eval "$sc_reload" "$dst" > /dev/null
        echo "$hash_now" > "$hash_file"
    fi
}

enable_nftables_persistence() {
    systemctl enable --now nftables > /dev/null
}

track_phase() {
    local name="$1"
    shift
    local start_time=$(date +%s%3N)
    "$@"
    local end_time=$(date +%s%3N)
    local duration=$((end_time - start_time))

    phase_names+=("$name")
    phase_durations+=("$duration")
}

print_phase_stats() {
    local total=$1
    echo -e "\n\033[1mStage Timings:\033[0m"
    for i in "${!phase_names[@]}"; do
        local name="${phase_names[$i]}"
        local dur="${phase_durations[$i]}"
        local pct=$(awk "BEGIN { printf \"%.1f\", (${dur}/${total})*100 }")
        printf "  • %-30s %5d ms (%5s%%)\n" "$name" "$dur" "$pct"
    done
}
