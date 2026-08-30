{ config, lib, pkgs, flake, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  cfg = config.programs.headcrab;

  # -------------------------------------------------------------------------
  # Pinned artifacts (all fetched/built at Nix build time — no runtime
  # downloads except Steam's own updater during a client downgrade).
  # -------------------------------------------------------------------------

  # SLSsteam (library-inject.so + SLSsteam.so), built from the pinned
  # github:AceSLS/SLSsteam flake input (see flake.lock).
  slssteam = flake.inputs.sls-steam.packages.${system}.sls-steam;

  # ACCELA ("Enter The Wired"), packaged by its upstream Nix flake
  # (AppImage wrapped with appimageTools).
  accela = flake.inputs.enter-the-wired.packages.${system}.default;

  # SteamNetworkingSockets patch (netsock.so) — makes FakeAppIds work in
  # some multiplayer games. Used as a per-game launch option.
  netsock = pkgs.fetchurl {
    url = "https://github.com/yesyes0649/steamnetsock-patch/releases/download/latest/fix.so";
    sha256 = "sha256-DJ0P1eX3qpCmf2r6opWb3Q8u6HUFkJw+Mb3YmeCAz1I=";
  };

  cloudredirectSo = pkgs.fetchurl {
    url = "https://github.com/Selectively11/h3adcr-b/releases/download/linux-test/cloud_redirect.so";
    sha256 = "sha256-xV6mOgJkPg34O1AkH8NqlcKkf++PcUFkeXZ/O1fXxk0=";
  };

  cloudredirectCli = pkgs.fetchurl {
    url = "https://github.com/Selectively11/h3adcr-b/releases/download/linux-test/cloud_redirect_cli";
    sha256 = "sha256-g5OY59pVvYgw2r9iNULEbnTQ8f6kz1UWAaJEll+JeC0=";
  };

  cloudredirect = pkgs.runCommand "cloudredirect" { } ''
    mkdir -p $out
    cp ${cloudredirectSo} $out/cloud_redirect.so
    cp ${cloudredirectCli} $out/cloud_redirect_cli
  '';

  # SLSsteam config template (res/config.yaml of the pinned SLSsteam rev).
  # NOTE: bump this hash together with the sls-steam input in flake.lock.
  configTemplate = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/AceSLS/SLSsteam/65b6ee1ba262fa47eca538cf9892503dc205d65b/res/config.yaml";
    sha256 = "sha256-fMFUsKf4ZqgWkazBwbxYiw4ZiPlR4nnkQdLS1YKlAZk=";
  };

  headcrabIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Deadboy666/h3adcr-b-modul3s/refs/heads/main/headcrab.png";
    sha256 = "sha256-pcqTVgwH83cHqpW9etOW1dcVyL1W3oTvFipkOGNgIME=";
  };

  # Injected Steam launcher (our own Nix version of headcrab_native_CR.sh).
  # @SLSSTEAM_LIB@ / @CLOUDREDIRECT@ are substituted with store paths.
  steamSh = pkgs.writeText "steam.sh" (builtins.replaceStrings
    [ "@SLSSTEAM_LIB@" "@CLOUDREDIRECT@" ]
    [ "${slssteam}" "${cloudredirect}" ]
    (builtins.readFile ./steam.sh.in));

  # Stock steam.sh of the headcrab-compatible client (vendored; used as
  # client.sh — the actual client launcher that the injected steam.sh sources).
  clientSh = pkgs.writeText "client.sh" (builtins.readFile ./client.sh);

  # The `headcrab` executable: a thin wrapper that exports the Nix store
  # paths and runs the runtime logic in ./headcrab.sh.
  headcrab = pkgs.writeShellScriptBin "headcrab" ''
    export SLSSTEAM_LIB="${slssteam}"
    export NETSOCK_SO="${netsock}"
    export CLOUDREDIRECT="${cloudredirect}"
    export CONFIG_TEMPLATE="${configTemplate}"
    export STEAM_SH="${steamSh}"
    export CLIENT_SH="${clientSh}"
    export STEAM_BIN="${pkgs.steam}/bin/steam"
    export HEADCRAB_ICON="${headcrabIcon}"
    export HEADCRAB_COMPATIBLE_CLIENT_VER="${cfg.compatibleClientVersion}"
    export HEADCRAB_DOWNGRADE_URL="${cfg.downgradeUrl}"
    export PATH="${pkgs.coreutils}/bin:${pkgs.procps}/bin:${pkgs.gnused}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.flatpak}/bin:${pkgs.bash}/bin:$PATH"
    exec ${pkgs.bash}/bin/bash ${./headcrab.sh} "$@"
  '';
in
{
  options.programs.headcrab = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the Nix-managed headcrab setup (importing this module enables it by default).";
    };

    compatibleClientVersion = lib.mkOption {
      type = lib.types.str;
      default = "1785799196";
      description = ''
        Steam client build number that SLSsteam is compatible with
        (upstream h3adcr-b's HeadcrabCompatibleClientVer). Bump together
        with the client mirror and ./client.sh when the ecosystem moves.
      '';
    };

    downgradeUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://headcrab.bifrosthub.ru/client-stable/";
      description = ''
        Mirror served to Steam via -overridepackageurl when a client
        downgrade is needed. The trailing slash is load-bearing.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      headcrab
      accela
    ];

    xdg.desktopEntries.headcrab = {
      name = "Headcrab";
      comment = "Update SLSsteam / CloudRedirect / Steam client";
      exec = "headcrab";
      terminal = true;
      icon = "headcrab";
      categories = [ "Utility" "Application" ];
    };

    # ACCELA's menu entry + accela:// handler come from the package's own
    # share/applications/accela.desktop (Exec=accela, MimeType=accela://).

    home.file = {
      ".local/share/icons/hicolor/48x48/apps/headcrab.png".source = headcrabIcon;
      ".local/share/icons/hicolor/48x48/apps/accela.png".source =
        "${accela}/share/pixmaps/accela.png";
    };

    # The old distrobox-based entries are broken (the fedora container is
    # gone) and are replaced by the desktop entries above.
    home.activation.removeStaleFedoraEntries = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      rm -f "$HOME/.local/share/applications/fedora-headcrab.desktop" \
            "$HOME/.local/share/applications/fedora-accela.desktop"
    '';
  };
}
