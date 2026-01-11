{ ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  programs = {
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
      config.global = {
        hide_env_diff = true;
      };
    };
  };
}
