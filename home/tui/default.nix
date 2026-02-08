{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    kitty # Terminal emulator
    mpv # Media player
    yt-dlp
    ffmpeg
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
