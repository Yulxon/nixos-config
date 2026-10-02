{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      gh = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/id_ed25519";
        ForwardAgent = true;
      };
      s = {
        HostName = "s.oui.moe";
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
        IdentityAgent = "none";
        SetEnv.TERM = "xterm-256color";
      };
    };
  };

  # Replace the existing files when adopting them into Home Manager.
  home.file.".ssh/config".force = true;
  home.file.".ssh/id_ed25519.pub" = {
    source = ../../config/ssh-id_ed25519.pub;
    force = true;
  };
}
