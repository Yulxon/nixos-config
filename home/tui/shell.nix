{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # "check if parent process is not fish" && "make nested shells work properly"
        if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
            # set $SHELL for better integration with programs like nix shell, tmux, etc.
            SHELL=${pkgs.fish}/bin/fish exec fish
        fi
      '';
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting "" # Disable greeting
      '';
      plugins = with pkgs.fishPlugins; [
        {
          name = "grc";
          src = grc.src;
        }
        {
          name = "autopair";
          src = autopair.src;
        }
        {
          name = "fzf-fish";
          src = fzf-fish.src;
        }
      ];
    };

    starship.enable = true;

    fzf.enable = true; # ctrl+r
    zoxide.enable = true; # z to cd

    tmux = {
      enable = false;
      shortcut = "a";
      baseIndex = 1;
    };
  };

  home.packages = with pkgs; [ grc ]; # fishPlugins.grc
}
