{ ... }:
{
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "26.05";

  users.users.chumi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
