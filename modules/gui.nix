{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    flatpak.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-connections
    simple-scan
    snapshot
    yelp
    gnome-tour
  ];

  virtualisation.podman.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "zh_CN.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        (rime.override {
          rimeDataPkgs = with pkgs; [
            rime-ice
            rime-zhwiki
            rime-moegirl
          ];
        })
      ];
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      twemoji-color-font
      nerd-fonts.symbols-only
      iosevka
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Sans"
          "Twemoji"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Twemoji"
        ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Symbols Nerd Font"
          "Twemoji"
        ];
        emoji = [ "Twemoji" ];
      };
    };
  };
}
