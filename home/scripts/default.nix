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

      run "flake" bash -c "
          cd ~/Projects/nixos-config
          ${pkgs.nix}/bin/nix flake update
          cd - > /dev/null
      "

      run "rime-ice" bash -c "
          cd ~/Projects/plum
          bash rime-install iDvel/rime-ice
          cd - > /dev/null
      "
    '')
  ];
}
