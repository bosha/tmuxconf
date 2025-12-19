#!/bin/sh
set -e

REPO_URL="https://github.com/bosha/tmuxconf.git"
TMUX_CONF_PATH=".tmux.conf"

log() { printf "\n==> %s\n" "$*"; }
die() { printf "\nERROR: %s\n" >&2; exit 1; }

# macOS only
[ "$(uname -s)" = "Darwin" ] || die "macOS only"

have() { command -v "$1" >/dev/null 2>&1; }

# detect brew
BREW=0
have brew && BREW=1

# ensure git
if ! have git; then
  [ "$BREW" -eq 1 ] || die "git missing and brew not found"
  log "Installing git"
  brew install git
fi

# ensure tmux
if ! have tmux; then
  [ "$BREW" -eq 1 ] || die "tmux missing and brew not found"
  log "Installing tmux"
  brew install tmux
fi

# temp dir
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

log "Cloning tmux repo into temporary directory"
git clone --depth=1 "$REPO_URL" "$TMP_DIR"

CONF_SRC="$TMP_DIR/$TMUX_CONF_PATH"
[ -f "$CONF_SRC" ] || die "tmux config not found in repo: $TMUX_CONF_PATH"

# backup existing config
if [ -f "$HOME/.tmux.conf" ]; then
  BK="$HOME/.tmux.conf.bak.$(date +%Y%m%d-%H%M%S)"
  mv "$HOME/.tmux.conf" "$BK"
  log "Existing ~/.tmux.conf backed up to:"
  log "  $BK"
fi

# copy config
log "Copying ~/.tmux.conf"
cp "$CONF_SRC" "$HOME/.tmux.conf"

if [ -d "$TMP_DIR/.tmux" ]; then
  log "Copying ~/.tmux/ (scripts, themes, etc.)"
  mkdir -p "$HOME/.tmux"
  cp -a "$TMP_DIR/.tmux/." "$HOME/.tmux/"
fi

# install TPM
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  log "Installing tmux plugin manager (TPM)"
  mkdir -p "$HOME/.tmux/plugins"
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# install plugins
log "Installing tmux plugins"
tmux start-server || true
"$TPM_DIR/bin/install_plugins" || true

log "Done."
