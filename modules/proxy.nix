{ pkgs, ... }:
let
  # Shared with home/gui/gnome.nix (GNOME dconf proxy settings).
  proxy = import ../shared/proxy.nix;
in
{
  networking.proxy.default = "http://${proxy.host}:${toString proxy.port}/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = "/home/chumi/.config/mihomo/config.yaml";
  };
}
