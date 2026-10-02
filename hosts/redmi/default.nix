{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.xiaomi-redmibook-16-pro-2024
  ];

  networking.hostName = "redmi";
}
