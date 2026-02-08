{ ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "Yulxon";
        user.email = "2053395074@qq.com";
      };
    };
    lazygit.enable = true;
  };

}
