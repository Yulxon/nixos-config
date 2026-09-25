# nixos-config

Chumi's NixOS configuration for `asus` and `redmi`, using NixOS and Home Manager
in one flake.

## Structure

- `hosts/asus/` and `hosts/redmi/` — machine-specific hardware profiles and hostnames
- `modules/` — shared NixOS modules (hardware, system, proxy, GUI)
- `home/` — home-manager user config, split into `gui/` (including Rime),
  `tui/`, and `scripts/`
- `config/proxy.nix` — local proxy address and port shared by NixOS and Home Manager

NixOS and Home Manager modules receive a `flake` argument containing the inputs,
so they reference inputs as `flake.inputs.*`.

## Usage

```sh
nix flake lock                         # after changing inputs
nix flake check --no-build path:.      # evaluate both hosts
nixos-rebuild switch --flake .#asus    # or .#redmi
nix flake update nixpkgs home-manager # update the primary inputs
```

Day-to-day updates go through the `up` script installed by `home/scripts/default.nix`:

```sh
up                      # flatpak / tldr / latest dsh / flake.lock
up -r                   # ... then nixos-rebuild switch
up -h                   # show help
```

`up -r` rebuilds the current machine's flake configuration (`asus` or `redmi`).
Set `UP_FLAKE_HOST` to override that selection.

`up` installs or updates `@deepseek-ai/dsh@latest` under the writable
`~/.local/npm` prefix configured by `home/scripts/default.nix`. Codex comes from the
pinned `codex-nix` flake input; update it separately with
`nix flake update codex-nix`. `up` updates
only `nixpkgs` and `home-manager` and stops if a step fails. Application state
and credentials under `~/.dsh` and `~/.codex` remain in the home directory.
If an older `up` installed npm globally, remove that old copy once with
`npm uninstall -g npm` to use the npm bundled with Nix's Node.js.

## Mihomo configuration

Public settings live in `modules/proxy.nix`. Private proxy nodes and subscription
URLs stay in `~/.config/mihomo/proxies.yaml` outside the Nix store. This private
file must exist before activation. Each activation combines the public settings
and private fragment into `/run/mihomo-config.yaml`, which the service loads as a
systemd credential. A systemd path unit regenerates the file and restarts mihomo
when `proxies.yaml` changes. On a new machine, create `proxies.yaml` with
`proxies:` and/or `proxy-providers:` before activating the configuration. Both
proxy groups include all local and subscribed nodes; `Proxy` also offers `DIRECT`.
The existing `s` node remains the default selection when present.

## Rime grammar model

The Wanxiang model in `home/gui/rime.nix` uses a fixed download hash. If its
upstream LTS file changes, obtain the new hash with `nix-prefetch-url` for the
URL declared there and update the module before rebuilding.
