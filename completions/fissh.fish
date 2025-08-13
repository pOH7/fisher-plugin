# Complete fissh options
complete -c fissh -s h -l help -d "Show help message"
complete -c fissh -s v -l verbose -d "Show verbose output"
complete -c fissh -s n -l no-fish -d "Don't try to use fish shell"
complete -c fissh -s s -l shell -d "Try to use specified shell" -xa "fish bash zsh tcsh csh ksh"

# Inherit SSH completions for everything else
complete -c fissh -w ssh