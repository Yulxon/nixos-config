{ ... }:

{
  imports = [
    ./gui
    ./scripts
    ./tui
  ];

  home = {
    username = "chumi";
    homeDirectory = "/home/chumi";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;

  news.display = "silent";
}
