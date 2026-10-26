{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      hwdec = "auto-safe";
      screenshot-dir = "~/Pictures/mpv";
      script = toString (
        pkgs.writeText "rose-pine-appearance.lua" ''
          local mp = require "mp"
          local current, pending
          local function update()
            if pending then return end
            pending = true
            mp.command_native_async({
              name = "subprocess",
              args = { "${pkgs.glib}/bin/gsettings", "get",
                "org.gnome.desktop.interface", "color-scheme" },
              capture_stdout = true,
              capture_stderr = true,
              playback_only = false,
            }, function(success, result)
              pending = false
              if not success or result.status ~= 0 then return end
              local dark = result.stdout:find("prefer-dark", 1, true) ~= nil
              if dark == current then return end
              current = dark
              local base = dark and "#191724" or "#faf4ed"
              local text = dark and "#e0def4" or "#575279"
              local surface = dark and "#1f1d2e" or "#fffaf3"
              mp.set_property("options/osd-color", text)
              mp.set_property("options/osd-back-color", surface)
              mp.set_property("options/osd-border-color", base)
              mp.set_property("options/osd-shadow-color", base)
            end)
          end
          update()
          -- Asynchronous polling also updates paused players without blocking playback.
          mp.add_periodic_timer(2, update)
        ''
      );
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
}
