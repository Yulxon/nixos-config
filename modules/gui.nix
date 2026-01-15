{ config, pkgs, ... }:
{
  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      xkb.layout = "us";
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    flatpak.enable = true;

  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  virtualisation.podman.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ rime ];
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-code-pro
      nerd-fonts.fira-code
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
