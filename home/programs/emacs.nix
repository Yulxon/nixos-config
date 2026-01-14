{ pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs

    libtool # (vterm) 编译必需

    nil # Nix LSP 服务端
    nixfmt-rfc-style # 推荐的 Nix 格式化工具

    prettierd # (format) 更快的格式化守护进程
  ];
}
