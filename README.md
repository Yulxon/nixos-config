# nixos-config

Chumi's NixOS configuration for `asus` and `redmi`, using NixOS and Home Manager
in one flake.

## Structure

- `hosts/asus/` and `hosts/redmi/` — machine-specific hardware profiles and hostnames
- `modules/` — shared NixOS modules (hardware, system, proxy, GUI)
- `home/` — home-manager user config, split into `gui/` (including Rime),
  `tui/` (including the AI CLI tools), and `scripts/`
- `config/proxy.nix` — local proxy address and port shared by NixOS and Home Manager

NixOS and Home Manager modules receive the flake's `inputs` argument and
reference inputs as `inputs.<name>`.

## Usage

```sh
nix flake lock                         # after changing inputs
nix flake check --no-build path:.      # evaluate both hosts
nixos-rebuild switch --flake .#asus    # or .#redmi
nix flake update nixpkgs home-manager # update the primary inputs
```

Day-to-day updates go through the `up` script installed by `home/scripts/default.nix`:

```sh
up                      # flatpak / tldr / flake.lock
up -r                   # ... then nixos-rebuild switch
up -h                   # show help
```

`up -r` rebuilds the current machine's flake configuration (`asus` or `redmi`).
Set `UP_FLAKE_HOST` to override that selection. `up` updates only `nixpkgs` and
`home-manager` and stops if a step fails. It operates on `UP_FLAKE_DIR`, which
defaults to `~/Projects/nixos-config`.

## AI CLI tools

`codex` and `dsh` are installed from the `llm-agents` flake input
(`github:numtide/llm-agents.nix`) in `home/tui/default.nix`, using packages
pinned by `flake.lock`. Update them separately with
`nix flake update llm-agents`, which the `up` script leaves
pinned. `modules/default.nix` trusts the `cache.numtide.com` binary cache and
its public key, allowing substitutes for those packages when available.
Application state and credentials under `~/.dsh` and `~/.codex` remain in the
home directory.

## Mihomo configuration

Public settings live in `modules/proxy.nix`. Private proxy nodes and subscription
URLs are encrypted in `secret/mihomo-proxies.json`. sops-nix decrypts this fragment
and renders `/run/secrets/rendered/mihomo-config.yaml` with mode `0600`; mihomo
loads it as a systemd credential. Changes to the rendered configuration restart
mihomo during activation. The old home-directory fragment and path watcher are
no longer used. Both proxy groups include all local and subscribed nodes;
`Proxy` also offers `DIRECT`.

## Secrets and SSH

`modules/secrets.nix` imports sops-nix. `.sops.yaml` lists the age recipient;
only encrypted files belong in `secret/`. The decryption key remains outside
Git and the Nix store at `~/.config/sops/age/keys.txt` (mode `0600`). Back up this
key separately: on a fresh `asus` or `redmi`, provision it at the same path
before the first activation. Both hosts currently use the same recipient.
Do not generate a different key on the second host and expect it to decrypt
these files; adding a new recipient requires re-encrypting with `sops updatekeys`.

The existing SSH private key is encrypted in `secret/ssh-id_ed25519.json` and
installed by sops-nix at `~/.ssh/id_ed25519` with owner `chumi` and mode `0600`.
Home Manager manages the public key and the `gh` and `s` client settings
in `home/tui/ssh.nix`. Host fingerprints in `~/.ssh/known_hosts` and the backup
`known_hosts.old` remain local, writable files managed by SSH; they are not
managed by Nix or sops.

Edit the encrypted binary documents with:

```sh
sops edit --input-type binary --output-type binary secret/mihomo-proxies.json
sops edit --input-type binary --output-type binary secret/ssh-id_ed25519.json
```

To replace the proxy fragment from a local plaintext file:

```sh
sops --encrypt --input-type binary --output-type json \
  --filename-override secret/mihomo-proxies.json /path/to/proxies.yaml \
  > secret/mihomo-proxies.json
```

Rebuild to apply secret changes. The original proxy file is retained until the
first successful activation; afterwards it can be removed. Never commit the
age key, plaintext proxy fragment, or SSH private key.

## Rime grammar model

The Wanxiang model in `home/gui/rime.nix` uses a fixed download hash. If its
upstream LTS file changes, obtain the new hash with `nix-prefetch-url` for the
URL declared there and update the module before rebuilding.
