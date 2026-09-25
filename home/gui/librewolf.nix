{ ... }:

{
  programs.librewolf = {
    enable = true;

    # Keep the existing profile and its browser-managed data in place.
    configPath = ".config/librewolf/librewolf";

    profiles.default = {
      id = 0;
      path = "qnxhhnxt.default";
      isDefault = true;

      settings = {
        "browser.contentblocking.category" = "strict";
        "browser.newtabpage.activity-stream.hideLogo" = true;
        "browser.search.suggest.enabled" = true;
        "browser.search.suggest.enabled.private" = true;
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "browser.translations.automaticallyPopup" = false;
        "browser.translations.neverTranslateLanguages" = "zh-Hans,ja";
        "browser.urlbar.suggest.searches" = true;
        "intl.accept_languages" = "en";
        "privacy.history.custom" = true;
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "sidebar.main.tools" = "history,{446900e4-71c2-419f-a6a7-df9c091e268b}";
        "sidebar.visibility" = "hide-on-close";
      };
    };

    policies.ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
      # Bitwarden Password Manager
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      };
      "addon@darkreader.org" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      };
    };
  };

  # Home Manager takes over the existing, otherwise unmanaged profiles.ini.
  home.file.".config/librewolf/librewolf/profiles.ini".force = true;
}
