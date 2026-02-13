{ ... }:
{
  imports = [
    ./emacs.nix
    ./gnome.nix
    ./kitty.nix
    ./mpv.nix
    # ./nixvim.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
