{ pkgs, ... }:

{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium.fhs;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        ms-vscode.cpptools
        ms-python.python
        ms-python.vscode-pylance
        rust-lang.rust-analyzer
        # chris-hayes.chatgpt-reborn
      ];

      userSettings = {
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
