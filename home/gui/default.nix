{ pkgs, ... }:
{
  imports = [
    ./fontconfig.nix
    ./gnome.nix
    ./rime.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    # twemoji-color-font
    nerd-fonts.symbols-only
    # source-code-pro
    iosevka-bin

    # lxgw-wenkai
  ];
}
