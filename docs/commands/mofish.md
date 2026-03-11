# mofish

Start a `mosh` session and bootstrap an interactive shell on the remote host. The wrapper prefers `fish -li` remotely and falls back to `${SHELL:-/bin/sh} -li` when `fish` is unavailable.

## Usage

```fish
mofish [MOSH_OPTIONS] destination
```

`mofish` reserves the remote command slot for shell startup. It accepts exactly one positional argument: the destination host.

## Supported Options

The wrapper parses and forwards these native `mosh` flags:

- `--help`, `--version`
- `-a`, `-n`, `-o`
- `-4`, `-6`
- `--client=PATH`
- `--server=COMMAND`
- `--predict=MODE`
- `-p`, `--port=PORT[:PORT2]`
- `--family=VALUE`
- `--bind-server=VALUE`
- `--ssh=COMMAND`
- `--experimental-remote-ip=MODE`

## Examples

```fish
# Default behavior
mofish user@example.com

# Use a custom SSH command for mosh setup
mofish --ssh="ssh -p 2222" user@example.com

# Force IPv6
mofish --family=inet6 user@example.com

# Show native mosh help or version output
mofish --help
mofish --version
```

## Behavior Notes

- Extra positional arguments are rejected. Use `mosh` directly if you need to run a custom remote command.
- The wrapper runs `mosh ... -- destination sh -lc '<bootstrap script>'`.
- The command is intended for interactive terminal sessions, not arbitrary remote command execution.

## Requirements

- `mosh`
- Remote access to a host that can run `sh`
