{ ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "Source Code Pro";
      # size = 10.5;
    };

    settings = {
      # Window
      window_padding_width = 5;
      background_opacity = "1.0";
      dynamic_background_opacity = true;
      hide_window_decorations = true;
      remember_window_size = false;
      initial_window_width = 960;
      initial_window_height = 600;

      # Tabs
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
    };

  };
}
