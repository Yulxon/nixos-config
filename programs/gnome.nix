{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    hide-top-bar
  ];

  # home.sessionVariables = {
  #   GSK_RENDERER = "ngl";
  # };
}
