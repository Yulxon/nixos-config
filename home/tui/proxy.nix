{ config, pkgs, ... }:
{
  home.sessionVariables = {
    http_proxy = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
    ftp_proxy = "http://127.0.0.1:7890";
    all_proxy = "socks5://127.0.0.1:7891";
    no_proxy = "127.0.0.1,localhost,internal.domain";
  };

  home.packages = [ pkgs.mihomo ];

  systemd.user.services.mihomo = {
    Unit = {
      Description = "Mihomo Proxy Service";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.mihomo}/bin/mihomo -d ${config.home.homeDirectory}/.config/mihomo";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
