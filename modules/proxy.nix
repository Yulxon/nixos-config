{ config, pkgs, ... }:
let
  proxy = import ../config/proxy.nix;
  mihomoPublicConfig = (pkgs.formats.yaml { }).generate "mihomo-public.yaml" {
    mixed-port = proxy.port;
    allow-lan = false;
    mode = "rule";
    log-level = "warning";
    ipv6 = true;
    external-controller = "127.0.0.1:9090";
    unified-delay = true;
    geox-url = {
      geoip = "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat";
      geosite = "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat";
      mmdb = "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.metadb";
    };
    geo-auto-update = true;
    geo-update-interval = 72;
    client-fingerprint = "chrome";
    profile.store-selected = true;

    tun = {
      enable = true;
      stack = "mixed";
      auto-route = true;
      auto-redirect = true;
      strict-route = true;
      dns-hijack = [
        "any:53"
        "tcp://any:53"
      ];
    };

    sniffer = {
      enable = true;
      parse-pure-ip = true;
      override-destination = true;
      sniff = {
        TLS.ports = [
          443
          8443
        ];
        HTTP.ports = [
          80
          8080
        ];
        QUIC.ports = [
          443
          8443
        ];
      };
    };

    dns = {
      enable = true;
      ipv6 = true;
      enhanced-mode = "fake-ip";
      fake-ip-range = "198.18.0.1/16";
      listen = "127.0.0.1:1053";
      default-nameserver = [
        "223.5.5.5"
        "119.29.29.29"
      ];
      proxy-server-nameserver = [
        "223.5.5.5"
        "119.29.29.29"
      ];
      nameserver-policy = {
        "geosite:cn" = [
          "223.5.5.5"
          "119.29.29.29"
        ];
        "geosite:geolocation-!cn" = [
          "tls://8.8.4.4#DNS-Proxy"
          "tls://1.1.1.1#DNS-Proxy"
        ];
      };
      nameserver = [
        "tls://8.8.4.4#DNS-Proxy"
        "tls://1.1.1.1#DNS-Proxy"
      ];
      fallback = [
        "tls://8.8.4.4#DNS-Proxy"
        "tls://1.1.1.1#DNS-Proxy"
      ];
      fallback-filter = {
        geoip = true;
        geoip-code = "CN";
        ipcidr = [ "240.0.0.0/4" ];
      };
    };

    proxy-groups = [
      {
        name = "DNS-Proxy";
        type = "select";
        hidden = true;
        include-all = true;
        default-selected = "s";
      }
      {
        name = "Proxy";
        type = "select";
        include-all = true;
        default-selected = "s";
        proxies = [ "DIRECT" ];
      }
    ];
    rules = [
      "DOMAIN-SUFFIX,oui.moe,DIRECT"
      "GEOSITE,category-ads-all,REJECT"
      "GEOSITE,CN,DIRECT"
      "GEOIP,CN,DIRECT"
      "MATCH,Proxy"
    ];
  };
  mihomoConfigFile = "/run/mihomo-config.yaml";
  generateConfig = pkgs.writeShellScript "generate-mihomo-config" ''
    set -euo pipefail
    ${config.system.activationScripts.mihomoConfig.text}
  '';
in
{
  networking.proxy.default = "http://${proxy.host}:${toString proxy.port}/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = mihomoConfigFile;
  };

  systemd.services.mihomo.restartTriggers = [ mihomoPublicConfig ];

  # Keep subscription URLs and proxy passwords out of the world-readable Nix store.
  # Generate the complete config before systemd loads it as a private credential.
  system.activationScripts.mihomoConfig = {
    deps = [ "users" ];
    text = ''
      configDir=/home/chumi/.config/mihomo
      secretFile="$configDir/proxies.yaml"
      ${pkgs.coreutils}/bin/install -d -m 700 -o chumi -g users "$configDir"
      if [ ! -f "$secretFile" ]; then
        echo "mihomo: missing $secretFile" >&2
        exit 1
      fi
      ${pkgs.coreutils}/bin/chmod 600 "$secretFile"

      configStage="$(${pkgs.coreutils}/bin/mktemp /run/.mihomo-config.XXXXXX)"
      ${pkgs.coreutils}/bin/cat ${mihomoPublicConfig} > "$configStage"
      ${pkgs.coreutils}/bin/printf '\n' >> "$configStage"
      ${pkgs.coreutils}/bin/cat "$secretFile" >> "$configStage"
      ${pkgs.coreutils}/bin/chmod 600 "$configStage"
      if ${pkgs.diffutils}/bin/cmp -s "$configStage" ${mihomoConfigFile}; then
        ${pkgs.coreutils}/bin/rm -f "$configStage"
      else
        ${pkgs.coreutils}/bin/mv -f "$configStage" ${mihomoConfigFile}
      fi
    '';
  };

  # LoadCredential captures the file on service start, so refresh and restart it.
  systemd.paths.mihomo-config-refresh = {
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = "/home/chumi/.config/mihomo/proxies.yaml";
  };
  systemd.services.mihomo-config-refresh = {
    description = "Refresh mihomo configuration after private proxy changes";
    serviceConfig.Type = "oneshot";
    script = ''
      ${generateConfig}
      ${pkgs.systemd}/bin/systemctl try-restart mihomo.service
    '';
  };
}
