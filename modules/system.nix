{ pkgs, ... }:
{
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  system = {
    stateVersion = "25.11";
  };

  services.mihomo = {
    enable = true;
    # tunMode = true;
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
