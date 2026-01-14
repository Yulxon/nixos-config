{ ... }:
{
  environment.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
    };
    lazygit.enable = true;
  };

}
