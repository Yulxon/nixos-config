{ ... }:
{
  environment.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    grep = "rg";
    docker = "podman";
  };

  programs = {
    bash = {
      enable = true;
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
