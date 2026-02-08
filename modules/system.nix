{ pkgs, ... }:
{
  time.timeZone = "Asia/Shanghai";

  system = {
    stateVersion = "25.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  users.users.chumi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      git
      vim
      wget
    ];
    variables.EDITOR = "vim";
  };

}
