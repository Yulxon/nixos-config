{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    hide-top-bar
  ];

  # home.sessionVariables = {
  #   GSK_RENDERER = "ngl";
  # };
}
