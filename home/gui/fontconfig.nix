{
  lib,
  pkgs,
  ...
}:

let
  languageFonts = [
    {
      lang = "zh";
      suffix = "SC";
    }
    {
      lang = "zh-cn";
      suffix = "SC";
    }
    {
      lang = "zh-sg";
      suffix = "SC";
    }
    {
      lang = "zh-my";
      suffix = "SC";
    }
    {
      lang = "zh-tw";
      suffix = "TC";
    }
    {
      lang = "zh-hk";
      suffix = "HK";
    }
    {
      lang = "zh-mo";
      suffix = "HK";
    }
    {
      lang = "ja";
      suffix = "JP";
    }
    {
      lang = "ko";
      suffix = "KR";
    }
  ];

  languageRule =
    name:
    { lang, suffix }:
    ''
      <match target="pattern">
        <test name="family" compare="eq"><string>Noto ${name}</string></test>
        <test name="lang" compare="eq"><string>${lang}</string></test>
        <edit name="family" mode="assign" binding="same">
          <string>Noto ${name} CJK ${suffix}</string>
        </edit>
      </match>
    '';
in
{
  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    twemoji-color-font
    nerd-fonts.symbols-only
    source-code-pro
    iosevka-bin

    lxgw-wenkai
  ];

  xdg.dataFile."flatpak/overrides/global".text = ''
    [Context]
    filesystems=/nix/store:ro;xdg-config/fontconfig:ro;
  '';

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
        "Twemoji"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
        "Twemoji"
      ];
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
        "Symbols Nerd Font"
        "Twemoji"
      ];
      emoji = [ "Twemoji" ];
    };
    configFile.noto-cjk = {
      enable = true;
      priority = 90;
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          ${lib.concatMapStringsSep "\n" (languageRule "Sans") languageFonts}
          ${lib.concatMapStringsSep "\n" (languageRule "Serif") languageFonts}
          ${lib.concatMapStringsSep "\n" (languageRule "Sans Mono") languageFonts}
        </fontconfig>
      '';
    };
  };
}
