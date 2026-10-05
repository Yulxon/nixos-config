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

## AI CLI tools

`codex` and `dsh` are installed from the `llm-agents` flake input
(`github:numtide/llm-agents.nix`) in `home/tui/default.nix`, using packages
pinned by `flake.lock`. Update them separately with
`nix flake update llm-agents`; updating only `nixpkgs` and `home-manager` leaves
this input pinned. `modules/default.nix` trusts the `cache.numtide.com` binary
cache and its public key, allowing substitutes for those packages when available.
Application state and credentials under `~/.dsh` and `~/.codex` remain in the
home directory.

## SSH and local credentials

The SSH private key lives at `~/.ssh/id_ed25519` as a regular local file with
mode `0600`. Its existing passphrase is preserved. Keep the private key, public
key, SSH client configuration, and host fingerprints in `~/.ssh/`; they are
not managed by this flake. Back up the private key separately and securely.

Mihomo remains enabled in `modules/system.nix` and reads the local configuration
at `~/.config/mihomo/config.yaml`. The flake no longer manages its proxy settings
or the GNOME proxy settings. The sops-nix configuration, encrypted secret
directory, and sops recipient configuration have been removed. Never commit private keys or other
plaintext credentials, or copy them into the Nix store.

## Rime grammar model

The Wanxiang model in `home/gui/rime.nix` uses a fixed download hash. If its
upstream LTS file changes, obtain the new hash with `nix-prefetch-url` for the
URL declared there and update the module before rebuilding.
