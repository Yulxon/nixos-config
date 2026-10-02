{ inputs, pkgs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age = {
      keyFile = "/home/chumi/.config/sops/age/keys.txt";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];

    secrets = {
      mihomo-proxies = {
        sopsFile = ../secret/mihomo-proxies.json;
        format = "binary";
      };
      ssh-id_ed25519 = {
        sopsFile = ../secret/ssh-id_ed25519.json;
        format = "binary";
        owner = "chumi";
        mode = "0600";
        path = "/home/chumi/.ssh/id_ed25519";
      };
    };
  };

  systemd.tmpfiles.rules = [ "d /home/chumi/.ssh 0700 chumi users -" ];
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
