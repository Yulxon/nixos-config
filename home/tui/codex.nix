# Codex CLI - OpenAI's terminal coding agent
# Package: nixpkgs `codex` (native Rust binary, v0.146.0 in the locked nixos-26.05)
#
# Backend: DeepSeek Responses API (official integration):
#   https://api-docs.deepseek.com/quick_start/agent_integrations/codex/
# The API key is read at activation time from ~/.config/deepseek/api_key
# (NOT tracked by git; see that directory's .gitignore), so the secret never
# lands in the nix store or this repository.
#
# ~/.codex/models.json is the official DeepSeek model catalog
# (codex-models.json, exported from the official setup script) and is installed
# via home.file since it contains no secrets. ~/.codex/config.toml is
# regenerated on every activation with the key injected, mirroring claude.nix.
# Codex CLI, the ChatGPT desktop app and the Codex VS Code extension all share
# this config file.
{ pkgs, config, ... }:
let
  homeDir = config.home.homeDirectory;
  apiKeyFile = "${homeDir}/.config/deepseek/api_key";
in
{
  home.packages = [ pkgs.codex ];

  # Official DeepSeek model catalog: deepseek-v4-flash / -pro / -flash-vision-exp
  home.file.".codex/models.json".source = ./codex-models.json;

  # Generate ~/.codex/config.toml on every activation, injecting the key from
  # the local file. Switch model = "deepseek-v4-pro" to "deepseek-v4-flash"
  # for a cheaper/faster default.
  home.activation.codexConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${homeDir}/.codex
    token="$([ -f "${apiKeyFile}" ] && sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "${apiKeyFile}" | tr -d '\n\r ' || true)"
    if [ -z "$token" ]; then
      echo "codex.nix: WARNING: ${apiKeyFile} missing or empty — Codex will not authenticate" >&2
    fi
    cat > ${homeDir}/.codex/config.toml <<TOML
model = "deepseek-v4-pro"
model_provider = "deepseek"
preferred_auth_method = "apikey"
forced_login_method = "api"
model_reasoning_effort = "high"
model_catalog_json = "~/.codex/models.json"

[model_providers.deepseek]
name = "deepseek"
base_url = "https://api.deepseek.com/"
wire_api = "responses"
experimental_bearer_token = "$token"
TOML
    chmod 600 ${homeDir}/.codex/config.toml
  '';
}
