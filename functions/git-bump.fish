function git-bump --description "Bump project and git tag versions following semantic versioning"
    set -l options h/help d/dry-run l/list p/prefix= no-prefix no-push f/force
    argparse $options -- $argv
    or return 1

    if set -q _flag_help
        __git_bump_help
        return 0
    end

    if set -q _flag_list
        __git_bump_list
        return 0
    end

    if not __git_bump_is_git_repo
        echo "Error: Not a git repository" >&2
        return 1
    end

    set -l bump_type "patch"
    if test (count $argv) -ge 1
        set bump_type $argv[1]
    end

    if not contains $bump_type patch minor major
        echo "Error: Invalid bump type '$bump_type'. Use: patch, minor, or major" >&2
        return 1
    end

    set -l prefix "v"
    if set -q _flag_no_prefix
        set prefix ""
    else if set -q _flag_prefix
        set prefix $_flag_prefix
    end

    set -l current_version (__git_bump_get_latest_version $prefix)
    if test $status -ne 0
        set current_version "0.0.0"
    end

    set -l new_version (__git_bump_increment_version $current_version $bump_type)
    set -l new_tag "$prefix$new_version"

    set -l package_version ""
    set -l package_is_versioned false
    set -l should_bump_package false
    set -l repo_root (__git_bump_get_repo_root)
    set -l package_file "$repo_root/package.json"
    if test -f "$package_file"
        if not command -sq node
            echo "Error: Node.js is required to inspect package.json" >&2
            return 1
        end

        set package_version (__git_bump_get_package_version "$package_file")
        set -l package_status $status
        switch $package_status
            case 0
                set package_is_versioned true
                if test "$package_version" != "$new_version"
                    set should_bump_package true
                end
            case 2
                # package.json has no version field; keep tag-only behavior.
            case '*'
                echo "Error: Failed to read package.json" >&2
                return 1
        end
    end

    set -l same_commit_warning ""
    if not set -q _flag_force; and test "$should_bump_package" = false
        if __git_bump_is_same_commit_as_latest_tag $prefix
            set same_commit_warning "Warning: Current HEAD is already at the latest tag ($(__git_bump_get_latest_version_with_prefix $prefix))."
        end
    end

    if set -q _flag_dry_run
        echo "Current version: $prefix$current_version"
        echo "Next version: $new_tag"
        if test "$should_bump_package" = true
            echo "Would update package.json: $package_version -> $new_version"
            echo "Would commit: chore(version): bump version to $new_version"
        end
        if test -n "$same_commit_warning"
            echo "$same_commit_warning"
            echo "Creating a new tag will result in multiple tags pointing to the same commit."
            echo "Operation would be aborted (use --force to override)."
            return 1
        end
        if not set -q _flag_no_push
            echo "Would push to remote: $(__git_bump_get_default_remote)"
        end
        return 0
    end

    if test "$package_is_versioned" = true; and not __git_bump_package_is_clean
        echo "Error: package.json already has uncommitted changes; refusing to overwrite them." >&2
        return 1
    end

    if __git_bump_has_uncommitted_changes
        echo "Warning: You have uncommitted changes. Consider committing before tagging." >&2
        read -l -P "Continue anyway? [y/N] " confirm
        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Aborted."
            return 1
        end
    end

    if test -n "$same_commit_warning"
        echo "$same_commit_warning" >&2
        echo "Creating a new tag will result in multiple tags pointing to the same commit." >&2
        read -l -P "Continue anyway? Use --force to skip this check. [y/N] " confirm
        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Aborted."
            return 1
        end
    end

    set -l created_version_commit false
    if test "$should_bump_package" = true
        if not __git_bump_update_package_version "$new_version"
            return 1
        end
        set created_version_commit true
    end

    if git tag -a "$new_tag" -m "Version $new_tag"
        echo "Created tag: $new_tag"
        
        if not set -q _flag_no_push
            if __git_bump_push "$new_tag" "$created_version_commit"
                if test "$created_version_commit" = true
                    echo "Pushed version commit and tag to remote: $new_tag"
                else
                    echo "Pushed tag to remote: $new_tag"
                end
            else
                echo "Warning: Tag created locally but failed to push to remote" >&2
                return 1
            end
        end
        
        return 0
    else
        echo "Error: Failed to create tag $new_tag" >&2
        return 1
    end
end

function __git_bump_help
    echo "git-bump - Bump project and git tag versions following semantic versioning"
    echo ""
    echo "Usage:"
    echo "  git-bump [TYPE] [OPTIONS]"
    echo ""
    echo "Types:"
    echo "  patch    Increment patch version (default)"
    echo "  minor    Increment minor version"
    echo "  major    Increment major version"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -d, --dry-run     Show what would be done without creating tag"
    echo "  -l, --list        List current version and recent tags"
    echo "  -p, --prefix=STR  Use custom prefix (default: 'v')"
    echo "  --no-prefix       Don't use any prefix"
    echo "  --no-push         Don't push tag to remote (default: push)"
    echo "  -f, --force       Skip same-commit check when HEAD is at latest tag"
    echo ""
    echo "If package.json has a version field, git-bump updates it and creates"
    echo "a chore(version) commit before creating the tag. This is a version"
    echo "synchronization step; it does not publish a package."
    echo ""
    echo "Examples:"
    echo "  git-bump                    # Bump patch with 'v' prefix and push"
    echo "  git-bump minor              # Bump minor with 'v' prefix and push"
    echo "  git-bump major --no-prefix  # Bump major without prefix and push"
    echo "  git-bump patch --prefix=rel # Bump patch with 'rel' prefix and push"
    echo "  git-bump --no-push          # Bump patch locally only (no push)"
    echo "  git-bump --dry-run minor    # Preview minor bump"
    echo "  git-bump --force            # Force bump even if HEAD is at latest tag"
end

function __git_bump_list
    echo "Recent tags:"
    git tag --sort=-version:refname | head -10
    echo ""
    echo "Current version: $(__git_bump_get_latest_version_with_prefix v)"
end

function __git_bump_is_git_repo
    git rev-parse --git-dir >/dev/null 2>&1
end

function __git_bump_has_uncommitted_changes
    not git diff --quiet; or not git diff --cached --quiet
end

function __git_bump_get_latest_version
    set -l prefix_arg $argv[1]
    if test -z "$prefix_arg"
        set prefix_arg "v"
    end
    
    set -l regex_pattern
    if test "$prefix_arg" = ""
        set regex_pattern '^[0-9]+\.[0-9]+\.[0-9]+$'
    else
        set regex_pattern "^$prefix_arg""[0-9]+\\.[0-9]+\\.[0-9]+\$"
    end
    
    set -l latest_tag (git tag --sort=-version:refname | grep -E "$regex_pattern" | head -1)
    if test -z "$latest_tag"
        return 1
    end
    
    if test "$prefix_arg" = ""
        echo $latest_tag
    else
        echo $latest_tag | sed "s/^$prefix_arg//"
    end
end

function __git_bump_get_latest_version_with_prefix
    set -l prefix_arg $argv[1]
    if test -z "$prefix_arg"
        set prefix_arg "v"
    end
    
    set -l regex_pattern
    if test "$prefix_arg" = ""
        set regex_pattern '^[0-9]+\.[0-9]+\.[0-9]+$'
    else
        set regex_pattern "^$prefix_arg""[0-9]+\\.[0-9]+\\.[0-9]+\$"
    end
    
    set -l latest_tag (git tag --sort=-version:refname | grep -E "$regex_pattern" | head -1)
    if test -z "$latest_tag"
        echo "No version tags found"
        return 1
    end
    echo $latest_tag
end

function __git_bump_increment_version
    set -l ver $argv[1]
    set -l bump_type $argv[2]
    
    set -l parts (string split . $ver)
    set -l major $parts[1]
    set -l minor $parts[2]
    set -l patch $parts[3]
    
    switch $bump_type
        case major
            set major (math $major + 1)
            set minor 0
            set patch 0
        case minor
            set minor (math $minor + 1)
            set patch 0
        case patch
            set patch (math $patch + 1)
    end
    
    echo "$major.$minor.$patch"
end

function __git_bump_get_repo_root
    git rev-parse --show-toplevel 2>/dev/null
end

function __git_bump_get_package_version
    set -l package_file $argv[1]
    node -e 'const fs = require("node:fs"); let p; try { p = JSON.parse(fs.readFileSync(process.argv[1], "utf8")); } catch { process.exit(1); } if (typeof p.version !== "string") process.exit(2); process.stdout.write(p.version);' "$package_file" 2>/dev/null
end

function __git_bump_package_is_clean
    set -l repo_root (__git_bump_get_repo_root)
    test -z "$(git -C "$repo_root" status --porcelain -- package.json)"
end

function __git_bump_update_package_version
    set -l new_version $argv[1]
    set -l repo_root (__git_bump_get_repo_root)
    set -l package_file "$repo_root/package.json"

    if not node -e 'const fs = require("node:fs"); const path = process.argv[1]; const version = process.argv[2]; const p = JSON.parse(fs.readFileSync(path, "utf8")); p.version = version; fs.writeFileSync(path, JSON.stringify(p, null, 2) + "\n");' "$package_file" "$new_version"
        echo "Error: Failed to update package.json" >&2
        return 1
    end

    if not git -C "$repo_root" add -- package.json
        echo "Error: Failed to stage package.json" >&2
        return 1
    end

    if not git -C "$repo_root" commit -m "chore(version): bump version to $new_version" -- package.json
        echo "Error: Failed to commit package.json version update" >&2
        return 1
    end

    echo "Updated package.json and created version commit: $new_version"
end

function __git_bump_has_remote
    git remote >/dev/null 2>&1
end

function __git_bump_get_default_remote
    set -l remote (git remote | head -1)
    if test -z "$remote"
        echo "origin"
    else
        echo $remote
    end
end

function __git_bump_get_tag_commit
    set -l tag $argv[1]
    if test -z "$tag"
        return 1
    end
    git rev-list -n 1 "$tag" 2>/dev/null
end

function __git_bump_is_same_commit_as_latest_tag
    set -l prefix_arg $argv[1]
    if test -z "$prefix_arg"
        set prefix_arg "v"
    end
    
    set -l latest_tag (__git_bump_get_latest_version_with_prefix $prefix_arg)
    if test $status -ne 0
        return 1
    end
    
    set -l current_commit (git rev-parse HEAD 2>/dev/null)
    set -l tag_commit (__git_bump_get_tag_commit "$latest_tag")
    
    if test -z "$current_commit" -o -z "$tag_commit"
        return 1
    end
    
    test "$current_commit" = "$tag_commit"
end

function __git_bump_push
    set -l tag $argv[1]
    set -l include_head $argv[2]
    
    if not __git_bump_has_remote
        echo "Error: No remote repository configured" >&2
        return 1
    end
    
    set -l remote (__git_bump_get_default_remote)
    if test "$include_head" = true
        git push "$remote" HEAD "$tag" 2>/dev/null
    else
        git push "$remote" "$tag" 2>/dev/null
    end
end
