{ pkgs, ... }:
{
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  system = {
    stateVersion = "25.11";
  };

  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.mihomo = {
    enable = true;
    tunMode = false;
    webui = pkgs.metacubexd;
    configFile = "/home/chumi/.config/mihomo/config.yaml";
  };

  # services.dae = {
  #   enable = true;
  #   configFile = "/home/chumi/.var/network/config.dae";
  # };

  environment = {
    systemPackages = with pkgs; [
      git
      vim
      wget
    ];
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

}
