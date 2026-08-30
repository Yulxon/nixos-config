# Claude Code - AI coding assistant in your terminal
# Package: github:sadjow/claude-code-nix (hourly auto-updated native binary)
# Overlay is registered system-wide in modules/default.nix (home-manager
# runs with useGlobalPkgs, so the package must come from the system pkgs).
#
# Backend: DeepSeek Anthropic-compatible API
#   https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code/
# The API key is read at activation time from ~/.config/deepseek/api_key
# (NOT tracked by git; see that directory's .gitignore), so the secret never
# lands in the nix store or this repository.
{ pkgs, config, ... }:
let
  homeDir = config.home.homeDirectory;
  apiKeyFile = "${homeDir}/.config/deepseek/api_key";
in
{
  home.packages = [ pkgs.claude-code ];

  # Generate ~/.claude/settings.json on every activation, injecting the key
  # from the local file. Claude Code reads this file for both CLI and VSCode.
  home.activation.claudeSettings = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${homeDir}/.claude
    token="$([ -f "${apiKeyFile}" ] && sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "${apiKeyFile}" | tr -d '\n\r ' || true)"
    if [ -z "$token" ]; then
      echo "claude.nix: WARNING: ${apiKeyFile} missing or empty — ANTHROPIC_AUTH_TOKEN is empty" >&2
    fi
    ${pkgs.jq}/bin/jq -n \
      --arg base "https://api.deepseek.com/anthropic" \
      --arg pro "deepseek-v4-pro[1m]" \
      --arg flash "deepseek-v4-flash[1m]" \
      --arg token "$token" \
      '{env: {ANTHROPIC_BASE_URL: $base, ANTHROPIC_AUTH_TOKEN: $token, ANTHROPIC_MODEL: $pro, ANTHROPIC_DEFAULT_OPUS_MODEL: $pro, ANTHROPIC_DEFAULT_SONNET_MODEL: $pro, ANTHROPIC_DEFAULT_HAIKU_MODEL: $flash, CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC: "1", CLAUDE_CODE_EFFORT_LEVEL: "max"}}' \
      > ${homeDir}/.claude/settings.json
    chmod 600 ${homeDir}/.claude/settings.json
  '';
}
