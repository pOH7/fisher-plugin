# Fisher Plugin Collection

A Fisher plugin collection that provides useful utilities for git operations and remote server connections.

## Installation

```fish
fisher install pOH7/fisher-plugin
```

## Commands

### fissh - SSH with Fish Shell

Connect to remote servers using Fish shell when available, with intelligent fallback and flexible options.

### kcd - Kubernetes Namespace Management

Switch between Kubernetes namespaces in the current context with validation and helpful feedback.

### kctx - Kubernetes Context Management

Switch between Kubernetes contexts with optional namespace setting and comprehensive validation.

### Fastfetch Greeting - Automatic System Info Display

Automatically configures Fish shell to use fastfetch for system information display on shell startup. No manual setup required - just install the plugin!

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

#### kcd Usage

```fish
# Switch to a specific namespace
kcd production

# List all available namespaces  
kcd --list

# Show current namespace
kcd --current

# Preview namespace change
kcd --dry-run staging

# Get help
kcd --help
```

#### kctx Usage

```fish
# Switch to a specific context
kctx production-cluster

# Switch context and set namespace
kctx prod-cluster --namespace=api

# List all available contexts
kctx --list

# Show current context
kctx --current

# Preview context change
kctx --dry-run staging-cluster

# Get help
kctx --help
```

#### Fastfetch Greeting Configuration

The fastfetch greeting is automatically enabled when you install the plugin and fastfetch is available. Configure it using environment variables:

```fish
# Enable fastfetch greeting (auto-detected by default)
set -g FISHER_FASTFETCH_GREETING true

# Disable fastfetch greeting entirely 
set -g FISHER_FASTFETCH_GREETING disable

# Reset to default Fish greeting
set -g FISHER_FASTFETCH_GREETING reset

# Disable fastfetch greeting (keep default Fish greeting)
set -g FISHER_FASTFETCH_GREETING false

# Enable verbose error messages when fastfetch is not found
set -g FISHER_FASTFETCH_GREETING_VERBOSE true
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

### kcd & kctx
- **Smart validation**: Checks if namespaces/contexts exist before switching
- **Helpful feedback**: Clear success/error messages and current state display
- **List functionality**: Easy discovery of available namespaces and contexts
- **Dry-run mode**: Preview changes before applying them
- **Tab completion**: Dynamic completion of namespaces and contexts from kubectl
- **Combined operations**: kctx can switch context and set namespace in one command
- **Error handling**: Comprehensive error checking and helpful error messages
- **Built-in help**: Complete usage documentation with examples

### Fastfetch Greeting
- **Automatic setup**: No manual configuration needed - works immediately after plugin installation
- **Smart dependency detection**: Automatically detects if fastfetch is available and enables accordingly
- **Graceful fallback**: Falls back to default Fish greeting if fastfetch fails or is unavailable  
- **Environment variable configuration**: Simple variable-based control instead of commands
- **Persistent settings**: Configuration persists across Fish shell sessions
- **Zero overhead**: Only runs detection once per shell session
- **Error handling**: Comprehensive error checking with optional verbose messaging

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
- kubectl (for kcd and kctx)
- Valid Kubernetes configuration (for kcd and kctx)
- Git repository with remote configured (for git-bump push functionality)
- fastfetch (optional, for fish_greeting_fastfetch) - Install from: https://github.com/fastfetch-cli/fastfetch

## License

MIT