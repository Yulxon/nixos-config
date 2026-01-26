{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    hide-top-bar
    user-themes
  ];

  home.sessionVariables = {
    GSK_RENDERER = "ngl";
  };
}
