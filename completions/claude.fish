# Claude CLI completion for Fish shell

# Main command completion
complete -c claude -f

# Global options (only when not in subcommands with specific option handling)
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -s d -l debug -d "Enable debug mode with optional category filtering"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l verbose -d "Override verbose mode setting from config"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -s p -l print -d "Print response and exit (useful for pipes)"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l output-format -d "Output format (only works with --print)" -xa "text json stream-json"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l input-format -d "Input format (only works with --print)" -xa "text stream-json"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l mcp-debug -d "[DEPRECATED. Use --debug instead] Enable MCP debug mode"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l replay-user-messages -d "Re-emit user messages from stdin back on stdout for acknowledgment (only works with --input-format=stream-json and --output-format=stream-json)"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l dangerously-skip-permissions -d "Bypass all permission checks"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l allowedTools -l allowed-tools -d "Comma or space-separated list of tool names to allow"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l disallowedTools -l disallowed-tools -d "Comma or space-separated list of tool names to deny"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l mcp-config -d "Load MCP servers from a JSON file or string" -rF
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l append-system-prompt -d "Append a system prompt to the default system prompt"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l permission-mode -d "Permission mode to use for the session" -xa "acceptEdits bypassPermissions default plan"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -s c -l continue -d "Continue the most recent conversation"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -s r -l resume -d "Resume a conversation - provide a session ID or interactively select"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l model -d "Model for the current session" -xa "sonnet opus"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l fallback-model -d "Enable automatic fallback to specified model (only works with --print)" -xa "sonnet opus"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l settings -d "Path to a settings JSON file or a JSON string to load additional settings from" -rF
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l add-dir -d "Additional directories to allow tool access to" -xa "(__fish_complete_directories)"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l ide -d "Automatically connect to IDE on startup if exactly one valid IDE is available"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l strict-mcp-config -d "Only use MCP servers from --mcp-config, ignoring all other MCP configurations"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -l session-id -d "Use a specific session ID for the conversation (must be a valid UUID)"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -s v -l version -d "Output the version number"
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -s h -l help -d "Display help for command"

# Subcommands completion
complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -xa "config mcp migrate-installer setup-token doctor update install"

# config subcommand
complete -c claude -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get set remove rm list ls add help" -xa "get set remove rm list ls add help"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from set" -s g -l global -d "Use global config"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from get" -s g -l global -d "Use global config"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from remove" -s g -l global -d "Use global config"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from rm" -s g -l global -d "Use global config"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from list" -s g -l global -d "Use global config"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from ls" -s g -l global -d "Use global config"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from add" -s g -l global -d "Use global config"

# Add help options for config sub-subcommands
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from get" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from set" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from remove" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from rm" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from list" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from ls" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from add" -s h -l help -d "Display help for command"

# mcp subcommand
complete -c claude -n "__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from serve add remove list get add-json add-from-claude-desktop reset-project-choices help" -xa "serve add remove list get add-json add-from-claude-desktop reset-project-choices help"

# mcp add subcommand options
complete -c claude -n "__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add" -s s -l scope -d "Configuration scope (local, user, or project)" -xa "local user project"
complete -c claude -n "__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add" -s t -l transport -d "Transport type (stdio, sse, http)" -xa "stdio sse http"
complete -c claude -n "__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add" -s e -l env -d "Set environment variables (e.g. -e KEY=value)"
complete -c claude -n "__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add" -s H -l header -d "Set WebSocket headers (e.g. -H \"X-Api-Key: abc123\")"
complete -c claude -n "__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add" -s h -l help -d "Display help for command"

# install subcommand options
complete -c claude -n "__fish_seen_subcommand_from install" -xa "stable latest"
complete -c claude -n "__fish_seen_subcommand_from install" -l force -d "Force installation even if already installed"
complete -c claude -n "__fish_seen_subcommand_from install" -s h -l help -d "Display help for command"

# Function to check if we're in a subcommand context
function __fish_claude_using_subcommand
    set -l cmd (commandline -opc)
    if test (count $cmd) -ge 2
        switch $cmd[2]
            case config mcp migrate-installer setup-token doctor update install
                return 0
        end
    end
    return 1
end


# Add help option for simple subcommands that only have --help
complete -c claude -n "__fish_seen_subcommand_from migrate-installer" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from setup-token" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from doctor" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from update" -s h -l help -d "Display help for command"

# Add help option for config and mcp subcommands
complete -c claude -n "__fish_seen_subcommand_from config" -s h -l help -d "Display help for command"
complete -c claude -n "__fish_seen_subcommand_from mcp" -s h -l help -d "Display help for command"