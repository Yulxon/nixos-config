{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    tiling-assistant
    hide-top-bar
    user-themes
  ];

  home.sessionVariables = {
    GSK_RENDERER = "ngl";
  };
}
