{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    # 1. 主题设置 (保持不变)
    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };

    # 2. 语言支持 (LSP & Treesitter)
    plugins = {
      treesitter = {
        enable = true;
        nixGrammars = true; # 确保安装了各种语言的语法解析器
        settings.highlight.enable = true;
      };

      lsp = {
        enable = true;
        servers = {
          # --- 原有语言 ---
          clangd.enable = true; # C/C++
          pyright.enable = true; # Python
          rust_analyzer = {
            # Rust
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          yamlls.enable = true; # YAML
          jsonls.enable = true; # JSON

          # --- 新增 Nix 支持 ---
          nixd.enable = true; # 推荐使用 nixd，功能非常强大
          # 或者你也可以选择使用 nil:
          # nil_ls.enable = true;
        };
      };

      # 3. 自动补全 (保持不变)
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

      # 4. 格式化 (新增：让 Nix 代码整洁)
      none-ls = {
        enable = true;
        sources.formatting.nixpkgs_fmt.enable = true;
      };

      # 5. 其他功能 (文件管理、终端)
      neo-tree.enable = true;
      toggleterm = {
        enable = true;
        settings.open_mapping = "[[<C-t>]]";
      };
    };

    # 快捷键与 Leader 键 (保持不变)
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
