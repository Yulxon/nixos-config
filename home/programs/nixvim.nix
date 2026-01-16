{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };

    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true; # 确保安装了各种语言的语法解析器
        settings.highlight.enable = true;
      };
      which-key = {
        enable = true;
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
        extensions = {
          file-browser.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          clangd.enable = true; # C/C++
          pyright.enable = true; # Python
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          yamlls.enable = true; # YAML
          jsonls.enable = true; # JSON

          nil_ls.enable = true;
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
          };
        };
      };

      none-ls = {
        enable = true;
        sources.formatting.nixpkgs_fmt.enable = true;
      };

      neo-tree.enable = true;
      toggleterm = {
        enable = true;
        settings.open_mapping = "[[<C-t>]]";
      };
    };

    globals.mapleader = " ";
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
      }
    ];
  };
}
