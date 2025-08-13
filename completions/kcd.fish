# Complete kcd options
complete -c kcd -s h -l help -d "Show help message"
complete -c kcd -s l -l list -d "List available namespaces"
complete -c kcd -s c -l current -d "Show current namespace"
complete -c kcd -s d -l dry-run -d "Preview change without applying"

# Complete namespace names
complete -c kcd -f -a "(__kcd_complete_namespaces)" -d "Namespace"

function __kcd_complete_namespaces
    if command -q kubectl
        kubectl get namespaces -o name 2>/dev/null | sed 's/namespace\///'
    end
end