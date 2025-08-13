function fissh -d "SSH with Fish shell on remote servers"
    set -l options h/help v/verbose n/no-fish s/shell=
    argparse $options -- $argv
    or return 1

    if set -q _flag_help
        _fissh_help
        return 0
    end

    if test (count $argv) -eq 0
        echo "fissh: missing destination" >&2
        echo "Try 'fissh --help' for more information." >&2
        return 1
    end

    set -l shell_command
    if set -q _flag_no_fish
        # Force use of default shell
        set shell_command "exec \$SHELL -li"
    else if set -q _flag_shell
        # Use specified shell
        set shell_command "if which $_flag_shell >/dev/null 2>&1; then exec $_flag_shell -li; else exec \$SHELL -li; fi"
    else
        # Default behavior: try fish, fallback to default shell
        set shell_command "if which fish >/dev/null 2>&1; then exec fish -li; else exec \$SHELL -li; fi"
    end

    if set -q _flag_verbose
        echo "fissh: connecting with shell detection enabled" >&2
    end

    # Execute SSH with proper shell command
    ssh $argv -t "\$SHELL -lc '$shell_command'"
end

function _fissh_help
    echo "fissh - SSH with Fish shell on remote servers"
    echo
    echo "USAGE:"
    echo "    fissh [OPTIONS] [SSH_OPTIONS] destination"
    echo
    echo "OPTIONS:"
    echo "    -h, --help      Show this help message"
    echo "    -v, --verbose   Show verbose output"
    echo "    -n, --no-fish   Don't try to use fish, use default shell"
    echo "    -s, --shell=SHELL  Try to use specified shell instead of fish"
    echo
    echo "EXAMPLES:"
    echo "    fissh user@example.com"
    echo "    fissh -p 2222 user@example.com"
    echo "    fissh --verbose user@example.com"
    echo "    fissh --shell=zsh user@example.com"
    echo "    fissh --no-fish user@example.com"
    echo
    echo "The command automatically detects if Fish shell is available on the"
    echo "remote server and uses it. Falls back to the default shell if not available."
end