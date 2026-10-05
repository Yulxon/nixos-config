{ lib, ... }:
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
        "Noto Color Emoji"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
        "Noto Color Emoji"
      ];
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
        "Symbols Nerd Font"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
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
