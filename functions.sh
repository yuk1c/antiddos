check_argument() {
    if [ -z "$1" ]; then
        echo "Error: Missing argument." >&2
        return 1
    fi
}

print_info() {
    check_argument "$1" || return 1
    # For printing gradient messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "$1" | lolcat
        tput sgr0
	else
		echo -e "${BGray}$1"
        tput sgr0
	fi
}

print_info2() {
    # For printing gray messages.
    echo -e "${BGray}$1"
    tput sgr0
}

print_success() {
    check_argument "$1" || return 1
    # For printing gradient success messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "✓ Success. $1" | lolcat
        tput sgr0
	else
		echo -e "${BGray}✓ Success. $1"
        tput sgr0
	fi
}

print_warning() {
    check_argument "$1" || return 1
    # For printing gradient warning messages with auto-fallback.
    if command -v lolcat &>/dev/null; then
        echo -e "⚠︎ Warning: $1" | lolcat >&2
        tput sgr0
    else
        echo -e "${BGray}⚠︎ Warning: $1" >&2
        tput sgr0
    fi
}

print_error() {
    check_argument "$1" || return 1
    # For printing gradient error messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "✗ Error. $1" | lolcat >&2
        tput sgr0
	else
		echo -e "${BRed}✗ Fail. $1" >&2
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
            print_warning "This script must be run as root; Using 'sudo' for automatic elevation."
            tput sgr0
            sudo -E bash "$0" "$@"
            exit $?

        elif command -v su &> /dev/null; then
            print_warning "This script must be run as root; Using 'su' for automatic elevation."
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
    local now_str backup_base target_file latest_file total_backups recent_backups cache_file

    now_str="$(date +%m-%d-%Y-%H%M%S)"
    backup_base="$script_dir/backups/nftables"
    target_file="$backup_base/nftables.conf-$now_str"
    cache_file="$cache_dir/nftables-backup"

    # Make the backup dir, if it doesn't exist.
    mkdir -p "$backup_base"

    # Use the cached information if it exists.
    if [[ -f "$cache_file" ]]; then
        source "$cache_file"
    else
        latest_file=$(find "$backup_base" -type f -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)
        total_backups=$(find "$backup_base" -type f | wc -l)
        recent_backups=$(find "$backup_base" -type f -cmin -5 | wc -l)

        # Cache the info we've just calculated:
        echo "latest_file='$latest_file'" > "$cache_file"
        echo "total_backups=$total_backups" >> "$cache_file"
        echo "recent_backups=$recent_backups" >> "$cache_file"
    fi

    # If the last file and the current config are the same, skip.
    if [[ -n "$latest_file" && -f "$backup_base/$latest_file" && -f /etc/nftables.conf && $(cmp -s /etc/nftables.conf "$backup_base/$latest_file"; echo $?) -eq 0 ]]; then
        return
    fi

    # If there're more than 20 backups, delete the oldest one.
    if (( total_backups >= 20 )); then
        find "$backup_base" -type f -printf "%T@ %p\n" | sort -n | head -n $((total_backups - 19)) | cut -d' ' -f2- | xargs rm -f
    fi

    # Don't make a backup if there were 5 or more backups created in the past 5 minutes.
    if (( recent_backups >= 5 )); then
        return
    fi

    # Copy our config to the new file.
    cp /etc/nftables.conf "$target_file"

    # Update the cache.
    echo "latest_file='$target_file'" > "$cache_file"
    echo "total_backups=$((total_backups + 1))" >> "$cache_file"
    echo "recent_backups=1" >> "$cache_file"
}

check_distro() {
    local cache_file="$cache_dir/distro"

    if [[ -f "$cache_file" ]]; then
        distro=$(< "$cache_file")
    else
        if command -v lsb_release > /dev/null 2>&1; then
            distro=$(lsb_release -is)
        elif [ -e /etc/os-release ]; then
            distro=$(awk -F= '/^ID=/{print tolower($2)}' /etc/os-release)
        else
            print_error "Failed to determine the distribution. Use --skip-distro-check to override."
            exit 1
        fi
        echo "$distro" > "$cache_file"
    fi

    case "$distro" in
        "Ubuntu" | "Debian")
            ;;
        *)
            print_error "Unsupported distro: $distro. Use --skip-distro-check to override."
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

apply_nftables() {
    local default_file="$script_dir/default-rules.nft"
    local user_file="$script_dir/user-rules.nft"
    local default_hash_file="$cache_dir/.nft-default.hash"
    local user_hash_file="$cache_dir/.nft-user.hash"
    local tmp_rules
    tmp_rules=$(mktemp /tmp/default-rules-XXXXXX.nft)

    # Check if default and user ruleset files exist.
    [[ ! -f "$default_file" ]] && print_error "Missing default ruleset: $default_file" && exit 1
    [[ ! -f "$user_file" ]] && print_error "Missing user ruleset: $user_file" && exit 1
    [[ -z "$interface" ]] && print_error "Interface variable is not set." && exit 1

    local default_hash_now user_hash_now default_hash_cached user_hash_cached
    default_hash_now=$(md5sum "$default_file" | cut -d' ' -f1)
    user_hash_now=$(md5sum "$user_file" | cut -d' ' -f1)
    [[ -f "$default_hash_file" ]] && default_hash_cached=$(< "$default_hash_file")
    [[ -f "$user_hash_file" ]] && user_hash_cached=$(< "$user_hash_file")

    # Apply default rules if the hash has changed.
    if [[ "$default_hash_now" != "$default_hash_cached" ]]; then
        # Replace __IFACE__ with the actual interface name in default rules.
        sed "s/__IFACE__/${interface}/g" "$default_file" > "$tmp_rules"
        if ! "$nft" -o -f "$tmp_rules"; then
            print_error "Failed to apply default nftables rules."
            rm -f "$tmp_rules"
            exit 1
        fi
        # Update the hash of the default rules and store it.
        echo "$default_hash_now" > "$default_hash_file"
    fi
    rm -f "$tmp_rules"

    # Apply user rules if the hash has changed.
    if [[ "$user_hash_now" != "$user_hash_cached" ]]; then
        if ! "$nft" -o -f "$user_file"; then
            print_error "Failed to apply user nftables rules."
            exit 1
        fi
        # Update the hash of the user rules and store it.
        echo "$user_hash_now" > "$user_hash_file"
    fi

    # Save the current nftables configuration.
    "$nft" -o list ruleset | tee /etc/nftables.conf >/dev/null
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
        eval "$sc_reload" "$dst" >/dev/null
        echo "$hash_now" > "$hash_file"
    fi
}

enable_nftables_persistence() {
    systemctl enable --now nftables > /dev/null &
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
        printf "  • %-25s %5d ms (%5s%%)\n" "$name" "$dur" "$pct"
    done
}