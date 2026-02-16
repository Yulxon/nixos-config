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

    python3

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

    ispell
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

  services.emacs.enable = true;
  services.emacs.client.enable = true;
}
