{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix
    nil # Nix language server
    nixpkgs-fmt
    nixfmt

    # C
    cmake
    clang-tools
    gnumake
    gcc
    libtool

    # Python
    python3
    black
    isort
    pipenv

    #Rust
    rust-analyzer
    cargo
    clippy
    rustc

    # Shell
    shfmt
    shellcheck

    ispell
    prettierd
    pandoc
  ];

  programs = {
    emacs.enable = true;
  };
}
