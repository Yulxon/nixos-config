{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./fetch.nix
    ./nix.nix
    ./proxy.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    vscodium.fhs
    distrobox
    hugo
    tealdeer

  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
  };
}
