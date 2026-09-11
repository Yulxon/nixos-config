{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    distrobox

    source-code-pro

    gnumake
    clang
    clang-tools
    nixd
    nixfmt
    python3
    rust-analyzer
    nodejs
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
  };
}
