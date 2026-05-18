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
    public-sans
    eb-garamond
    lxgw-wenkai
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
    bat.enable = true;
    btop.enable = true;
  };
}
