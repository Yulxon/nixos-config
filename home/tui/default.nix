{ flake, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    gnumake
    clang
    clang-tools
    nixd
    nixfmt
    python3
    rust-analyzer
    nodejs

    flake.inputs.codex-nix.packages.${pkgs.stdenv.system}.default
    bubblewrap
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
  };
}
