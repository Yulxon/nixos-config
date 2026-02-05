{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libtool # (vterm) 编译必需

    (aspellWithDicts (dicts: [
      dicts.en
      dicts.en-computers
    ])) # 拼写检查
    languagetool # (grammar) 语法检查引擎

    nil # Nix LSP 服务端
    nixfmt-rfc-style # 推荐的 Nix 格式化工具

    clang-tools # 提供 clangd (LSP)
    cmake
    gnumake
    gcc
    libtool

    (python3.withPackages (
      ps: with ps; [
        pyright # LSP 服务端
        black # 格式化
        isort # 整理 import
        pipenv
        pytest # 测试支持
      ]
    ))

    rust-analyzer
    cargo
    clippy
    rustc
    rustfmt

    nodePackages.bash-language-server # LSP
    shellcheck # 语法检查
    shfmt # 格式化

    nodePackages.vscode-langservers-extracted # 包含 JSON/HTML/CSS LSP
    nodePackages.yaml-language-server # YAML LSP

    pandoc # 文档转换
    prettierd # (format) 更快的格式化守护进程
    multimarkdown
  ];

  # --- 增强程序配置 ---
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };

    # 配合 Doom 的 (tools direnv)
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # 配合 Doom 的 (tools tmux)
    tmux = {
      enable = true;
      shortcut = "a";
      # baseIndex = 1;
    };
  };
}
