{ inputs, ... }:
{
  imports = [
    ./gnome.nix
    ./kitty.nix
    ./mpv.nix
    ./nixvim.nix
    ./vscodium.nix
    ./librewolf.nix

    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    fish.enable = true;
    starship.enable = true;
    kitty.enable = true;
  };
}
