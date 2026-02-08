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
    hashedPassword = "$6$yxwzQrlKxnzNiDu/$VNew68h86pEhRZbyNOr6KM8HsAfpZPoCEyoEuuy9Z2ok3OLOUNE0YAb3Q9XZf8PbGS2SEalN.ft08bVbNPEWt0";
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
