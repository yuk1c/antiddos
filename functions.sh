print_default() {
    # For printing gradient messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "$1" | lolcat
	else
		echo -e "${BGray}$1"
	fi
}

print_default2() {
    # For printing gray messages.
    echo -e "${BGray}$1"
}

print_success() {
    # For printing gradient success messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "✓ Success. $1" | lolcat
	else
		echo -e "${BGray}✓ Success. $1"
	fi
}

print_warning() {
    # For printing gradient warning messages with auto-fallback.
    if command -v lolcat &>/dev/null; then
        echo -e "⚠︎ Warning: $1" | lolcat >&2
    else
        echo -e "${BGray}⚠︎ Warning: $1" >&2
    fi
}

print_error() {
    # For printing gradient error messages with auto-fallback.
	if command -v lolcat &>/dev/null; then
		echo -e "✗ Error. $1" | lolcat >&2
	else
		echo -e "${BRed}✗ Fail. $1" >&2
	fi
}

rootcheck() {
    if [[ $EUID -ne 0 ]]; then
        print_warning "This script must be run as root. Restarting with sudo/su..."

        if command -v sudo &> /dev/null; then
            print_default2 "Automatic choice: 'sudo' was selected and will be used."
            # shellcheck disable=SC2128
            sudo -E "$SHELL" "$BASH_SOURCE" "$@"
            exit $?
        elif command -v su &> /dev/null; then
            print_default2 "Automatic choice: 'su' was selected and will be used."
            # shellcheck disable=SC2128
            script_path="$(readlink -f "$BASH_SOURCE")"
            su -c "$script_path" "$@"
            exit $?
        else
            print_error "Automatic choice failed: neither sudo nor su was found. Exiting."
            exit 1
        fi
    fi
}

accidental_start_prevention() {
    print_default "Accidental start prevention: press 'enter' within 5 seconds to continue, CTRL+C to cancel."

    for _ in {1..5}; do
        stty -echo
        if read -rt 5 -N 1 key; then
            stty echo
            case $key in
                $'\n') print_default2 "Starting the script..." && return 0 ;;
                $'\x03') print_default2 "Ctrl+C detected. Exiting..." && exit 130 ;;
                *) print_error "Invalid input. Try again." ;;
            esac
        else
            stty echo
            print_default2 "No input detected in 5 seconds. Exiting..." && exit 1
        fi
    done

    print_warning "Maximum attempts reached. Exiting..." && exit 1
}

cleanup() {
    print_default "Received CTRL+C. Exiting..."
    tput sgr0
    exit 130
}