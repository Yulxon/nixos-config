{ flake, ... }:
{
  imports = [
    ./hardware-configuration.nix
    flake.inputs.nixos-hardware.nixosModules.xiaomi-redmibook-16-pro-2024
  ];

  networking.hostName = "redmi";
}
