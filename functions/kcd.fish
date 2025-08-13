function kcd -d "Change Kubernetes namespace"
    set -l options h/help l/list c/current d/dry-run
    argparse $options -- $argv
    or return 1

    if set -q _flag_help
        _kcd_help
        return 0
    end

    # Check if kubectl is available
    if not command -q kubectl
        echo "kcd: kubectl not found in PATH" >&2
        return 1
    end

    # Show current namespace
    if set -q _flag_current
        set -l current_ns (_kcd_get_current_namespace)
        if test -n "$current_ns"
            echo "$current_ns"
        else
            echo "default"
        end
        return 0
    end

    # List available namespaces
    if set -q _flag_list
        echo "Available namespaces:"
        kubectl get namespaces -o name 2>/dev/null | sed 's/namespace\///' | sort
        return $status
    end

    # Validate arguments
    if test (count $argv) -eq 0
        echo "kcd: missing namespace name" >&2
        echo "Try 'kcd --help' for more information." >&2
        return 1
    end

    if test (count $argv) -gt 1
        echo "kcd: too many arguments" >&2
        echo "Try 'kcd --help' for more information." >&2
        return 1
    end

    set -l namespace $argv[1]

    # Validate namespace exists
    if not _kcd_namespace_exists $namespace
        echo "kcd: namespace '$namespace' not found" >&2
        echo "Use 'kcd --list' to see available namespaces." >&2
        return 1
    end

    # Get current context
    set -l current_context (kubectl config current-context 2>/dev/null)
    if test $status -ne 0
        echo "kcd: failed to get current context" >&2
        return 1
    end

    # Dry run mode
    if set -q _flag_dry_run
        echo "Would set namespace to '$namespace' in context '$current_context'"
        echo "Command: kubectl config set-context $current_context --namespace=$namespace"
        return 0
    end

    # Set the namespace
    if kubectl config set-context $current_context --namespace=$namespace >/dev/null 2>&1
        echo "Namespace changed to '$namespace'"
        return 0
    else
        echo "kcd: failed to change namespace to '$namespace'" >&2
        return 1
    end
end

function _kcd_help
    echo "kcd - Change Kubernetes namespace"
    echo
    echo "USAGE:"
    echo "    kcd [OPTIONS] <namespace>"
    echo
    echo "OPTIONS:"
    echo "    -h, --help      Show this help message"
    echo "    -l, --list      List available namespaces"
    echo "    -c, --current   Show current namespace"
    echo "    -d, --dry-run   Preview the change without applying it"
    echo
    echo "EXAMPLES:"
    echo "    kcd production           # Switch to production namespace"
    echo "    kcd --list              # List all namespaces"
    echo "    kcd --current           # Show current namespace"
    echo "    kcd --dry-run staging   # Preview switching to staging"
    echo
    echo "REQUIREMENTS:"
    echo "    - kubectl must be installed and configured"
    echo "    - Valid Kubernetes context must be set"
end

function _kcd_get_current_namespace
    kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null
end

function _kcd_namespace_exists
    set -l namespace $argv[1]
    kubectl get namespace $namespace >/dev/null 2>&1
end