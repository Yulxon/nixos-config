{ pkgs, ... }:

{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium.fhs;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        jnoortheen.nix-ide
      ];

      userSettings = {
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "'Iosevka', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontSize" = 14;
        "terminal.integrated.fontFamily" = "Iosevka";
        "terminal.integrated.initialHint" = false;

        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";

      };
    };
  };
}
