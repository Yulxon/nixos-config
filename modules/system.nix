{ pkgs, ... }:
{
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  system = {
    stateVersion = "25.11";
  };

  # security.sudo-rs.enable = true;

  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.mihomo = {
    enable = true;
    webui = pkgs.metacubexd;
    configFile = "/home/chumi/.config/mihomo/config.yaml";
  };

  environment = {
    systemPackages = with pkgs; [
      git
      vim
      wget
    ];
    variables.EDITOR = "vim";
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
