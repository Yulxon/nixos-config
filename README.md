# nixos-config

Chumi's NixOS configuration, built with [nixos-unified](https://github.com/srid/nixos-unified)
(flake-parts + home-manager in one flake).

## Structure

- `hosts/asus/` — ASUS FX506HM host: hardware-configuration, nixos-hardware profile, Steam/gamescope
- `modules/` — system-wide NixOS modules (hardware, system, proxy, gui)
- `home/` — home-manager user config, split into `gui/`, `tui/`, `scripts/`,
  plus `headcrab/` (SLSsteam injection) and `rime/` (Rime input method), which
  have their own READMEs
- `shared/` — constants shared between module systems; `shared/proxy.nix` is the
  single source of truth for the local proxy endpoint (used by `modules/proxy.nix`
  and `home/gui/gnome.nix`)

All NixOS and home-manager modules receive the `flake` specialArg
(`{ self, inputs, config }`), so flake inputs are referenced as `flake.inputs.*`.

## Usage

```sh
nix flake lock          # after changing inputs
nix flake check         # evaluate the flake
nixos-rebuild switch --flake .#asus

nix run .#activate      # nixos-unified activation (switch)
nix run .#update        # update nixpkgs + home-manager inputs
```

Day-to-day updates go through the `up` script installed by `home/scripts/default.nix`:

```sh
up                      # flatpak / distrobox / tldr / flake.lock / rime-ice
up -r                   # ... then nixos-rebuild switch
up -s flake -s rime     # skip steps
up -l                   # list steps
```

Only the primary inputs (`nixpkgs`, `home-manager`, see
`nixos-unified.primary-inputs` in `flake.nix`) are refreshed; logs are written to
`~/.local/state/up/`.
