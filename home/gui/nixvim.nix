{ flake, ... }:
{
  imports = [
    flake.inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    globals.mapleader = " ";
    clipboard.register = "unnamedplus";

    plugins = {
      comment.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      which-key.enable = true;
      neo-tree.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            python = [ "black" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
          };
        };
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        settings.highlight.enable = true;
      };

      noice = {
        enable = true;
        settings.presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            options.desc = "file finder";
            action = "find_files";
          };
          "<leader>fg" = {
            options.desc = "find via grep";
            action = "live_grep";
          };
        };
        extensions.file-browser.enable = true;
      };

      lsp = {
        enable = true;
        servers = {
          clangd.enable = true; # C/C++
          pyright.enable = true; # Python
          yamlls.enable = true; # YAML
          jsonls.enable = true; # JSON
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      toggleterm = {
        enable = true;
        settings.open_mapping = "[[<C-t>]]";
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
      }
    ];
  };
}
