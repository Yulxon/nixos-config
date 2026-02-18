{ pkgs, ... }:
{
  imports = [
    ./fetch.nix
    ./git.nix
    ./nix.nix
    ./proxy.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    vscodium.fhs
    distrobox
    hugo

  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
  };
}
