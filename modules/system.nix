{ pkgs, ... }:
{
  time.timeZone = "Asia/Shanghai";

  security.rtkit.enable = true; # for Pipewire, use the realtime scheduler
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    journald.extraConfig = "SystemMaxUse=100M";

    mihomo = {
      enable = true;
      tunMode = false;
      webui = pkgs.metacubexd;
      configFile = "/home/chumi/.config/mihomo/config.yaml";
    };
  };

  users.users.chumi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs.nix-ld.enable = true;
}
