{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # gnome.core-apps.enable = false;

    flatpak.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    # gnome-console
    # decibels
    # showtime
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-connections
    simple-scan
    snapshot
    yelp
    gnome-tour
    # gnome-software
    # gnome-console
  ];

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

  fonts.packages = with pkgs; [
    noto-fonts
    maple-mono.NF-CN
    nerd-fonts.symbols-only
    iosevka-bin
    lxgw-wenkai
    lxgw-wenkai-tc
    cns11643-kai

    google-fonts

  ];

  # Controller device permissions and uinput support for Steam Input.
  hardware.steam-hardware.enable = true;
}
