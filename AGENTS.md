# Repository guide for coding agents

This repository is Chumi's personal NixOS flake. Keep changes focused on the requested behavior and preserve unrelated working-tree edits. Read `git status --short` before editing: this checkout may contain staged and unstaged work.

## Layout and module wiring

- `flake.nix` uses `nixpkgs.lib.nixosSystem` to define the `asus` and `redmi` NixOS configurations for `x86_64-linux`. Both import `./modules` and Home Manager's `./home` for user `chumi`.
- `hosts/<name>/default.nix` contains the host's name and hardware-specific settings. `hardware-configuration.nix` files are generated machine data; avoid hand-editing them for general system changes.
- `modules/default.nix` imports shared system modules. Put system-wide services, hardware-independent settings, and packages there.
- `home/default.nix` imports `home/gui`, `home/scripts`, and `home/tui`. Add a new Home Manager program module to the appropriate directory's `default.nix` import list. GUI programs such as LibreWolf, Kitty, Rime, and NixVim live in `home/gui`; terminal programs live in `home/tui`.
- Flake inputs are available in NixOS and Home Manager modules through the `flake` argument. Reference them as `flake.inputs.<name>`; keep `specialArgs` and `home-manager.extraSpecialArgs` in sync when changing this wiring.
- `config/proxy.nix` defines the local mihomo endpoint for `modules/proxy.nix` and `home/gui/gnome.nix`. Mihomo's public configuration is declared in `modules/proxy.nix`, while private proxy nodes and subscription URLs remain in `/home/chumi/.config/mihomo/proxies.yaml`.

## Conventions and state

- Follow nearby Nix formatting and use `nixfmt` for touched Nix files. Keep program settings in their own module when one exists.
- Keep `flake.lock` changes intentional. The `up` script updates only `nixpkgs` and `home-manager`; other inputs remain pinned unless their update is part of the task.
- `home/gui/rime.nix` manages selected Rime user files, while the Rime engine and data packages come from `modules/gui.nix`. Do not replace Rime's runtime databases or generated files with Home Manager links.
- `home/scripts/default.nix` sets npm's writable global prefix to `~/.local/npm`, installs or updates the latest dsh, and supplies the `up` command. Codex is pinned by the `codex-nix` flake input. The `up` wrapper gets its default flake host from the NixOS configuration; `UP_FLAKE_HOST` can override it.
- `modules/proxy.nix` regenerates the private mihomo credential at activation and when `proxies.yaml` changes. Keep private proxy data out of the Nix store.
- Do not commit credentials or machine-local runtime state. The Nix modules intentionally leave application state such as `~/.dsh`, Rime databases, and the mihomo YAML in the user's home directory.

## Validation

- For a small Nix edit, run `nix-instantiate --parse <changed-file>` and evaluate the affected option or host when practical.
- For broader changes, run `nix flake check --no-build path:.` and inspect both host configurations if shared modules changed. The explicit `path:.` form includes newly created files before they are tracked by Git.
- For shell edits, run `bash -n` on touched scripts. Avoid executing `up` merely as a test: it modifies user state and updates software.
- Run `git diff --check` and review the final diff. A successful evaluation does not imply that runtime services or GUI behavior were tested.
