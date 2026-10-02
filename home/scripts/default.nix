{
  pkgs,
  osConfig,
  ...
}:

let
  up = pkgs.writeShellScriptBin "up" ''
    set -euo pipefail

    usage() {
      echo "usage: up [-r]"
      echo "  -r  rebuild the current host after updating"
    }

    if [ "$#" -gt 1 ]; then
      usage >&2
      exit 2
    fi
    case "''${1:-}" in
      "") rebuild=false ;;
      -r) rebuild=true ;;
      -h|--help) usage; exit 0 ;;
      *) usage >&2; exit 2 ;;
    esac

    flake_dir="''${UP_FLAKE_DIR:-$HOME/Projects/nixos-config}"
    flake_host="''${UP_FLAKE_HOST:-${osConfig.networking.hostName}}"
    if [ ! -d "$flake_dir" ]; then
      echo "up: flake directory not found: $flake_dir" >&2
      exit 1
    fi

    echo "== flatpak =="
    if ${pkgs.flatpak}/bin/flatpak remotes 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
      ${pkgs.flatpak}/bin/flatpak update -y
    fi

    echo "== tldr =="
    ${pkgs.tealdeer}/bin/tldr --update

    echo "== flake =="
    ${pkgs.nix}/bin/nix flake update nixpkgs home-manager --flake "$flake_dir"

    if $rebuild; then
      echo "== rebuild =="
      if [ "$(${pkgs.coreutils}/bin/id -u)" -eq 0 ]; then
        nixos-rebuild switch --flake "$flake_dir#$flake_host"
      else
        sudo nixos-rebuild switch --flake "$flake_dir#$flake_host"
      fi
    fi
  '';
in
{
  home.packages = [ up ];
}
