function repo
    set -l base_dir ~/Developer

    # If no args: if inside a Git repo/worktree, jump to its root
    if test (count $argv) -eq 0
        # Silence both stdout and stderr correctly in fish
        if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set -l git_root (command git rev-parse --show-toplevel)
            if test -n "$git_root"
                __repo_navigate_to $git_root
                return 0
            end
        end
        echo "Usage: repo <repo-url|repo-path> [branch]"
        echo "  repo-url: Git repository URL (https/ssh)"
        echo "  repo-path: Local repository path"
        echo "  branch: Branch name for worktree creation"
        echo ""
        echo "Options:"
        echo "  -h, --help    Show this help message"
        return 0
    end

    if test "$argv[1]" = "-h"; or test "$argv[1]" = "--help"
        echo "Usage: repo <repo-url|repo-path> [branch]"
        echo "  repo-url: Git repository URL (https/ssh)"
        echo "  repo-path: Local repository path"
        echo "  branch: Branch name for worktree creation"
        echo ""
        echo "Options:"
        echo "  -h, --help    Show this help message"
        return 0
    end

    set -l arg1 $argv[1]
    set -l branch $argv[2]

    if string match -qr '^(https?|git)' $arg1
        __repo_handle_repo_url $arg1 $base_dir
    else if not test -z $branch
        __repo_handle_worktree $arg1 $branch
    else
        __repo_navigate_to_repo $arg1
    end
end

function __repo_handle_repo_url
    set -l repo_url $argv[1]
    set -l base_dir $argv[2]
    
    set -l repo_path (__repo_parse_repo_path $repo_url $base_dir)
    
    if not test -d $repo_path
        if not __repo_clone_repo $repo_url $repo_path
            return 1
        end
    end
    
    __repo_navigate_to $repo_path
end

function __repo_handle_worktree
    set -l repo_path $argv[1]
    set -l branch $argv[2]
    
    if not test -d $repo_path
        echo "Error: Repository path '$repo_path' does not exist" >&2
        return 1
    end
    
    set -l worktree_path "$repo_path"_(string replace -a '/' '_' $branch)
    
    if not test -d $worktree_path
        if not __repo_create_worktree $repo_path $worktree_path $branch
            return 1
        end
    end
    
    __repo_navigate_to $worktree_path
end

function __repo_navigate_to_repo
    set -l repo_path $argv[1]
    
    if not test -d $repo_path
        echo "Error: Repository path '$repo_path' does not exist" >&2
        return 1
    end
    
    __repo_navigate_to $repo_path
end

function __repo_parse_repo_path
    set -l repo_url $argv[1]
    set -l base_dir $argv[2]
    
    echo $base_dir/(string replace -r '^https?://' '' $repo_url | string replace -r '^git@([^:]+):' '$1/' | string replace -r '.git$' '')
end

function __repo_clone_repo
    set -l repo_url $argv[1]
    set -l repo_path $argv[2]
    
    echo "Cloning repository to: $repo_path"
    
    if not run_and_echo --check-status mkdir -p (dirname $repo_path)
        echo "Error: Failed to create parent directory" >&2
        return 1
    end
    
    if not run_and_echo --check-status git clone $repo_url $repo_path
        echo "Error: Failed to clone repository" >&2
        return 1
    end
    
    return 0
end

function __repo_create_worktree
    set -l repo_path $argv[1]
    set -l worktree_path $argv[2]
    set -l branch $argv[3]
    
    echo "Creating worktree for branch '$branch' at: $worktree_path"
    
    if not run_and_echo --check-status --quiet cd $repo_path
        echo "Error: Failed to enter repository directory" >&2
        return 1
    end
    
    if not run_and_echo --check-status git worktree add $worktree_path $branch
        echo "Error: Failed to create worktree for branch '$branch'" >&2
        return 1
    end
    
    return 0
end

function __repo_navigate_to
    set -l target_path $argv[1]
    
    if not test -d $target_path
        echo "Error: Target path '$target_path' does not exist" >&2
        return 1
    end
    
    run_and_echo cd $target_path
end
