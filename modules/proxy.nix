{ pkgs, ... }:
{
  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = "/home/chumi/.config/mihomo/config.yaml";
  };
}
