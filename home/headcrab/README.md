# headcrab (Nix-managed)

Replaces the upstream [h3adcr-b](https://github.com/Deadboy666/h3adcr-b)
`headcrab.sh` script (previously run through a Fedora distrobox container)
with a fully Nix-managed equivalent. The `headcrab` executable is packaged by
home-manager; typing `headcrab` in a terminal:

1. stops Steam,
2. checks the Steam client build against the headcrab-compatible version and,
   if needed, downgrades it via Steam's own updater
   (`-overridepackageurl https://headcrab.bifrosthub.ru/client-stable/`),
3. installs/refreshes the **SLSsteam** injector (`library-inject.so` +
   `SLSsteam.so`) and the **SteamNetworkingSockets** patch
   (`netsock.so`), all copied from pinned Nix store paths,
4. installs the injected `steam.sh` + stock `client.sh` into
   `~/.steam/steam/` so every Steam launch is injected,
5. patches `~/.config/SLSsteam/config.yaml` (merges new keys from the pinned
   template, preserves your values, sets `SafeMode: no`),
6. installs the **CloudRedirect** library + CLI (and the flatpak GUI app when
   `DisableCloud: no` is set) when CloudRedirect is enabled,
7. migrates ACCELA data/config from the old container home
   (`~/.var/fedora/...`) to the standard XDG paths and ensures the required
   `ACCELA.conf` keys,
8. removes the stale distrobox-based `fedora-headcrab.desktop` /
   `fedora-accela.desktop` entries.

The module also provides:

- the **ACCELA** desktop app (`accela` command / app-menu entry, with the
  `accela://` URL scheme handler), packaged from the upstream
  [enter-the-wired](https://github.com/ciscosweater/enter-the-wired) Nix flake,
- `Headcrab` desktop entry + icon.

## Files

| File | Purpose |
| --- | --- |
| `default.nix` | home-manager module (options, packages, desktop entries, activation) |
| `headcrab.sh` | runtime logic executed by the `headcrab` wrapper |
| `steam.sh.in` | injected Steam launcher template (`@SLSSTEAM_LIB@` / `@CLOUDREDIRECT@` are substituted with Nix store paths) |
| `client.sh` | vendored stock `steam.sh` of the headcrab-compatible client (the launcher the injected `steam.sh` sources) |
| `README.md` | this file |

## Updating / maintenance

| What changed | What to do |
| --- | --- |
| SLSsteam input bumped (`sls-steam` in `flake.lock`) | bump `configTemplate` hash in `default.nix` (pinned to the rev's `res/config.yaml`); bump `programs.headcrab.compatibleClientVersion` if the new release targets a newer client |
| Headcrab ecosystem moves to a newer compatible client | update `compatibleClientVersion` + `downgradeUrl` (if the mirror moved) and replace `client.sh` with the new client's stock `steam.sh` (upstream: `SteamTracking` → `ClientExtracted/steam.sh` of the compatible build) |
| netsock / CloudRedirect binaries updated upstream | bump the `sha256` in `default.nix` |
| ACCELA updated | `nix flake lock --update-input enter-the-wired` (package builds the AppImage from `deps.tar.gz`) |

All artifacts are pinned by Nix: no runtime downloads except Steam's own
updater during a client downgrade.
