{ pkgs, ... }:
{
  imports = [
    ./fetch.nix
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    vscodium.fhs
    distrobox
    hugo

    source-code-pro
    public-sans
    eb-garamond
    lxgw-wenkai
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
    helix.enable = true;
  };
}
