{ ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./proxy.nix
    ./gui.nix
  ];

  nix = {
    optimise.automatic = true;
    settings = {
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store?priority=10"
        "https://nix-community.cachix.org"
        "https://catppuccin.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
