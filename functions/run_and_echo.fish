function run_and_echo
    set -l quiet_mode false
    set -l check_status false
    set -l command_args

    for arg in $argv
        switch $arg
            case '--quiet' '-q'
                set quiet_mode true
            case '--check-status' '-c'
                set check_status true
            case '*'
                set command_args $command_args $arg
        end
    end

    if not $quiet_mode
        echo $command_args
    end

    eval $command_args
    set -l exit_code $status

    if $check_status; and test $exit_code -ne 0
        echo "Command failed with exit code: $exit_code" >&2
        return $exit_code
    end

    return $exit_code
end