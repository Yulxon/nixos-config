{ ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./gui.nix
  ];

  nix = {
    optimise.automatic = true;
    settings = {
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
  # programs.nix-ld.enable = true;

}
