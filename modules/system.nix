{ pkgs, ... }:
{
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  system = {
    stateVersion = "25.11";
  };

  # networking.proxy.default = "http://127.0.0.1:7890/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = "/home/chumi/.config/mihomo/config.yaml";
  };

  users.users.chumi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

}
