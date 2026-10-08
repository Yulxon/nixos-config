# Repository guide for coding agents

This repository is Chumi's personal NixOS flake. Keep changes focused on the requested behavior and preserve unrelated working-tree edits. Read `git status --short` before editing: this checkout may contain staged and unstaged work.

## Layout and module wiring

- `flake.nix` uses `nixpkgs.lib.nixosSystem` to define the `asus` and `redmi` NixOS configurations for `x86_64-linux`. Both import `./modules` and Home Manager's `./home` for user `chumi`.
- `hosts/<name>/default.nix` contains the host's name and hardware-specific settings. `hardware-configuration.nix` files are generated machine data; avoid hand-editing them for general system changes.
- `modules/default.nix` imports shared system modules. Put system-wide services, hardware-independent settings, and packages there.
- `home/default.nix` imports `home/gui` and `home/tui`. Add a new Home Manager program module to the appropriate directory's `default.nix` import list. GUI programs such as Rime live in `home/gui`; terminal programs live in `home/tui`. The GNOME terminal shortcut runs `kgx` (GNOME Console).
- Flake inputs are available in NixOS and Home Manager modules through the `inputs` argument. Reference them as `inputs.<name>`; keep `specialArgs` and `home-manager.extraSpecialArgs` in sync when changing this wiring.

## Conventions and state

- For every change, consider whether the implementation is the simplest, needs the fewest dependencies, and is easy to understand. Prefer existing native options and direct configuration; add packages, scripts, or abstractions only when they provide a clear benefit.
- For substantial changes, consider updating the relevant Markdown documentation. Keep it concise and prioritize what readers need to use and maintain the configuration: explain important behavior and trade-offs, briefly describe secondary details, and avoid repeating implementation code.
- Follow nearby Nix formatting and use `nixfmt` for touched Nix files. Keep program settings in their own module when one exists.
- Keep `flake.lock` changes intentional. Use `nix flake update nixpkgs home-manager` to update only the primary inputs; other inputs remain pinned unless their update is part of the task.
- `home/gui/rime.nix` manages selected Rime user files, while the Rime engine and data packages come from `modules/graphical.nix`. Do not replace Rime's runtime databases or generated files with Home Manager links.
- `home/gui/gnome.nix` uses `programs.gnome-shell.extensions` to install and enable Shell extensions together; do not duplicate them in `home.packages` or `enabled-extensions`. Keep the User Themes name empty and Light Style enabled for native light/dark switching, including the IBus/Rime candidate popup. GNOME Console uses `theme = "auto"`.
- Preserve automatic appearance settings: Helix's `system` theme inherits terminal default colors and the ANSI palette. Helix's appearance depends on its terminal rather than direct GNOME settings.
- GNOME Console's custom font is `Iosevka 12`, managed in `home/gui/gnome.nix`; the font package is installed in `home/gui/default.nix`. Helix inherits its terminal's font and has no independent font setting.
- `home/gui/wallpaper.nix` manages the native GNOME light/dark wallpaper pair from `home/gui/wallpapers/fydeos-radiant-anatomy/`. Keep both image assets and the chooser XML's `filename` / `filename-dark` pairing in sync with `picture-uri` / `picture-uri-dark`. Reference repository assets through Nix store paths; do not add a polling service or depend on machine-local Downloads paths.
- `home/tui/helix.nix` installs Helix through Home Manager and sets the user's `EDITOR` and `VISUAL` to `hx`. The AI CLI tools (`codex` and `dsh`) come from the `llm-agents` flake input declared in `flake.nix` and installed in `home/tui/default.nix`; update that input explicitly with `nix flake update llm-agents`. `modules/default.nix` trusts the `cache.numtide.com` binary cache and its public key for those packages.
- Do not commit credentials or machine-local runtime state. The Nix modules intentionally leave application state such as `~/.dsh`, Rime databases, and newly learned SSH host fingerprints in the user's home directory.
- `modules/graphical.nix` enables Flatpak; applications are managed through GNOME Software or the Flatpak CLI. Preserve `home/gui/fontconfig.nix`'s user font-access override and `~/.var/app` data.

## Validation

- For a small Nix edit, run `nix-instantiate --parse <changed-file>` and evaluate the affected option or host when practical.
- For broader changes, run `nix flake check --no-build path:.` and inspect both host configurations if shared modules changed. The explicit `path:.` form includes newly created files before they are tracked by Git.
- For shell edits, run `bash -n` on touched scripts.
- Run `git diff --check` and review the final diff. A successful evaluation does not imply that runtime services or GUI behavior were tested.
