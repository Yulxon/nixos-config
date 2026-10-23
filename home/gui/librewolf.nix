{ ... }:
{
  programs.librewolf = {
    enable = true;

    settings = {
      "browser.privatebrowsing.autostart" = false;
      "places.history.enabled" = true;
      "network.cookie.lifetimePolicy" = 0;
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.offlineApps" = false;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
    };

    policies = {
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;

      Preferences = {
        "browser.translations.automaticallyPopup" = {
          Value = false;
        };
        "browser.newtabpage.activity-stream.hideLogo" = {
          Value = true;
        };
      };

      DisableFirefoxAccounts = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;

      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredPocket = false;
        Pocket = false;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
    };
  };
}
