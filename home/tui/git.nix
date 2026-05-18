{ pkgs, ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  programs = {
    git = {
      enable = true;
      userName = "Yulxon";
      userEmail = "2053395074@qq.com";
      lfs.enable = true;
    };
    lazygit.enable = true;

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
      gitCredentialHelper.enable = true;
    };
  };
}
