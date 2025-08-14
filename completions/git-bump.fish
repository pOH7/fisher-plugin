complete -c git-bump -f

complete -c git-bump -s h -l help -d "Show help message"
complete -c git-bump -s d -l dry-run -d "Show what would be done without creating tag"
complete -c git-bump -s l -l list -d "List current version and recent tags"
complete -c git-bump -s p -l prefix -d "Use custom prefix" -r
complete -c git-bump -l no-prefix -d "Don't use any prefix"
complete -c git-bump -l no-push -d "Don't push tag to remote"
complete -c git-bump -s f -l force -d "Skip same-commit check when HEAD is at latest tag"

complete -c git-bump -n "not __fish_seen_subcommand_from patch minor major" -a "patch" -d "Increment patch version"
complete -c git-bump -n "not __fish_seen_subcommand_from patch minor major" -a "minor" -d "Increment minor version"
complete -c git-bump -n "not __fish_seen_subcommand_from patch minor major" -a "major" -d "Increment major version"