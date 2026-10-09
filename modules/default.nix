{ ... }:
{
  imports = [
    ./system.nix
    ./graphical.nix
  ];

  time.timeZone = "Asia/Shanghai";

  nix = {
    optimise.automatic = true;
    settings = {
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store?priority=10"
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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

  fileSystems."/" = {
    options = [
      "noatime"
      "compress=zstd"
    ];
  };
  fileSystems."/home" = {
    options = [
      "noatime"
      "compress=zstd"
    ];
  };
  fileSystems."/nix" = {
    options = [
      "noatime"
      "compress=zstd"
    ];
  };

}
