{ ... }:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
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
