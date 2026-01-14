{ config, ... }:
{
  time.timeZone = "Asia/Shanghai";

  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  zramSwap.enable = true;

}
