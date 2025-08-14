function __repo_complete_repos
    set -l base_dir ~/Developer
    set -l cache_file ~/.cache/fish/gh_repos
    set -l cache_age 300
    
    if not test -d (dirname $cache_file)
        mkdir -p (dirname $cache_file)
    end
    
    if test -f $cache_file; and test (math (date +%s) - (stat -c %Y $cache_file 2>/dev/null || stat -f %m $cache_file)) -lt $cache_age
        cat $cache_file
        return
    end
    
    find $base_dir -maxdepth 6 -name '.git' -type d 2>/dev/null | while read git_dir
        set -l repo_path (dirname $git_dir)
        string replace $base_dir/ '' $repo_path
    end | sort > $cache_file
    
    cat $cache_file
end

function __repo_complete_branches
    set -l repo_path $argv[1]
    
    if test -d "$repo_path/.git"
        git -C $repo_path branch -a --format='%(refname:short)' 2>/dev/null | string replace 'origin/' ''
    end
end

complete -c repo -f

complete -c repo -n '__fish_is_first_token' -a '(__repo_complete_repos)' -d 'Repository'

complete -c repo -n '__fish_is_first_token' -a '(find ~/Developer -maxdepth 6 -name ".git" -type d 2>/dev/null | while read git_dir; set repo_path (dirname $git_dir); if string match -q "*$(commandline -t)*" (basename $repo_path); echo (string replace ~/Developer/ "" $repo_path); end; end)' -d 'Repository (filtered)'

complete -c repo -n 'test (count (commandline -opc)) -eq 2' -a '(__repo_complete_branches (commandline -opc)[2])' -d 'Branch'