# DeepSeek Harness (`dsh`) — npm-based install infrastructure.
#
# dsh ships on npm (`@deepseek-ai/dsh`) rather than in nixpkgs, so it is
# installed and updated through npm's global prefix. The npm that comes from
# nixpkgs points that prefix at the read-only nix store, so we move it to
# ~/.local/npm and put its `bin` directory on PATH; the `up` script
# (home/scripts/default.nix) owns the actual install/update step.
#
# dsh's own state under ~/.dsh (settings, credentials, profiles, sessions) is
# written by dsh itself and is deliberately left unmanaged here.
{ config, ... }:

let
  homeDir = config.home.homeDirectory;
  npmPrefix = "${homeDir}/.local/npm";
in
{
  # `npm install -g` must not try to write into the read-only nix store.
  home.file.".npmrc".text = ''
    prefix=${npmPrefix}
    allow-scripts=@deepseek-ai/dsh-subprocess-local,koffi,node-pty,@google/genai,protobufjs
  '';

  # Exposes npm-global binaries — `dsh`, and the newer npm after `up` updated it.
  home.sessionPath = [ "${npmPrefix}/bin" ];
}
