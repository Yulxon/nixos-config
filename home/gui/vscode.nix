{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    extensions =
      with pkgs.vscode-extensions;
      [
        pnohta.adwaita-theme

        jnoortheen.nix-ide
        ms-vscode.cpptools
        ms-python.python
        ms-python.vscode-pylance
        rust-lang.rust-analyzer

        chris-hayes.chatgpt-reborn
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        /*
          {
            name = "codex";
            publisher = "publisher-name";
            version = "x.y.z";
            sha256 = "0000000000000000000000000000000000000000000000000000";
          }
        */
      ];

    userSettings = {
      "workbench.colorTheme" = "Adwaita Dark";
      "window.titleBarStyle" = "custom";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixpkgs-fmt";

      "rust-analyzer.server.path" = "rust-analyzer";

      "python.languageServer" = "Pylance";

      "editor.formatOnSave" = true;
      "editor.fontSize" = 14;
    };
  };

}
