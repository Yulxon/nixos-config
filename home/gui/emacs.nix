{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- 核心工具 & Doom 依赖 ---
    git
    ripgrep # Doom 必需：用于文本搜索
    fd # Doom 必需：用于快速查找文件
    sqlite # (org +roam2) 必需：用于管理节点数据库
    libtool # (vterm) 编译必需

    # --- 拼写与语法 (:checkers spell & grammar) ---
    (aspellWithDicts (dicts: [
      dicts.en
      dicts.en-computers
    ])) # 拼写检查
    languagetool # (grammar) 语法检查引擎

    # --- Nix (:lang nix +lsp) ---
    nil # Nix LSP 服务端
    nixfmt-rfc-style # 推荐的 Nix 格式化工具

    # --- C/C++ (:lang cc +lsp) ---
    clang-tools # 提供 clangd (LSP)
    cmake
    gnumake
    gcc
    libtool

    # --- Python (:lang python +lsp) ---
    (python3.withPackages (
      ps: with ps; [
        pyright # LSP 服务端
        black # 格式化
        isort # 整理 import
        pipenv
        pytest # 测试支持
      ]
    ))

    # --- Rust (:lang rust +lsp) ---
    rust-analyzer
    cargo
    clippy
    rustc
    rustfmt

    # --- Shell (:lang sh +lsp) ---
    nodePackages.bash-language-server # LSP
    shellcheck # 语法检查
    shfmt # 格式化

    # --- JSON & YAML (:lang json & yaml +lsp) ---
    nodePackages.vscode-langservers-extracted # 包含 JSON/HTML/CSS LSP
    nodePackages.yaml-language-server # YAML LSP

    # --- Markdown & 文本处理 (:lang markdown & org) ---
    pandoc # 文档转换
    prettierd # (format) 更快的格式化守护进程
    multimarkdown
  ];

  # --- 增强程序配置 ---
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs; # 建议明确版本，29及以上对 eglot 支持更好
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
