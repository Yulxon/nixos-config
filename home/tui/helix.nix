{ ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      # 使用终端默认前景/背景及 ANSI 色，跟随 GNOME Console 的明暗切换。
      theme = "system";

      editor = {
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        scrolloff = 8;
        mouse = true;

        indent-guides = {
          render = true;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
    };

    themes.system = {
      inherits = "base16_terminal";
      "ui.background" = {
        fg = "default";
        bg = "default";
      };
      "ui.text" = "default";
      "ui.menu" = {
        fg = "default";
        bg = "default";
      };
      "ui.menu.selected" = {
        modifiers = [ "reversed" ];
      };
      "ui.linenr" = "default";
      "ui.linenr.selected" = {
        fg = "default";
        modifiers = [ "bold" ];
      };
      "ui.popup" = {
        fg = "default";
        bg = "default";
      };
      "ui.window" = "default";
      "ui.selection" = {
        modifiers = [ "reversed" ];
      };
      "ui.statusline" = {
        fg = "default";
        bg = "default";
        modifiers = [ "reversed" ];
      };
      "ui.statusline.inactive" = {
        fg = "default";
        bg = "default";
      };
      "ui.help" = {
        fg = "default";
        bg = "default";
      };
      "ui.cursor" = {
        modifiers = [ "reversed" ];
      };
      "ui.cursor.primary" = {
        modifiers = [ "reversed" ];
      };
      "ui.virtual.ruler" = {
        bg = "default";
      };
      "ui.gutter" = {
        bg = "default";
      };
    };
  };
}
