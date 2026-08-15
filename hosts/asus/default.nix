{ flake, pkgs, ... }:
let
  sls-steam = flake.inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam;
in
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
    package = pkgs.steam.override {
      extraEnv.LD_AUDIT = "${sls-steam}/library-inject.so:${sls-steam}/SLSsteam.so";
    };
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
