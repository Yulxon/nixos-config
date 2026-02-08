{ ... }:
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
    mihomo = {
      enable = true;
      configFile = "/home/chumi/.var/config.yaml";
    };
  };
}
