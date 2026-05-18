{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    flatpak.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    decibels
    epiphany
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    gnome-connections
    showtime
    simple-scan
    snapshot
    yelp
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
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
            # rime-moegirl
            rime-zhwiki
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
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        monospace = [
          "Noto Sans Mono"
          "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

}
