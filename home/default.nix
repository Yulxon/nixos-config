{ ... }:

{
  imports = [
    ./gui
    ./headcrab
    ./rime
    ./scripts
    ./tui
  ];

  home = {
    username = "chumi";
    homeDirectory = "/home/chumi";
    stateVersion = "26.05";
  };
  programs.home-manager.enable = true;

  news.display = "silent";
}
