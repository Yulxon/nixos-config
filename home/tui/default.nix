{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  llm = inputs.llm-agents.packages.${system};
in
{
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
  ];

  home.packages =
    (with pkgs; [
      gnumake
      clang
      clang-tools
      nixd
      nixfmt
      python3
      rust-analyzer

      bubblewrap
    ])
    ++ (with llm; [
      codex
      dsh
    ]);

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
  };
}
