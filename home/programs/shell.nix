{ ... }:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/.local/bin:$HOME/.config/emacs/bin:$HOME/.cargo/bin"
        export EDITOR="vim"
        alias ls="eza"
        alias ll="eza -l"
        alias grep="rg"
        alias docker="podman"
      '';
    };

    # Better shell prmot!
    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

}
