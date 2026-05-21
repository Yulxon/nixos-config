{ inputs, ... }:
{
  imports = [
    ./gnome.nix
    ./kitty.nix
    ./mpv.nix
    ./nixvim.nix

    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
