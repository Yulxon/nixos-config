{ ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      ignores = [
        "*~"
        "*.swp"
      ];
      settings = {
        user = {
          name = "Yulxon";
          email = "2053395074@qq.com";
        };
        # init.defaultBranch = "master";
        # pull.rebase = "false";
        # http.proxy = "http://127.0.0.1:7890";
        # https.proxy = "http://127.0.0.1:7890";
      };

    };
    lazygit.enable = true;
  };

}
