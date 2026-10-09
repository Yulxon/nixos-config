{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-fx506hm
  ];

  hardware.asus.battery = {
    chargeUpto = 60;
    enableChargeUptoScript = true;
  };

  networking.hostName = "asus";
  # Compatibility version: keep the established value across NixOS upgrades.
  system.stateVersion = "26.05";
}
