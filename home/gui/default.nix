{ flake, ... }:
{
  imports = [
    ./fontconfig.nix
    ./gnome.nix
    ./kitty.nix
    ./librewolf.nix
    ./mpv.nix
    ./nixvim.nix
    ./rime.nix
    ./vscodium.nix

    flake.inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    fish.enable = true;
    starship.enable = true;
    kitty.enable = true;
  };
}
