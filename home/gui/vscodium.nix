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
        ms-vscode.cpptools
        ms-python.python
        ms-python.vscode-pylance
        rust-lang.rust-analyzer
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";

        "rust-analyzer.server.path" = "rust-analyzer";

        "python.languageServer" = "Pylance";

        "editor.formatOnSave" = true;
        "editor.fontSize" = 14;
        "terminal.integrated.initialHint" = false;
      };
    };
  };
}
