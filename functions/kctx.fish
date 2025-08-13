function kctx -d "Change Kubernetes context"
    set -l options h/help l/list c/current d/dry-run n/namespace=
    argparse $options -- $argv
    or return 1

    if set -q _flag_help
        _kctx_help
        return 0
    end

    # Check if kubectl is available
    if not command -q kubectl
        echo "kctx: kubectl not found in PATH" >&2
        return 1
    end

    # Show current context
    if set -q _flag_current
        set -l current_ctx (kubectl config current-context 2>/dev/null)
        if test $status -eq 0
            echo "$current_ctx"
        else
            echo "kctx: no current context set" >&2
            return 1
        end
        return 0
    end

    # List available contexts
    if set -q _flag_list
        echo "Available contexts:"
        kubectl config get-contexts -o name 2>/dev/null | sort
        return $status
    end

    # Validate arguments
    if test (count $argv) -eq 0
        echo "kctx: missing context name" >&2
        echo "Try 'kctx --help' for more information." >&2
        return 1
    end

    if test (count $argv) -gt 1
        echo "kctx: too many arguments" >&2
        echo "Try 'kctx --help' for more information." >&2
        return 1
    end

    set -l context $argv[1]

    # Validate context exists
    if not _kctx_context_exists $context
        echo "kctx: context '$context' not found" >&2
        echo "Use 'kctx --list' to see available contexts." >&2
        return 1
    end

    # Dry run mode
    if set -q _flag_dry_run
        if set -q _flag_namespace
            echo "Would switch to context '$context' and set namespace to '$_flag_namespace'"
            echo "Commands:"
            echo "  kubectl config use-context $context"
            echo "  kubectl config set-context $context --namespace=$_flag_namespace"
        else
            echo "Would switch to context '$context'"
            echo "Command: kubectl config use-context $context"
        end
        return 0
    end

    # Switch the context
    if kubectl config use-context $context >/dev/null 2>&1
        echo "Context changed to '$context'"
        
        # Set namespace if specified
        if set -q _flag_namespace
            if _kcd_namespace_exists $_flag_namespace
                if kubectl config set-context $context --namespace=$_flag_namespace >/dev/null 2>&1
                    echo "Namespace set to '$_flag_namespace'"
                else
                    echo "kctx: warning - failed to set namespace to '$_flag_namespace'" >&2
                end
            else
                echo "kctx: warning - namespace '$_flag_namespace' not found" >&2
            end
        end
        
        return 0
    else
        echo "kctx: failed to switch to context '$context'" >&2
        return 1
    end
end

function _kctx_help
    echo "kctx - Change Kubernetes context"
    echo
    echo "USAGE:"
    echo "    kctx [OPTIONS] <context>"
    echo
    echo "OPTIONS:"
    echo "    -h, --help              Show this help message"
    echo "    -l, --list              List available contexts"
    echo "    -c, --current           Show current context"
    echo "    -d, --dry-run           Preview the change without applying it"
    echo "    -n, --namespace=NS      Also set the namespace after switching context"
    echo
    echo "EXAMPLES:"
    echo "    kctx production                    # Switch to production context"
    echo "    kctx --list                       # List all contexts"
    echo "    kctx --current                    # Show current context"
    echo "    kctx --dry-run staging           # Preview switching to staging"
    echo "    kctx prod --namespace=api        # Switch context and set namespace"
    echo
    echo "REQUIREMENTS:"
    echo "    - kubectl must be installed and configured"
    echo "    - Valid kubeconfig file must be present"
end

function _kctx_context_exists
    set -l context $argv[1]
    kubectl config get-contexts -o name 2>/dev/null | grep -q "^$context\$"
end