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

    clang
    clang-tools
    nixd
    nixfmt
    rust-analyzer

  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
  };
}
