# repo

Navigate to repositories and worktrees from the current Fish session.

## Usage

```fish
repo
repo <repo-url>
repo <repo-path>
repo <repo-query>
repo <repo-path|repo-query> <branch>
```

## Modes

- `repo` with no arguments:
  If the current directory is inside a Git worktree, jump to the repository root. Otherwise print usage.
- `repo <repo-url>`:
  Clone the repository into `~/Developer/<host>/<path>` when it is missing, then `cd` into it.
- `repo <repo-path>`:
  Change into an existing local repository path.
- `repo <repo-query>`:
  Resolve a unique local repository by case-insensitive basename or relative-path match, then `cd` into it.
- `repo <repo-path|repo-query> <branch>`:
  Create or reuse a worktree at `<repo-path>_<branch>` with `/` in the branch name replaced by `_`, then `cd` into it.

## Examples

```fish
# Jump to the root of the current repo
repo

# Clone into ~/Developer/github.com/org/project and enter it
repo https://github.com/org/project.git
repo git@github.com:org/project.git

# Enter an existing local repo
repo ~/Developer/github.com/org/project

# Resolve a unique local repo by query
repo fisher

# Create or reuse a worktree
repo ~/Developer/github.com/org/project feature/login
repo fisher feature/login
```

## Behavior Notes

- The clone base directory is hard-coded to `~/Developer`.
- URL inputs are converted to a local path by stripping the protocol or SSH prefix and removing the trailing `.git`.
- Local repo discovery follows symlinked directories under `~/Developer`.
- Query inputs must resolve to a single local repository or `repo` prints the ambiguous matches.
- Worktree creation delegates to `git worktree add`, so branch handling follows Git's normal rules.
- Because `repo` performs `cd`, it is only useful as a shell function, not as an external script.

## Requirements

- `git` for clone and worktree flows
- Existing local paths when using `repo <repo-path>`
