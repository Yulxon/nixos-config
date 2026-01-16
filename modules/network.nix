{ config, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };

  services = {
    dae = {
      enable = false;
      configFile = "/home/chumi/.var/network/config.dae";
    };

    mihomo = {
      enable = true;
      configFile = "/home/chumi/.var/config.yaml";
    };
  };
}
