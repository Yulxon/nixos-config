{ pkgs, lib, ... }:

{
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = alphabetical-app-grid; }
      { package = appindicator; }
      { package = caffeine; }
      { package = hide-top-bar; }
      { package = user-themes; }
    ];
  };

  # home.sessionVariables = {
  #   GSK_RENDERER = "gl";
  # };

  dconf.settings = {
    "org/gnome/software" = {
      first-run = false;
    };
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };

    "system/proxy" = {
      mode = "manual";
    };
    "system/proxy/http" = {
      host = "127.0.0.1";
      port = 7890;
    };
    "system/proxy/https" = {
      host = "127.0.0.1";
      port = 7890;
    };
    "system/proxy/socks" = {
      host = "127.0.0.1";
      port = 7890;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "teal";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = true;
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ])
        (lib.hm.gvariant.mkTuple [
          "ibus"
          "rime"
        ])
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>f" ];
      www = [ "<Super>b" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kitty";
      name = "kitty";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Super>F1" ];
      switch-to-workspace-2 = [ "<Super>F2" ];
      switch-to-workspace-3 = [ "<Super>F3" ];
      switch-to-workspace-4 = [ "<Super>F4" ];
      close = [
        "<Alt>F4"
        "<Super>q"
      ];
    };

    # "org/gnome/shell/app-switcher" = {
    #   current-workspace-only = true;
    # };

    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
  };
}
