# Fisher Plugin Collection

Utilities for Fish shell covering remote access, Kubernetes context switching, repository navigation, release tagging, and an optional `fastfetch` startup greeting.

## Installation

```fish
fisher install pOH7/fisher-plugin
```

## Documentation

Detailed command references live outside the main README:

- [Command index](docs/commands/README.md)
- [fissh](docs/commands/fissh.md)
- [mofish](docs/commands/mofish.md)
- [kcd](docs/commands/kcd.md)
- [kctx](docs/commands/kctx.md)
- [git-bump](docs/commands/git-bump.md)
- [repo](docs/commands/repo.md)
- [Fastfetch greeting](docs/fastfetch-greeting.md)

## Included Commands

- `fissh`: Start an SSH session and prefer `fish` on the remote host when it is available.
- `mofish`: Start a roaming-friendly `mosh` session and bootstrap `fish` remotely when possible.
- `kcd`: Switch the namespace for the current Kubernetes context.
- `kctx`: Switch Kubernetes contexts and optionally set a namespace at the same time.
- `git-bump`: Create the next semantic version tag and push it by default.
- `repo`: Jump to a repo root, resolve a unique local repo query, clone into `~/Developer`, or open a worktree.

## Requirements

- Fish shell
- [Fisher](https://github.com/jorgebucaran/fisher)
- `ssh` for `fissh`
- `mosh` for `mofish`
- `kubectl` plus a valid kubeconfig for `kcd` and `kctx`
- `git` for `git-bump` and `repo`
- `fastfetch` is optional and only needed for the startup greeting feature

## License

MIT
