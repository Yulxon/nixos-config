{ ... }:
{
  imports = [
    ./packages.nix
    ./config.nix
    ./shell.nix
    ./nix.nix
    ./dev.nix
    ./git.nix
    ./gnome.nix
  ];
}
