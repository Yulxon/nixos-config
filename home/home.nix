{ ... }:

{
  imports = [
    ./gui
    ./tui
  ];

  home = {
    username = "chumi";
    homeDirectory = "/home/chumi";
    stateVersion = "25.05"; # Please read the comment before changing.
  };
  programs.home-manager.enable = true;

  news.display = "silent";

  services.home-manager = {
    autoUpgrade = {
      enable = true;
      frequency = "weekly";
    };
    autoExpire = {
      enable = true;
      frequency = "weekly";
    };
  };
}
