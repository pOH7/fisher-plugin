# kcd

Switch the namespace for the current Kubernetes context after validating that the target namespace exists.

## Usage

```fish
kcd [OPTIONS] <namespace>
```

## Options

- `-h`, `--help`: Show the built-in help text.
- `-l`, `--list`: Print available namespaces from the active kubeconfig.
- `-c`, `--current`: Print the namespace for the current context, or `default` when none is set.
- `-d`, `--dry-run`: Show the `kubectl config set-context` command without applying it.

## Examples

```fish
# Switch to a namespace
kcd production

# Inspect state
kcd --current
kcd --list

# Preview the change
kcd --dry-run staging
```

## Behavior Notes

- `kcd` fails early when `kubectl` is missing.
- The namespace must already exist in the current cluster context.
- Changes are applied with `kubectl config set-context <current-context> --namespace=<namespace>`.

## Requirements

- `kubectl`
- A valid kubeconfig with a current context
