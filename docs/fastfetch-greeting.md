# Fastfetch Greeting

The plugin can configure Fish to run `fastfetch` at shell startup.

## Default Behavior

When `FISHER_FASTFETCH_GREETING` is unset, the plugin auto-detects `fastfetch`:

- If `fastfetch` is available, it enables the greeting.
- If `fastfetch` is missing, it leaves the default Fish greeting alone.

## Configuration

Set these variables before starting a new Fish session:

```fish
# Enable fastfetch greeting
set -g FISHER_FASTFETCH_GREETING true

# Keep the default Fish greeting
set -g FISHER_FASTFETCH_GREETING false

# Disable greeting output entirely
set -g FISHER_FASTFETCH_GREETING disable

# Reset back to Fish defaults
set -g FISHER_FASTFETCH_GREETING reset

# Show a warning when fastfetch is requested but not installed
set -g FISHER_FASTFETCH_GREETING_VERBOSE true
```

## Behavior Notes

- `true` clears the default greeting and defines a `fish_greeting` function that runs `fastfetch`.
- If `fastfetch` fails at runtime, the generated `fish_greeting` falls back to Fish's default welcome text.
- `disable` silences the greeting by setting `fish_greeting` to an empty string.
- `reset` removes the custom greeting variable and deletes the saved `fish_greeting` function.
- When enabled successfully, the plugin runs `funcsave fish_greeting`, so the generated function is persisted in the user's Fish config.

## Requirements

- `fastfetch` is optional and only needed when enabling this feature
