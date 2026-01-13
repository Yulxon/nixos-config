{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty # Terminal emulator
    mpv # Media player
    vscodium.fhs # Code editor (FHS compliant)
    distrobox # Container manager

    eza # Modern `ls`
    ripgrep # Fast search (`rg`)
    fd # Fast find
    fzf # Fuzzy finder
    grc # Generic coloriser
    file # File type detection
    tree
    tealdeer

    fastfetchMinimal # System info
    btop # Resource monitor
    nh # Nix helper

    hugo # Static site generator

    nerd-fonts.symbols-only
  ];
}
