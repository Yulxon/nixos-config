{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty # Terminal emulator
    mpv # Media player
    vscodium.fhs # Code editor (FHS compliant)
    distrobox # Container manager

    ripgrep # Fast search (`rg`)
    fd # Fast find
    grc # Generic coloriser
    file # File type detection
    tree
    tealdeer
    just

    fastfetchMinimal # System info

    hugo # Static site generator

    nerd-fonts.symbols-only
  ];

  programs = {
    bat = {
      enable = true;
      config.theme = "tokyo-night";
    };
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    nh = {
      enable = true;
      flake = "/home/chumi/.config/nixos-config/";
    };
  };
}
