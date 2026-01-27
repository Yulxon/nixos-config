{ ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs = {
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    nix-index-database.comma.enable = true;

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
