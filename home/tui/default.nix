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

      bubblewrap # codex need
    ])
    ++ (with llm; [
      (dsh.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace \
            $out/lib/node_modules/@deepseek-ai/dsh/node_modules/@deepseek-ai/dsh-app-boot/lib/index.js \
            --replace-fail 'const addon = createRequire(import.meta.url)("node-addon-require-builtin");' \
              'const addon = { requireBuiltin: createRequire(import.meta.url) };'
        '';
      }))
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
      extraConfig = ''
        --cookies-from-browser chrome:~/.var/app/com.google.Chrome/config/google-chrome/Default
      '';
    };
  };
}
