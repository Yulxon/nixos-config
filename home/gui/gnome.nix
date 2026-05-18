{ pkgs, lib, ... }:

{
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = alphabetical-app-grid; }
      { package = appindicator; }
      { package = caffeine; }
      { package = tiling-assistant; }
      { package = hide-top-bar; }
      { package = user-themes; }
    ];
  };

  home.sessionVariables = {
    GSK_RENDERER = "gl";
  };

  dconf.settings = {
    "org/gnome/software" = {
      first-run = false;
    };
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };

    # 系统代理设置 (Manual: 127.0.0.1:7890/7891)
    # "system/proxy" = {
    #   mode = "manual";
    # };
    # "system/proxy/http" = {
    #   host = "127.0.0.1";
    #   port = 7890;
    # };
    # "system/proxy/https" = {
    #   host = "127.0.0.1";
    #   port = 7890;
    # };
    # "system/proxy/socks" = {
    #   host = "127.0.0.1";
    #   port = 7891;
    # };

    # GNOME 桌面界面与外观
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "teal";
      # text-scaling-factor = 1.125;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      # edge-tiling = false; # 被 Tiling Assistant 接管或禁用
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    # 输入法设置 (US 键盘 + Rime)
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

    # 健康与休息提醒 (Wellbeing)
    "org/gnome/desktop/break-reminders/movement" = {
      duration-seconds = lib.hm.gvariant.mkUint32 300;
      interval-seconds = lib.hm.gvariant.mkUint32 1800;
      play-sound = false;
    };
    "org/gnome/desktop/break-reminders/eyesight" = {
      play-sound = false;
    };

    # 快捷键：系统默认功能改键
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>f" ];
      www = [ "<Super>b" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # 自定义快捷键 (Kitty & Emacs)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" = {
      binding = "<Super>t";
      command = "kitty";
      name = "kitty";
    };

    # 快捷键：工作区切换 (Super+1234)
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      # maximize = [ ]; # 记录中已置空
      # unmaximize = [ ];
      close = [
        "<Alt>F4"
        "<Super>q"
      ];
    };

    # 屏蔽 Shell 默认的 Super+数字 切换应用，防止与切换工作区冲突
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
    };

    # GNOME Extensions 启用列表
    "org/gnome/shell" = {
      favorite-apps = [ ]; # 记录中最后将其清空了
    };

    # Dconf Editor 设置
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
  };
}
