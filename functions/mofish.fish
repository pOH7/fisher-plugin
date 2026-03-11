function mofish -d "Mosh with Fish shell on remote servers"
    set -l options \
        a \
        n \
        o \
        4 \
        6 \
        help \
        version \
        client= \
        server= \
        predict= \
        p/port= \
        family= \
        bind-server= \
        ssh= \
        experimental-remote-ip=

    argparse --name=mofish --strict-longopts --move-unknown --unknown-arguments=none $options -- $argv
    or return 1

    if set -q _flag_help; or set -q _flag_version
        command mosh $argv_opts $argv
        return $status
    end

    if test (count $argv) -eq 0
        echo "mofish: missing destination" >&2
        echo "Try 'mofish --help' for more information." >&2
        return 1
    end

    if test (count $argv) -gt 1
        echo "mofish: remote commands are not supported" >&2
        echo "Pass only a destination host. Use 'mosh' directly for custom remote commands." >&2
        return 1
    end

    set -l destination $argv[1]
    set -l remote_script 'if command -v fish >/dev/null 2>&1; then exec fish -li; else exec "${SHELL:-/bin/sh}" -li; fi'

    command mosh $argv_opts -- $destination sh -lc $remote_script
end
