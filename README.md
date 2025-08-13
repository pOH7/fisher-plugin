# Fisher Plugin Collection

A Fisher plugin collection that provides useful utilities for git operations and remote server connections.

## Installation

```fish
fisher install pOH7/fisher-plugin
```

## Commands

### fissh - SSH with Fish Shell

Connect to remote servers using Fish shell when available, with intelligent fallback and flexible options.

```fish
# Connect to remote server with Fish shell auto-detection
fissh user@hostname

# Pass SSH options (all SSH options supported)
fissh -p 2222 user@hostname
fissh -L 8080:localhost:8080 user@hostname

# fissh-specific options
fissh --verbose user@hostname              # Show connection details
fissh --no-fish user@hostname              # Force use of default shell
fissh --shell=zsh user@hostname            # Try zsh instead of fish
fissh --help                               # Show detailed help

# Combine fissh and SSH options
fissh --verbose -p 2222 user@hostname
```

The `fissh` command provides:
- **Smart shell detection**: Automatically detects and uses Fish shell on remote servers
- **Graceful fallback**: Falls back to default shell if preferred shell isn't available
- **Flexible shell selection**: Option to specify alternative shells (zsh, bash, etc.)
- **Verbose mode**: Shows what's happening during connection
- **Full SSH compatibility**: Supports all SSH options and arguments
- **Help system**: Built-in help with `--help` option

### git-bump - Semantic Version Bumping

Basic Commands

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

### fissh
- **Smart shell detection**: Automatically detects and uses Fish shell on remote servers
- **Flexible shell options**: Can specify alternative shells (zsh, bash, etc.) or disable auto-detection
- **Verbose mode**: Optional feedback about connection and shell selection
- **Robust error handling**: Proper argument validation and helpful error messages
- **Full SSH compatibility**: Supports all SSH options and arguments
- **Enhanced tab completion**: Completions for fissh options plus inherited SSH completions
- **Built-in help**: Comprehensive help system with usage examples

### git-bump
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

- Fish shell
- Fisher plugin manager
- SSH client (for fissh)
- Git repository with remote configured (for git-bump push functionality)

## License

MIT