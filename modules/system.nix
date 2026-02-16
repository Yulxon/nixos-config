{ pkgs, ... }:
{
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  system = {
    stateVersion = "25.11";
  };

  programs.fish.enable = true;
  users.users.chumi = {
    isNormalUser = true;
    shell = pkgs.fish;
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
