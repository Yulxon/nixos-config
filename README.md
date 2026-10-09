# nixos-config

Chumi's NixOS configuration for `asus` and `redmi`, using NixOS and Home Manager
in one flake.

## Structure

- `hosts/asus/` and `hosts/redmi/` — machine-specific hardware profiles and hostnames
- `modules/` — shared NixOS modules (`system.nix` and `graphical.nix`)
- `home/` — home-manager user config, split into `gui/` (including Rime),
  `tui/` (including the AI CLI tools)

NixOS and Home Manager modules receive the flake's `inputs` argument and
reference inputs as `inputs.<name>`.

## Usage

```sh
nix flake lock                         # after changing inputs
nix flake check --no-build path:.      # evaluate both hosts
nixos-rebuild switch --flake .#asus    # or .#redmi
nix flake update nixpkgs home-manager # update the primary inputs
```

## Default editor

`home/tui/helix.nix` installs Helix for `chumi` through Home Manager and sets
the user's `EDITOR` and `VISUAL` to `hx` on both hosts. Rebuild and start a new session to
use the updated environment. The NixVim module and flake input have been removed.

`home/tui/default.nix` keeps `nixd` and `nixfmt` on the user's PATH for Helix
and command-line use.

## Fonts

`home/gui/default.nix` installs Maple Mono NF CN and Symbols Nerd Font.
NixOS's default font packages provide Noto CJK and emoji fonts; they do not
need duplicate Home Manager package declarations. Console font preferences
and wallpaper are managed locally.

## Dynamic linking compatibility

`modules/system.nix` enables `nix-ld` on both hosts so unpatched Linux ELF
binaries can use the conventional dynamic loader path and the module's default
shared libraries. Rebuild and start a new session to load its environment.
If a binary reports a missing shared library, add the required package to
`programs.nix-ld.libraries`; this does not provide every Linux runtime dependency.

## AI CLI tools

`codex` and `dsh` are installed from the `llm-agents` flake input
(`github:numtide/llm-agents.nix`) in `home/tui/default.nix`, using packages
pinned by `flake.lock`. Update them separately with
`nix flake update llm-agents`; updating only `nixpkgs` and `home-manager` leaves
this input pinned. `modules/default.nix` trusts the `cache.numtide.com` binary
cache and its public key, allowing substitutes for those packages when available.
Application state and credentials under `~/.dsh` and `~/.codex` remain in the
home directory.

## Rime grammar model

The Wanxiang model in `home/gui/rime.nix` uses a fixed download hash. If its
upstream LTS file changes, obtain the new hash with `nix-prefetch-url` for the
URL declared there and update the module before rebuilding.
