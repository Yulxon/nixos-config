{ pkgs, lib, ... }:
{
  # ------------------------------------------------------------
  # GNOME Shell
  # ------------------------------------------------------------
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

  # ------------------------------------------------------------
  # 会话环境变量
  # ------------------------------------------------------------
  home.sessionVariables = {
    GSK_RENDERER = "gl";
  };

  # ------------------------------------------------------------
  # dconf 配置
  # ------------------------------------------------------------
  dconf.settings = {
    # 系统代理
    "system/proxy" = {
      mode = "manual";
      ignore-hosts = [
        "localhost"
        "127.0.0.0/8"
        "::1"
      ];
    };

    "system/proxy/http" = {
      host = "127.0.0.1";
      port = 7890;
      enabled = true;
    };

    "system/proxy/https" = {
      host = "127.0.0.1";
      port = 7890;
      enabled = true;
    };

    "system/proxy/socks" = {
      host = "127.0.0.1";
      port = 7890;
      enabled = true;
    };

    # GNOME Shell 用户主题
    "org/gnome/shell/extensions/user-theme" = {
      name = "rewaita";
    };

    # GNOME 软件
    "org/gnome/software" = {
      first-run = false;
    };

    # 清理/捐赠提示
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };

    # 桌面外观
    "org/gnome/desktop/interface" = {
      accent-color = "teal";
    };

    # Mutter 窗口管理
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = true;
    };

    # 输入法
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

    # 多媒体键与自定义快捷键
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
      command = "kitty -- fish";
      name = "terminal";
    };

    # 窗口管理快捷键
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

    # dconf-editor
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
  };
}
