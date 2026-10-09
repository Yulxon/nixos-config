{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.xiaomi-redmibook-16-pro-2024
  ];

  networking.hostName = "redmi";
  # Compatibility version: keep the established value across NixOS upgrades.
  system.stateVersion = "26.05";
}
