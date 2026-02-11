{ ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "Source Code Pro";
      size = 12.5;
    };

    settings = {
      # Window
      window_padding_width = 5;
      background_opacity = "1.0";
      dynamic_background_opacity = "yes";
      hide_window_decorations = "yes";
      remember_window_size = "no";
      initial_window_width = 960;
      initial_window_height = 640;

      # Tabs
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
    };

    keybindings = {
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
    };

  };
}
