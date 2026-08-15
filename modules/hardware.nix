{ ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 6;
      efi.canTouchEfiVariables = true;
    };
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
