{ ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "catppuccin_mocha";

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
  };
}
