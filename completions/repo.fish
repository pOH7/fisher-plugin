function __repo_complete_repos
    set -l base_dir ~/Developer
    set -l cache_file ~/.cache/fish/repo_paths_v2
    set -l cache_age 300
    
    if not test -d (dirname $cache_file)
        mkdir -p (dirname $cache_file)
    end
    
    if test -f $cache_file; and test (math (date +%s) - (stat -c %Y $cache_file 2>/dev/null || stat -f %m $cache_file)) -lt $cache_age
        cat $cache_file
        return
    end
    
    find -L $base_dir -maxdepth 6 -name '.git' -type d 2>/dev/null | while read git_dir
        set -l repo_path (dirname $git_dir)
        string replace $base_dir/ '' $repo_path
    end | sort > $cache_file

    cat $cache_file
end

function __repo_complete_matching_repos
    set -l query (string lower -- (commandline -t))

    if test -z "$query"
        __repo_complete_repos
        return
    end

    set -l query_regex (string escape --style=regex -- "$query")

    __repo_complete_repos | while read -l repo_path
        set -l repo_path_lower (string lower -- "$repo_path")
        set -l repo_name_lower (string lower -- (basename "$repo_path"))
        set -l repo_name_tokens (string replace -ra '[-_]+' '\n' -- "$repo_name_lower")

        if string match -rq -- ".*$query_regex.*" "$repo_path_lower"
            echo $repo_path
        else if string match -rq -- ".*$query_regex.*" "$repo_name_lower"
            echo $repo_path
        else if contains -- "$query" $repo_name_tokens
            echo $repo_path
        end
    end | sort -u
end

function __repo_complete_resolve_repo_path
    set -l repo_input $argv[1]
    set -l base_dir ~/Developer

    if test -d "$repo_input"
        echo $repo_input
        return 0
    end

    set -l rooted_repo_path "$base_dir/$repo_input"
    if test -d "$rooted_repo_path"
        echo $rooted_repo_path
        return 0
    end

    set -l repo_input_lower (string lower -- "$repo_input")
    set -l exact_matches (__repo_complete_repos | while read -l relative_repo_path
        set -l relative_repo_path_lower (string lower -- "$relative_repo_path")
        set -l repo_name_lower (string lower -- (basename "$relative_repo_path"))
        set -l repo_name_tokens (string replace -ra '[-_]+' '\n' -- "$repo_name_lower")

        if test "$relative_repo_path_lower" = "$repo_input_lower"
            echo "$base_dir/$relative_repo_path"
        else if test "$repo_name_lower" = "$repo_input_lower"
            echo "$base_dir/$relative_repo_path"
        else if contains -- "$repo_input_lower" $repo_name_tokens
            echo "$base_dir/$relative_repo_path"
        end
    end)

    if test (count $exact_matches) -eq 1
        echo $exact_matches[1]
        return 0
    end

    set -l repo_input_regex (string escape --style=regex -- "$repo_input_lower")
    set -l contains_matches (__repo_complete_repos | while read -l relative_repo_path
        set -l relative_repo_path_lower (string lower -- "$relative_repo_path")
        set -l repo_name_lower (string lower -- (basename "$relative_repo_path"))

        if string match -rq -- ".*$repo_input_regex.*" "$relative_repo_path_lower"
            echo "$base_dir/$relative_repo_path"
        else if string match -rq -- ".*$repo_input_regex.*" "$repo_name_lower"
            echo "$base_dir/$relative_repo_path"
        end
    end | sort -u)

    if test (count $contains_matches) -eq 1
        echo $contains_matches[1]
    end
end

function __repo_complete_branches
    set -l repo_path (__repo_complete_resolve_repo_path $argv[1])
    
    if test -d "$repo_path/.git"
        git -C $repo_path branch -a --format='%(refname:short)' 2>/dev/null | string replace 'origin/' ''
    end
end

complete -c repo -f

complete -c repo -n '__fish_is_first_token' -a '(__repo_complete_matching_repos)' -d 'Repository'

complete -c repo -n 'test (count (commandline -opc)) -eq 2' -a '(__repo_complete_branches (commandline -opc)[2])' -d 'Branch'
