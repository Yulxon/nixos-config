{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  llm = inputs.llm-agents.packages.${system};
in
{
  imports = [
    ./git.nix
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
      chatgpt
    ]);

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
    fastfetch.enable = true;
    htop.enable = true;
    btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
        theme_background = false;
        truecolor = false;
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings.theme = "system";
      # UI defaults and syntax ANSI colors follow the terminal's appearance.
      themes.system = {
        inherits = "base16_terminal";
        "ui.text" = "default";
        "ui.linenr" = "default";
        "ui.window" = "default";
      }
      //
        lib.genAttrs
          [
            "ui.background"
            "ui.popup"
            "ui.help"
            "ui.menu"
            "ui.statusline.inactive"
            "ui.gutter"
            "ui.virtual.ruler"
          ]
          (_: {
            fg = "default";
            bg = "default";
          })
      //
        lib.genAttrs
          [
            "ui.menu.selected"
            "ui.selection"
            "ui.cursor"
            "ui.cursor.primary"
            "ui.statusline"
          ]
          (_: {
            fg = "default";
            bg = "default";
            modifiers = [ "reversed" ];
          })
      // {
        "ui.linenr.selected" = {
          fg = "default";
          modifiers = [ "bold" ];
        };
      };
    };

    yt-dlp = {
      enable = true;
      # LibreWolf uses the Firefox cookie database format.
      extraConfig = ''
        --cookies-from-browser firefox:~/.librewolf
      '';
    };
  };
}
