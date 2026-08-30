#!/usr/bin/env bash
# headcrab — Nix-managed SLSsteam / CloudRedirect / Steam client manager.
#
# Replaces the upstream h3adcr-b "headcrab.sh" script (previously run through
# a Fedora distrobox container). Everything is fetched/pinned at build time by
# home-manager; the only runtime network access is Steam's own updater when a
# client downgrade is required.
#
# Store paths of the pinned artifacts are provided through the environment by
# the generated `headcrab` wrapper (see home/headcrab/default.nix).

set -u

# ---------------------------------------------------------------------------
# Constants — keep in sync with the pinned ecosystem (see home/headcrab/README.md)
# ---------------------------------------------------------------------------
COMPATIBLE_CLIENT_VER="${HEADCRAB_COMPATIBLE_CLIENT_VER:-1785799196}"
# Trailing slash is load-bearing: Steam's -overridepackageurl appends the
# target filename directly onto this string.
DOWNGRADE_URL="${HEADCRAB_DOWNGRADE_URL:-https://headcrab.bifrosthub.ru/client-stable/}"
DOWNGRADE_TIMEOUT="${HEADCRAB_DOWNGRADE_TIMEOUT:-900}"

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
STEAM_DIR="$HOME/.steam/steam"
SLS_DIR="$HOME/.local/share/SLSsteam"
SLS_CONFIG_DIR="$HOME/.config/SLSsteam"
NETSOCK_DIR="$SLS_CONFIG_DIR/tools/netsock"
CR_DIR="$HOME/.local/share/CloudRedirect"
ICON_DIR="$HOME/.local/share/icons/hicolor/48x48/apps"
APPLICATIONS_DIR="$HOME/.local/share/applications"
ACCELA_DATA="$HOME/.local/share/ACCELA"
ACCELA_CONF_DIR="$HOME/.config/Tachibana Labs"
ACCELA_CONF="$ACCELA_CONF_DIR/ACCELA.conf"
# data left behind by the old Fedora-container setup
OLD_ACCELA_DATA="$HOME/.var/fedora/.local/share/ACCELA"
OLD_ACCELA_CONF="$HOME/.var/fedora/.config/Tachibana Labs/ACCELA.conf"

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
LAUNCH_STEAM=0
SKIP_KILL=0
SKIP_DOWNGRADE=0

usage() {
    cat <<'EOF'
headcrab — SLSsteam / CloudRedirect / Steam client manager (Nix-managed)

Usage: headcrab [options]

Options:
  --launch           launch Steam after the setup finishes
  --no-kill          do not stop a running Steam instance first
  --skip-downgrade   do not force a client downgrade even if the version
                     does not match (still refreshes all injectors)
  -h, --help         show this help

Environment:
  HEADCRAB_COMPATIBLE_CLIENT_VER  expected Steam client version (default 1785799196)
  HEADCRAB_DOWNGRADE_URL          client mirror used by -overridepackageurl
  HEADCRAB_DOWNGRADE_TIMEOUT      seconds to allow the downgrade run (default 900)
EOF
}

for arg in "$@"; do
    case "$arg" in
        --launch) LAUNCH_STEAM=1 ;;
        --no-kill) SKIP_KILL=1 ;;
        --skip-downgrade) SKIP_DOWNGRADE=1 ;;
        -h | --help) usage; exit 0 ;;
        *) echo "headcrab: unknown argument: $arg" >&2; usage >&2; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
say() { printf '\033[1;32m[headcrab]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[headcrab]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[headcrab]\033[0m %s\n' "$*" >&2; exit 1; }

[ -n "${SLSSTEAM_LIB:-}" ] || die "internal error: SLSSTEAM_LIB not set (broken Nix wrapper)"
[ -n "${NETSOCK_SO:-}" ] || die "internal error: NETSOCK_SO not set (broken Nix wrapper)"
[ -n "${CLOUDREDIRECT:-}" ] || die "internal error: CLOUDREDIRECT not set (broken Nix wrapper)"
[ -n "${CONFIG_TEMPLATE:-}" ] || die "internal error: CONFIG_TEMPLATE not set (broken Nix wrapper)"
[ -n "${STEAM_SH:-}" ] || die "internal error: STEAM_SH not set (broken Nix wrapper)"
[ -n "${CLIENT_SH:-}" ] || die "internal error: CLIENT_SH not set (broken Nix wrapper)"
[ -n "${STEAM_BIN:-}" ] || die "internal error: STEAM_BIN not set (broken Nix wrapper)"
[ -n "${HEADCRAB_ICON:-}" ] || die "internal error: HEADCRAB_ICON not set (broken Nix wrapper)"

nuketheclient() {
    [ "$SKIP_KILL" = 1 ] && return 0
    say "Stopping Steam..."
    pkill -x steam 2>/dev/null || true
    sleep 2
    pkill -x steam 2>/dev/null || true
}

createsteamcfg() {
    mkdir -p "$STEAM_DIR"
    if [ -f "$STEAM_DIR/steam.cfg" ]; then
        say "steam.cfg already present (client updates suppressed)"
    else
        cat > "$STEAM_DIR/steam.cfg" <<'EOF'
BootStrapperInhibitAll=enable
BootStrapperForceSelfUpdate=disable
EOF
        say "Wrote steam.cfg (BootStrapperInhibitAll/BootStrapperForceSelfUpdate)"
    fi
}

client_version() {
    local v="" n f
    for f in "$STEAM_DIR/package/steam_client_ubuntu12.installed" \
             "$STEAM_DIR/package/steam_client_ubuntu12.manifest" \
             "$STEAM_DIR/package/steam_client_ubuntu12"; do
        [ -f "$f" ] || continue
        n=$(grep '"version"' "$f" | head -1 | awk -F'"' '{print $4}')
        [ -n "$n" ] || continue
        if [ -z "$v" ] || [ "$n" -gt "$v" ]; then
            v="$n"
        fi
    done
    echo "${v:-unknown}"
}

run_steam() {
    # One-shot Steam run (blocking, with a safety timeout). Injection is
    # handled by the patched ~/.steam/steam/steam.sh once patchsteam() has
    # run, so no LD_* env vars are needed here — setting them on the outer
    # 64-bit wrapper processes would only produce wrong-ELF-class noise.
    timeout --foreground "${DOWNGRADE_TIMEOUT}" "$STEAM_BIN" "$@"
}

clientdowngrade() {
    local ver="$1"
    say "Client version ${ver} does not match compatible ${COMPATIBLE_CLIENT_VER}."
    say "Clearing package metadata (forces Steam to re-download the pinned client)..."
    mkdir -p "$STEAM_DIR/package"
    rm -f "$STEAM_DIR/package"/*
    createsteamcfg
    say "Running Steam updater against $DOWNGRADE_URL"
    say "(this downloads the headcrab-compatible client; be patient)"
    if run_steam -forcesteamupdate -forcepackagedownload -overridepackageurl "$DOWNGRADE_URL" -exitsteam; then
        say "Client downgrade run finished."
    else
        warn "Steam updater did not exit cleanly (status $?)."
        warn "If the client did not update, check the mirror URL / network and re-run."
    fi
}

clientbootstrap() {
    say "Client version matches ${COMPATIBLE_CLIENT_VER}; skipping downgrade."
    # Short injected run so Steam picks up SLSsteam (clears any beta channel).
    say "Running one-shot injected Steam bootstrap..."
    run_steam -clearbeta -exitsteam >/dev/null 2>&1 \
        || warn "Steam bootstrap run exited with status $? (non-fatal)."
}

install_slssteam() {
    say "Installing SLSsteam libraries -> $SLS_DIR"
    mkdir -p "$SLS_DIR"
    install -m 0755 "$SLSSTEAM_LIB/library-inject.so" "$SLS_DIR/library-inject.so"
    install -m 0755 "$SLSSTEAM_LIB/SLSsteam.so" "$SLS_DIR/SLSsteam.so"
    say "Installing SteamNetworkingSockets patch -> $NETSOCK_DIR/netsock.so"
    say "(use LD_AUDIT=\"\$HOME/.config/SLSsteam/tools/netsock/netsock.so\" %command% as a game launch option)"
    mkdir -p "$NETSOCK_DIR"
    install -m 0755 "$NETSOCK_SO" "$NETSOCK_DIR/netsock.so"
}

patchsteam() {
    say "Installing injected steam.sh + stock client.sh -> $STEAM_DIR"
    install -m 0555 "$STEAM_SH" "$STEAM_DIR/steam.sh"
    install -m 0755 "$CLIENT_SH" "$STEAM_DIR/client.sh"
}

editconfig() {
    local cfg="$SLS_CONFIG_DIR/config.yaml"
    mkdir -p "$SLS_CONFIG_DIR"
    if [ -f "$cfg" ]; then
        # Merge template keys into the existing config, preserving user values
        # (same semantics as upstream headcrab's updateSLSsteamConfig).
        local merged backup
        merged="$(mktemp)" || die "mktemp failed"
        if awk '
            NR == FNR {
                if ($0 ~ /^[A-Za-z_][A-Za-z0-9_]*:/) {
                    key = $0
                    sub(/:.*/, "", key)
                    current = key
                    present[key] = 1
                    saved[key] = $0 ORS
                    next
                }
                if (current != "" && $0 ~ /^[[:space:]]+/) {
                    saved[current] = saved[current] $0 ORS
                }
                next
            }
            /^[A-Za-z_][A-Za-z0-9_]*:/ {
                key = $0
                sub(/:.*/, "", key)
                printf "%s", prefix
                prefix = ""
                if (key in present) {
                    printf "%s", saved[key]
                    use_template = 0
                } else {
                    print
                    use_template = 1
                }
                have_key = 1
                next
            }
            have_key && /^[[:space:]]+/ {
                if (use_template) {
                    print
                }
                next
            }
            {
                prefix = prefix $0 ORS
            }
            END {
                printf "%s", prefix
            }
        ' "$cfg" "$CONFIG_TEMPLATE" > "$merged" \
            && grep -q '^DisableFamilyShareLock:' "$merged"; then
            if ! cmp -s "$cfg" "$merged"; then
                backup="$cfg.bak-$(date +%Y%m%d-%H%M%S)"
                cp -a "$cfg" "$backup"
                mv -f "$merged" "$cfg"
                say "config.yaml updated (backup: $(basename "$backup"))"
            else
                rm -f "$merged"
                say "config.yaml is up to date"
            fi
        else
            rm -f "$merged"
            warn "config merge failed; leaving config.yaml untouched"
        fi
        sed -i 's/^SafeMode:.*/SafeMode: no/' "$cfg"
    else
        say "No config.yaml yet — installing template."
        install -m 0644 "$CONFIG_TEMPLATE" "$cfg"
        sed -i 's/^SafeMode:.*/SafeMode: no/' "$cfg"
    fi
    echo "config patched" > "$SLS_CONFIG_DIR/.headcrabd"
}

cr_enabled() {
    grep -q '^DisableCloud: no' "$SLS_CONFIG_DIR/config.yaml" 2>/dev/null
}

install_cloudredirect() {
    say "Installing CloudRedirect library + CLI -> $CR_DIR"
    mkdir -p "$CR_DIR"
    install -m 0755 "$CLOUDREDIRECT/cloud_redirect.so" "$CR_DIR/cloud_redirect.so"
    install -m 0755 "$CLOUDREDIRECT/cloud_redirect_cli" "$CR_DIR/cloud_redirect_cli"
    install -m 0755 "$CLOUDREDIRECT/cloud_redirect_cli" "$CR_DIR/cloud_redirect_lib"

    # CloudRedirect GUI (org.cloudredirect.CloudRedirect) manages providers/tokens.
    if command -v flatpak >/dev/null 2>&1; then
        if flatpak list --user 2>/dev/null | grep -q 'org.cloudredirect.CloudRedirect'; then
            say "CloudRedirect flatpak app already installed"
        else
            say "Installing CloudRedirect flatpak app (org.kde.Platform//6.10)..."
            flatpak --user remote-add --if-not-exists cloudredirect \
                https://raw.githubusercontent.com/Selectively11/CloudRedirect/refs/heads/gh-pages/cloudredirect.flatpakrepo || true
            flatpak --user remote-add --if-not-exists flathub \
                https://dl.flathub.org/repo/flathub.flatpakrepo || true
            flatpak --user install -y --noninteractive \
                org.kde.Platform//6.10 org.cloudredirect.CloudRedirect \
                || warn "flatpak install failed (library + CLI are installed regardless)"
        fi
    else
        warn "flatpak not found — skipping CloudRedirect GUI app (library + CLI still installed)"
    fi
}

ensure_accela_conf() {
    mkdir -p "$ACCELA_CONF_DIR"
    if [ ! -f "$ACCELA_CONF" ]; then
        cat > "$ACCELA_CONF" <<'EOF'
[General]
auto_skip_single_choice=true
library_mode=true
max_downloads=16
sls_config_management=true
slssteam_mode=true
use_steamless=true
EOF
        say "Wrote default ACCELA.conf"
        return 0
    fi
    # Idempotently add any missing required [General] keys (keeps user values).
    local tmp
    tmp="$(mktemp)" || return 1
    if awk '
        BEGIN { saw_general = 0 }
        /^\[[^]]+\]$/ {
            saw_general = ($0 == "[General]") ? 1 : 0
            print
            next
        }
        saw_general && /^[a-z_]+[[:space:]]*=/ {
            key = $1
            sub(/=.*/, "", key)
            seen[key] = 1
            print
            next
        }
        { print }
        END {
            if (!saw_general) {
                print ""
                print "[General]"
            }
            if (!seen["auto_skip_single_choice"]) print "auto_skip_single_choice=true"
            if (!seen["library_mode"]) print "library_mode=true"
            if (!seen["max_downloads"]) print "max_downloads=16"
            if (!seen["sls_config_management"]) print "sls_config_management=true"
            if (!seen["slssteam_mode"]) print "slssteam_mode=true"
            if (!seen["use_steamless"]) print "use_steamless=true"
        }
    ' "$ACCELA_CONF" > "$tmp"; then
        if ! cmp -s "$ACCELA_CONF" "$tmp"; then
            mv -f "$tmp" "$ACCELA_CONF"
            say "ACCELA.conf updated with required keys"
        else
            rm -f "$tmp"
        fi
    else
        rm -f "$tmp"
    fi
}

migrate_accela() {
    if [ -d "$OLD_ACCELA_DATA" ] && [ ! -d "$ACCELA_DATA" ]; then
        say "Migrating ACCELA data from the old container home -> $ACCELA_DATA"
        mkdir -p "$ACCELA_DATA"
        local moved=0
        for item in "$OLD_ACCELA_DATA"/*; do
            [ -e "$item" ] || continue
            case "$(basename "$item")" in
                ACCELA.AppImage)
                    # replaced by the Nix-packaged AppImage; nothing to migrate
                    ;;
                *)
                    mv "$item" "$ACCELA_DATA/" && moved=1
                    ;;
            esac
        done
        [ "$moved" = 1 ] && say "ACCELA data migrated (depots, hubcap manifests, headers, logs)"
    fi
    if [ -f "$OLD_ACCELA_CONF" ] && [ ! -f "$ACCELA_CONF" ]; then
        say "Migrating ACCELA.conf -> $ACCELA_CONF"
        mkdir -p "$ACCELA_CONF_DIR"
        mv "$OLD_ACCELA_CONF" "$ACCELA_CONF"
    fi
    ensure_accela_conf
}

remove_stale_entries() {
    local f
    for f in fedora-headcrab.desktop fedora-accela.desktop; do
        if [ -f "$APPLICATIONS_DIR/$f" ]; then
            rm -f "$APPLICATIONS_DIR/$f"
            say "Removed stale $f (distrobox-based entry replaced by Nix entries)"
        fi
    done
}

install_icon() {
    mkdir -p "$ICON_DIR"
    install -m 0644 "$HEADCRAB_ICON" "$ICON_DIR/headcrab.png"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    say "the headcrab approaches.. (Nix-managed)"
    install_icon
    remove_stale_entries
    nuketheclient
    createsteamcfg

    # Install the injectors and patch the launcher *before* running Steam,
    # so the one-shot runs below are already injected via steam.sh.
    install_slssteam
    patchsteam
    editconfig

    local ver
    ver="$(client_version)"
    say "Steam client version: ${ver} (compatible: ${COMPATIBLE_CLIENT_VER})"

    if [ "$ver" = "$COMPATIBLE_CLIENT_VER" ]; then
        clientbootstrap
    elif [ "$SKIP_DOWNGRADE" = 1 ]; then
        warn "version mismatch, but --skip-downgrade given; continuing anyway"
    else
        clientdowngrade "$ver"
    fi

    if cr_enabled; then
        install_cloudredirect
    else
        say "CloudRedirect disabled in SLSsteam config (DisableCloud is not 'no'); skipping"
    fi

    migrate_accela

    say "=================================================="
    say "Done. Injection is active on the next Steam launch."
    say "ACCELA is available as 'accela' (or in the app menu)."
    if [ "$LAUNCH_STEAM" = 1 ]; then
        say "Launching Steam..."
        exec "$STEAM_BIN"
    else
        say "Start Steam with: steam"
    fi
}

main "$@"
