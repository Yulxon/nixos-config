{ ... }:
{
  imports = [
    ./emacs.nix
    ./gnome.nix
    # ./nixvim.nix
  ];
  catppuccin.enable = true;
}
