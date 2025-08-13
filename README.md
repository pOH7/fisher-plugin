# git-bump

A Fisher plugin that automates semantic version bumping for git tags with automatic remote pushing.

## Installation

```fish
fisher install pOH7/fisher-plugin
```

## Usage

### Basic Commands

```fish
# Bump patch version with 'v' prefix and push to remote (default)
git-bump

# Bump specific version types
git-bump patch    # v1.0.0 → v1.0.1 (and push)
git-bump minor    # v1.0.1 → v1.1.0 (and push)
git-bump major    # v1.1.0 → v2.0.0 (and push)
```

### Options

```fish
# Preview changes without creating tag
git-bump --dry-run
git-bump minor --dry-run

# Use custom prefix
git-bump patch --prefix=rel  # Creates rel1.0.1

# No prefix
git-bump major --no-prefix   # Creates 2.0.0 (and push)

# Don't push to remote (local only)
git-bump --no-push           # Creates v1.0.1 locally only

# List current version and recent tags
git-bump --list

# Show help
git-bump --help
```

## Features

- **Default behavior**: `git-bump` defaults to `patch --prefix v` with automatic push
- **Semantic versioning**: Follows X.Y.Z format
- **Flexible prefixes**: Default 'v' prefix with options to customize or disable
- **Remote pushing**: Automatically pushes tags to remote by default
- **Safety checks**: Warns about uncommitted changes
- **Dry run mode**: Preview changes before applying
- **Auto-detection**: Finds latest semantic version tag automatically
- **Tab completion**: Full command and option completion

## Examples

Starting from tag `v1.2.3`:

```fish
git-bump              # Creates v1.2.4 and pushes to remote
git-bump minor        # Creates v1.3.0 and pushes to remote
git-bump major        # Creates v2.0.0 and pushes to remote
git-bump --no-prefix  # Creates 1.2.4 and pushes to remote
git-bump --no-push    # Creates v1.2.4 locally only
```

No existing tags:

```fish
git-bump              # Creates v0.0.1 and pushes to remote
```

## Requirements

- Git repository with remote configured (for push functionality)
- Fish shell
- Fisher plugin manager

## License

MIT