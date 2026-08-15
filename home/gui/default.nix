{ flake, pkgs, ... }:
{
  imports = [
    ./gnome.nix
    ./kitty.nix
    ./mpv.nix
    ./nixvim.nix
    ./vscodium.nix

    flake.inputs.catppuccin.homeModules.catppuccin
  ];

  home.packages = with pkgs; [
    pince # Gaming
  ];

  catppuccin = {
    fish.enable = true;
    starship.enable = true;
    kitty.enable = true;
  };

  programs.librewolf.enable = true;
}
