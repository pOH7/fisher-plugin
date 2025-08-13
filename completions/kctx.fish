# Complete kctx options
complete -c kctx -s h -l help -d "Show help message"
complete -c kctx -s l -l list -d "List available contexts"
complete -c kctx -s c -l current -d "Show current context"
complete -c kctx -s d -l dry-run -d "Preview change without applying"
complete -c kctx -s n -l namespace -d "Set namespace after switching context" -xa "(__kctx_complete_namespaces)"

# Complete context names
complete -c kctx -f -a "(__kctx_complete_contexts)" -d "Context"

function __kctx_complete_contexts
    if command -q kubectl
        kubectl config get-contexts -o name 2>/dev/null
    end
end

function __kctx_complete_namespaces
    if command -q kubectl
        kubectl get namespaces -o name 2>/dev/null | sed 's/namespace\///'
    end
end