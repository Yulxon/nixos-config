{ ... }:
let
  light = ./wallpapers/fydeos-radiant-anatomy/light.png;
  dark = ./wallpapers/fydeos-radiant-anatomy/dark.jpg;
in
{
  dconf.settings."org/gnome/desktop/background" = {
    picture-uri = "file://${light}";
    picture-uri-dark = "file://${dark}";
    picture-options = "zoom";
  };

  # 将明暗图片作为一个壁纸条目显示在 GNOME 外观设置中。
  xdg.dataFile."gnome-background-properties/nixos-config-fydeos.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
    <wallpapers>
      <wallpaper deleted="false">
        <name>FydeOS — Radiant Anatomy</name>
        <filename>${light}</filename>
        <filename-dark>${dark}</filename-dark>
        <options>zoom</options>
        <shade_type>solid</shade_type>
        <pcolor>#000000</pcolor>
        <scolor>#000000</scolor>
      </wallpaper>
    </wallpapers>
  '';
}
