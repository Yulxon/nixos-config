{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    vscodium.fhs
    distrobox
    fastfetchMinimal
    hugo

    ripgrep
    fd
    grc
    file
    tealdeer

    nerd-fonts.symbols-only
  ];

  programs = {
    zoxide.enable = true;
    bat.enable = true;
    btop.enable = true;
    fzf.enable = true;
    jq.enable = true;
    nh = {
      enable = true;
      flake = "/home/chumi/.config/nixos-config/";
    };
  };

}
