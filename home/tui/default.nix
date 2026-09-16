{ flake, pkgs, ... }:
{
  imports = [
    ./dsh.nix
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    distrobox

    source-code-pro

    gnumake
    clang
    clang-tools
    nixd
    nixfmt
    python3
    rust-analyzer
    nodejs

    flake.inputs.codex-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    bubblewrap
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    nh.enable = true;
  };
}
