{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "up" ''
      set -euo pipefail

      run() {
          echo "> $1"
          local name=$1
          shift
          "$@" || echo "$name failed, continuing..."
      }

      run "flatpak" ${pkgs.flatpak}/bin/flatpak update -y

      run "distrobox" ${pkgs.distrobox}/bin/distrobox upgrade --all

      run "tldr" ${pkgs.tealdeer}/bin/tldr --update

      run "doom" bash -c "$HOME/.config/emacs/bin/doom upgrade"

      run "flake" bash -c "
          cd ~/.config/nixos-config
          ${pkgs.nix}/bin/nix flake update --commit-lock-file
          cd - > /dev/null
      "
    '')
  ];
}
