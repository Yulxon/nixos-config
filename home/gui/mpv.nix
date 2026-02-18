{ ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      hwdec = "auto-safe";
      # ytdl-raw-options = "cookies-from-browser=firefox:~/.var/app/io.gitlab.librewolf-community/.librewolf/";
      screenshot-dir = "~/Pictures/mpv";
    };

    bindings = {
      "Alt+1" = "set window-scale 1";
      "Alt+2" = "set window-scale 0.83";
      "Alt+3" = "set window-scale 0.66";
      "Alt+4" = "set window-scale 0.5";

      "Alt+9" = "set window-scale 2";
      "Alt+8" = "set window-scale 3";
      "Alt+7" = "set window-scale 4";
    };
  };

  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      --cookies-from-browser firefox:~/.var/app/io.gitlab.librewolf-community/.librewolf/
    '';
  };
}
