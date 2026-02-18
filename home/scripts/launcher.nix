{ pkgs, ... }:

{

  home.packages = [
    (pkgs.writeShellScriptBin "lwt" ''
      T=$(mktemp -d)
      flatpak run --filesystem="$T" io.gitlab.librewolf-community --profile "$T" --no-remote
      rm -rf "$T"
    '')
  ];
}
