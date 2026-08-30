{ flake, ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./proxy.nix
    ./gui.nix
  ];

  # claude-code (github:sadjow/claude-code-nix) registered at system level:
  # home-manager runs with useGlobalPkgs, so user pkgs come from here.
  nixpkgs.overlays = [ flake.inputs.claude-code.overlays.default ];

  nix = {
    optimise.automatic = true;
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://catppuccin.cachix.org"
        "https://claude-code.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
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
