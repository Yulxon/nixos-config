{ flake, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    flake.inputs.nixos-hardware.nixosModules.asus-fx506hm
  ];

  hardware.asus.battery = {
    chargeUpto = 60;
    enableChargeUptoScript = true;
  };

  programs.steam = {
    enable = true;
    # SLSsteam injection is handled by the home-manager `headcrab` module
    # (patched ~/.steam/steam/steam.sh), so no extraEnv override here.
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    protontricks.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
}
