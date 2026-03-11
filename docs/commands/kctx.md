# kctx

Switch Kubernetes contexts with optional namespace assignment.

## Usage

```fish
kctx [OPTIONS] <context>
```

## Options

- `-h`, `--help`: Show the built-in help text.
- `-l`, `--list`: Print available contexts.
- `-c`, `--current`: Print the current context.
- `-d`, `--dry-run`: Show the commands that would run without applying them.
- `-n`, `--namespace=NS`: After switching contexts, try to set the namespace on that context.

## Examples

```fish
# Switch contexts
kctx production-cluster

# Inspect state
kctx --current
kctx --list

# Preview the commands
kctx --dry-run staging-cluster

# Switch context and set namespace
kctx prod-cluster --namespace=api
```

## Behavior Notes

- `kctx` fails early when `kubectl` is missing.
- The target context must already exist in the kubeconfig.
- When `--namespace` is provided, the context switch happens first.
- If namespace assignment fails, the context change is not rolled back; `kctx` prints a warning instead.

## Requirements

- `kubectl`
- A valid kubeconfig with the target context
