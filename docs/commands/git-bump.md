# git-bump

Create the next semantic version tag for the current Git repository. By default, `git-bump` creates a `v`-prefixed patch release and pushes the tag to the default remote.

## Usage

```fish
git-bump [TYPE] [OPTIONS]
```

`TYPE` may be `patch`, `minor`, or `major`. The default is `patch`.

## Options

- `-h`, `--help`: Show the built-in help text.
- `-d`, `--dry-run`: Show the current and next version without creating a tag.
- `-l`, `--list`: Print recent tags and the current `v`-prefixed version.
- `-p`, `--prefix=STR`: Use a custom tag prefix instead of `v`.
- `--no-prefix`: Create bare semantic version tags such as `1.2.3`.
- `--no-push`: Create the tag locally without pushing it.
- `-f`, `--force`: Skip the same-commit guard when `HEAD` already matches the latest tag.

## Examples

```fish
# Default patch bump
git-bump

# Minor or major release
git-bump minor
git-bump major

# Prefix control
git-bump patch --prefix=rel
git-bump major --no-prefix

# Preview or keep the tag local
git-bump --dry-run
git-bump --no-push
```

## Behavior Notes

- If no matching semantic version tag exists, the command starts from `0.0.0`.
- With uncommitted changes, `git-bump` prompts before creating the tag.
- If `HEAD` already points at the latest matching tag, the command warns before creating another tag on the same commit unless `--force` is used.
- When pushing is enabled, the tag is pushed to the first Git remote returned by `git remote`.

## Requirements

- `git`
- An annotated-tag-capable repository
- A configured remote when using the default push behavior
