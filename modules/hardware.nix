{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  zramSwap.enable = true;

  security.rtkit.enable = true; # for Pipewire, use the realtime scheduler
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    journald.extraConfig = "SystemMaxUse=100M";
  };
}
