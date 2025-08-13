# Fastfetch greeting configuration for Fisher plugin
# This script automatically runs when Fish shell starts

# Check if fastfetch greeting is enabled (default: enabled if fastfetch is available)
if not set -q FISHER_FASTFETCH_GREETING
    # Auto-detect: enable if fastfetch is available, otherwise keep default
    if command -v fastfetch >/dev/null 2>&1
        set -g FISHER_FASTFETCH_GREETING true
    else
        set -g FISHER_FASTFETCH_GREETING false
    end
end

# Only proceed if fastfetch greeting is enabled
if test "$FISHER_FASTFETCH_GREETING" = "true"
    # Check if fastfetch is actually available
    if command -v fastfetch >/dev/null 2>&1
        # Clear the default greeting and set up fastfetch
        set -g fish_greeting ""
        
        # Define the greeting function that uses fastfetch
        function fish_greeting
            fastfetch 2>/dev/null
            or begin
                # Fallback to default greeting if fastfetch fails
                echo "Welcome to fish, the friendly interactive shell"
                echo "Type 'help' for instructions on how to use fish"
            end
        end
        
        # Save the function so it persists
        funcsave fish_greeting >/dev/null 2>&1
    else
        # Fastfetch not available but user requested it
        if test "$FISHER_FASTFETCH_GREETING_VERBOSE" = "true"
            echo "fastfetch not found - install from: https://github.com/fastfetch-cli/fastfetch" >&2
        end
    end
else if test "$FISHER_FASTFETCH_GREETING" = "disable"
    # User explicitly disabled greeting
    set -g fish_greeting ""
else if test "$FISHER_FASTFETCH_GREETING" = "reset"
    # User wants to reset to default Fish greeting
    set -e fish_greeting
    functions -e fish_greeting >/dev/null 2>&1
end