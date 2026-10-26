{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # Only replace Bash in a terminal, preserving commands used by GUI environment probes.
        if [[ -t 0 && -t 1 ]] && grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
            # set $SHELL for better integration with programs like nix shell, tmux, etc.
            SHELL=${pkgs.fish}/bin/fish exec fish
        fi
      '';
    };

    fish = {
      enable = true;
      # ANSI colors follow Kitty's Rosé Pine / Dawn palette.
      shellInit = ''
        fish_config theme choose default
      '';
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

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
        };
      };
      presets = [ "plain-text-symbols" ];
    };
    fzf = {
      enable = true; # ctrl+r
      colors = {
        fg = "-1";
        bg = "-1";
        "fg+" = "-1";
        "bg+" = "-1";
        hl = "3";
        "hl+" = "3";
        info = "6";
        prompt = "5";
        pointer = "5";
        marker = "2";
        spinner = "5";
        header = "6";
      };
    };
    zoxide.enable = true; # z to cd
  };

  home.packages = with pkgs; [ grc ]; # fishPlugins.grc
}
