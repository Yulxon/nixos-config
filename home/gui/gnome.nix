{ pkgs, lib, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions =
      with pkgs.gnomeExtensions;
      map (package: { inherit package; }) [
        alphabetical-app-grid
        appindicator
        caffeine
        hide-top-bar
        light-style
        user-themes
      ];
  };

  dconf.settings = {
    # IBus 候选框使用 Shell 主题；固定的第三方样式会覆盖原生明暗切换。
    "org/gnome/shell/extensions/user-theme" = {
      name = "";
    };

    "org/gnome/software" = {
      first-run = false;
    };

    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };

    "org/gnome/desktop/interface" = {
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
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "terminal";
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

    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
  };

}
