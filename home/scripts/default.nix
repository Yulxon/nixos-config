{ pkgs, ... }:

let
  # ---------------------------------------------------------------------------
  # `up` — one-command system update.
  #
  #   up                  flatpak / distrobox / tldr / flake.lock / rime-ice
  #   up -r               ... then rebuild the system (nixos-rebuild switch)
  #   up -s flake -s rime skip steps (-s is repeatable)
  #   up -n               no desktop notification at the end
  #   up -l               list steps and exit
  #   up -h               show help
  #
  # Env overrides (optional): UP_FLAKE_DIR, UP_FLAKE_HOST, UP_RIME_DIR
  #
  # Every step's output is teed into the logs:
  #   ~/.local/state/up/last.log                 most recent run
  #   ~/.local/state/up/up-YYYY-MM-DD.log        append-only daily archive
  #
  # NOTE: inside this '' string, bash variables are written brace-free
  # ($VAR) wherever possible; only arrays and ${VAR:-default} need the
  # ''${...} escape form.
  # ---------------------------------------------------------------------------
  up = pkgs.writeShellScriptBin "up" ''
    set -uo pipefail

    # Coreutils/grep are pinned so the script behaves identically anywhere.
    export PATH="${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin:$PATH"

    # --- config ----------------------------------------------------------------
    FLAKE_DIR="''${UP_FLAKE_DIR:-$HOME/Projects/nixos-config}"
    FLAKE_HOST="''${UP_FLAKE_HOST:-asus}"
    RIME_DIR="''${UP_RIME_DIR:-$HOME/Projects/plum}"

    LOG_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/up"
    mkdir -p "$LOG_DIR"
    DAILY="$LOG_DIR/up-$(date +%F).log"                   # append-only archive
    RUN_LOG="$LOG_DIR/run-$(date +%Y%m%d-%H%M%S).log"     # this run
    LAST="$LOG_DIR/last.log"                              # copy of this run
    : > "$RUN_LOG"

    # --- colours (only when stdout is a terminal) --------------------------------
    if [[ -t 1 ]] && [[ "''${NO_COLOR:-}" != 1 ]]; then
      C_BOLD=$'\e[1m'; C_DIM=$'\e[2m'
      C_RED=$'\e[31m'; C_GREEN=$'\e[32m'; C_YELLOW=$'\e[33m'
      C_BLUE=$'\e[34m'; C_CYAN=$'\e[36m'; C_RESET=$'\e[0m'
    else
      C_BOLD=; C_DIM=; C_RED=; C_GREEN=; C_YELLOW=; C_BLUE=; C_CYAN=; C_RESET=
    fi

    usage() {
      cat <<EOF
$C_BOLD up$C_RESET — one-command system update

usage: up [options]

  -r        rebuild the system afterwards (nixos-rebuild switch --flake $FLAKE_DIR#$FLAKE_HOST)
  -s STEP   skip a step (repeatable, e.g. -s tldr -s rime)
  -n        no desktop notification at the end
  -l        list steps and exit
  -h        show this help

steps: flatpak distrobox tldr flake rime [rebuild]
EOF
    }

    # --- steps -------------------------------------------------------------------
    step_flatpak() {
      if ! ${pkgs.flatpak}/bin/flatpak remotes 2>/dev/null | grep -q .; then
        echo "  $C_DIM(no flatpak remotes — skipping)$C_RESET"
        return 0
      fi
      ${pkgs.flatpak}/bin/flatpak update -y
    }

    step_distrobox() {
      if [ "$(${pkgs.distrobox}/bin/distrobox list 2>/dev/null | wc -l)" -le 1 ]; then
        echo "  $C_DIM(no distroboxes — skipping)$C_RESET"
        return 0
      fi
      ${pkgs.distrobox}/bin/distrobox upgrade --all
    }

    step_tldr() {
      ${pkgs.tealdeer}/bin/tldr --update
    }

    step_flake() {
      if [ ! -d "$FLAKE_DIR" ]; then
        echo "  $C_YELLOW(flake dir not found: $FLAKE_DIR — skipping)$C_RESET"
        return 0
      fi
      local ret=0
      # Note: since nix 2.18-ish, `nix flake update` takes *input names* as
      # positionals; the flake to update goes to --flake.
      ${pkgs.nix}/bin/nix flake update --flake "$FLAKE_DIR" || ret=1
      if [ "$ret" -eq 0 ] && command -v git >/dev/null 2>&1 &&
         git -C "$FLAKE_DIR" rev-parse --git-dir >/dev/null 2>&1 &&
         ! git -C "$FLAKE_DIR" diff --quiet -- flake.lock 2>/dev/null; then
        echo "  $C_DIM hint: flake.lock changed — commit it:$C_RESET"
        echo "        $C_DIM git -C $FLAKE_DIR add flake.lock && git commit -m 'update inputs'$C_RESET"
      fi
      return "$ret"
    }

    step_rime() {
      if [ ! -d "$RIME_DIR" ]; then
        echo "  $C_YELLOW(plum dir not found: $RIME_DIR — skipping)$C_RESET"
        return 0
      fi
      ( cd "$RIME_DIR" && bash rime-install iDvel/rime-ice )
    }

    step_rebuild() {
      if ! command -v nixos-rebuild >/dev/null 2>&1; then
        echo "  $C_RED nixos-rebuild not available — cannot rebuild$C_RESET" >&2
        return 1
      fi
      if [ "$(id -u)" -eq 0 ]; then
        nixos-rebuild switch --flake "$FLAKE_DIR#$FLAKE_HOST"
      else
        sudo nixos-rebuild switch --flake "$FLAKE_DIR#$FLAKE_HOST"
      fi
    }

    # --- helpers -------------------------------------------------------------------
    is_skipped() {
      local s
      for s in "''${SKIP_STEPS[@]}"; do
        [ "$s" = "$1" ] && return 0
      done
      return 1
    }

    fmt_time() {
      local s=$1 h m
      h=$((s / 3600)); m=$(((s % 3600) / 60)); s=$((s % 60))
      if [ "$h" -gt 0 ]; then
        printf '%dh %dm %ds' "$h" "$m" "$s"
      elif [ "$m" -gt 0 ]; then
        printf '%dm %ds' "$m" "$s"
      else
        printf '%ds' "$s"
      fi
    }

    run_step() {
      local name=$1 start dur rc
      if is_skipped "$name"; then
        SKIP_COUNT=$((SKIP_COUNT + 1))
        echo "  $C_DIM· $name — skipped$C_RESET"
        return 0
      fi
      start=$(date +%s)
      echo "$C_BOLD$C_BLUE▶ $name$C_RESET"
      echo "== $name ==" >> "$RUN_LOG"
      step_$name 2>&1 | tee -a "$DAILY" | tee -a "$RUN_LOG"
      rc=''${PIPESTATUS[0]}
      dur=$(($(date +%s) - start))
      if [ "$rc" -eq 0 ]; then
        OK_COUNT=$((OK_COUNT + 1))
        echo "  $C_GREEN✔ $name$C_RESET $C_DIM($(fmt_time "$dur"))$C_RESET"
      else
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED+=("$name")
        echo "  $C_RED✘ $name$C_RESET $C_DIM($(fmt_time "$dur"))$C_RESET"
      fi
    }

    # --- main -----------------------------------------------------------------------
    SKIP_STEPS=(); FAILED=()
    DO_REBUILD=0; DO_NOTIFY=1; LIST_ONLY=0
    OK_COUNT=0; FAIL_COUNT=0; SKIP_COUNT=0

    while getopts "hrs:nl" opt; do
      case "$opt" in
        r) DO_REBUILD=1 ;;
        s) SKIP_STEPS+=("$OPTARG") ;;
        n) DO_NOTIFY=0 ;;
        l) LIST_ONLY=1 ;;
        h) usage; exit 0 ;;
        *) usage >&2; exit 1 ;;
      esac
    done

    STEPS=(flatpak distrobox tldr flake rime)
    [ "$DO_REBUILD" = 1 ] && STEPS+=(rebuild)

    if [ "$LIST_ONLY" = 1 ]; then
      echo "available steps:"
      printf '  %s\n' "''${STEPS[@]}"
      exit 0
    fi

    for s in "''${SKIP_STEPS[@]}"; do
      case " ''${STEPS[*]} " in *" $s "*) ;; *) echo "warning: unknown step: $s" >&2 ;; esac
    done

    echo "$C_BOLD$C_CYAN== up $(date '+%F %T') ==$C_RESET"
    echo "== up $(date '+%F %T') ==" >> "$DAILY"
    START=$(date +%s)

    for s in "''${STEPS[@]}"; do
      run_step "$s"
    done

    echo
    echo "$C_BOLD$C_CYAN── summary ──$C_RESET"
    echo "  $C_GREEN✔ $OK_COUNT ok$C_RESET  $C_RED✘ $FAIL_COUNT failed$C_RESET  $C_DIM· $SKIP_COUNT skipped$C_RESET  (total $(fmt_time "$(( $(date +%s) - START ))"))"
    rc=0
    if [ "$FAIL_COUNT" -gt 0 ]; then
      echo "  failed steps: $C_RED''${FAILED[*]}$C_RESET"
      rc=1
    fi
    cp "$RUN_LOG" "$LAST"
    echo "  log: $LAST"

    if [ "$DO_NOTIFY" = 1 ] && [ -n "''${DISPLAY:-}''${WAYLAND_DISPLAY:-}" ]; then
      if [ "$FAIL_COUNT" -gt 0 ]; then
        ${pkgs.libnotify}/bin/notify-send -u critical \
          "up: $FAIL_COUNT step(s) failed" "failed: ''${FAILED[*]} — log: $LAST"
      else
        ${pkgs.libnotify}/bin/notify-send -u normal \
          "up: everything is up to date" "all $OK_COUNT steps ok in $(fmt_time "$(( $(date +%s) - START ))")"
      fi
    fi

    exit "$rc"
  '';
in
{
  home.packages = [ up ];
}
