# kubectl completion for Fish shell
# https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#enable-shell-autocompletion
if command -q kubectl
    kubectl completion fish | source
end