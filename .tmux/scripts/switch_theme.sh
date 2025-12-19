#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="${HOME}/.tmux/theme"
DARK_FILE="${THEME_DIR}/vscode_dark.conf"
LIGHT_FILE="${THEME_DIR}/vscode_light.conf"

apply_theme() {
    local t="$1"
    case "$t" in
    dark) tmux source-file "$DARK_FILE" ;;
    light) tmux source-file "$LIGHT_FILE" ;;
    *) return 1 ;;
    esac
    tmux set -gq @theme "$t"
    tmux display-message "Theme: VS Code ${t^}"
}

detect_os_theme() {
    # default to light
    local choice="light"
    # allow env override
    if [[ "${TMUX_THEME:-}" =~ ^(dark|light)$ ]]; then
        echo "$TMUX_THEME"
        return
    fi
    # macOS auto-detect
    if command -v defaults >/dev/null 2>&1; then
        if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi dark; then
            choice="dark"
        fi
    fi
    echo "$choice"
}

current_theme() {
    # what tmux currently thinks (if not set, return empty)
    tmux show -gqv '@theme' || true
}

cmd="${1:-auto}"

case "$cmd" in
toggle)
    cur="$(current_theme)"
    if [[ -z "$cur" ]]; then
        cur="$(detect_os_theme)"
    fi
    if [[ "$cur" == "dark" ]]; then
        apply_theme light
    else
        apply_theme dark
    fi
    ;;
dark | light)
    apply_theme "$cmd"
    ;;
auto | *)
    apply_theme "$(detect_os_theme)"
    ;;
esac
