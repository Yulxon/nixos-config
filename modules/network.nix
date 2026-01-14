{ config, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  services = {
    dae = {
      enable = true;
      configFile = "/home/chumi/.var/network/config.dae";
    };

  };
}
