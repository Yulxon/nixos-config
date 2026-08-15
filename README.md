# nixos-config

Chumi's NixOS configuration, built with [nixos-unified](https://github.com/srid/nixos-unified)
(flake-parts + home-manager in one flake).

## Structure

- `hosts/asus/` — ASUS FX506HM host: hardware-configuration, nixos-hardware profile, Steam/gamescope
- `modules/` — system-wide NixOS modules (hardware, system, proxy, gui, nix)
- `home/` — home-manager user config, split into `gui/`, `tui/`, `scripts/`

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
