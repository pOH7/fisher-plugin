# fissh

Start an SSH session and try to launch `fish -li` on the remote host. If `fish` is not installed remotely, `fissh` falls back to the remote login shell.

## Usage

```fish
fissh [FISSH_OPTIONS] [-- SSH_OPTIONS] destination
```

`fissh` parses its own flags first. Put native SSH flags after `--`.

## Options

- `-h`, `--help`: Show the built-in help text.
- `-v`, `--verbose`: Print a short connection message before running SSH.
- `-n`, `--no-fish`: Skip `fish` detection and always use the remote login shell.
- `-s`, `--shell=SHELL`: Try a specific shell first and fall back to the remote login shell if it is missing.

## Examples

```fish
# Default behavior
fissh user@example.com

# Pass native SSH flags after --
fissh -- -p 2222 user@example.com
fissh -- -L 8080:localhost:8080 user@example.com

# Combine fissh flags with SSH flags
fissh --verbose -- -p 2222 user@example.com

# Override the preferred remote shell
fissh --shell=zsh user@example.com

# Force the remote login shell
fissh --no-fish user@example.com
```

## Behavior Notes

- Default remote bootstrap command: try `fish -li`, otherwise run `$SHELL -li`.
- `--shell=SHELL` changes only the preferred shell. The final fallback remains `$SHELL -li`.
- The wrapper always allocates a TTY by appending `-t` to the SSH invocation.

## Requirements

- `ssh`
- A reachable SSH destination
