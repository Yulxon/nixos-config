{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  llm = inputs.llm-agents.packages.${system};
in
{
  imports = [
    ./git.nix
    ./helix.nix
    ./shell.nix
  ];

  home.packages =
    (with pkgs; [
      nixd
      nixfmt
      nodejs # OpenAI Developers plugin's local MCP server

      bubblewrap # codex need
    ])
    ++ (with llm; [
      dsh
      codex
      # claude-code
    ]);

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;

    yt-dlp = {
      enable = true;
      # LibreWolf uses the Firefox cookie database format.
      extraConfig = ''
        --cookies-from-browser firefox:~/.librewolf
      '';
    };
  };
}
