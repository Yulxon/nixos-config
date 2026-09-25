{ pkgs, flake, ... }:
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
            (rime-ice.overrideAttrs {
              version = "unstable-${builtins.substring 0 8 flake.inputs.rime-ice.rev}";
              src = flake.inputs.rime-ice;
            })
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
    ];
  };
}
