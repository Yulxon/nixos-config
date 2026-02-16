{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting "" # Disable greeting
      '';
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
    };

    starship.enable = true;

    fzf.enable = true; # ctrl+r
    zoxide.enable = true; # z to cd
  };

  home.packages = with pkgs; [ grc ]; # fishPlugins.grc
}
