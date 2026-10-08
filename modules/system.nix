{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 6;
      efi.canTouchEfiVariables = true;
    };
  };

  zramSwap.enable = true;

  programs.nix-ld.enable = true;

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
      tunMode = true;
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

}
