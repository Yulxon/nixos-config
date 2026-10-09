{ pkgs, ... }:
{
  imports = [
    ./fontconfig.nix
    ./gnome.nix
    ./rime.nix
  ];

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    # iosevka-bin

    # lxgw-wenkai
    maple-mono.NF-CN
  ];
}
