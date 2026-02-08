{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style

    clang-tools
    cmake
    gnumake
    gcc
    libtool

    rust-analyzer
    cargo
    clippy
    rustc
    rustfmt

    shfmt
    shellcheck

    pandoc
    prettierd
    multimarkdown
  ];

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tmux = {
      enable = true;
      # shortcut = "a";
      # baseIndex = 1;
    };
  };
}
