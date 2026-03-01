#!/usr/bin/env bash
# modules/lib.sh — Shared helpers for all install modules

# ── Color constants ────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ── Logging ────────────────────────────────────────────────────────────────────
info()    { printf "${BLUE}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}    %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; }
step()    { printf "\n${BOLD}▶ %s${RESET}\n" "$*"; }

# ── OS Detection ───────────────────────────────────────────────────────────────
detect_os() {
  if [ -f /proc/version ] && grep -qi microsoft /proc/version 2>/dev/null; then
    OS="wsl"
    PKG_MGR="apt"
  elif [ "$(uname -s)" = "Darwin" ]; then
    OS="macos"
    PKG_MGR="brew"
  elif [ -f /etc/debian_version ]; then
    OS="linux"
    PKG_MGR="apt"
  else
    OS="linux"
    PKG_MGR="apt"
    warn "Unknown OS; assuming apt-based Linux"
  fi
  export OS PKG_MGR
}

# ── Command check ──────────────────────────────────────────────────────────────
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# ── Package install ────────────────────────────────────────────────────────────
pkg_install() {
  local pkg="$1"
  info "Installing ${pkg}..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install "$pkg"
  else
    sudo apt-get install -y "$pkg"
  fi
}

# ── Backup ─────────────────────────────────────────────────────────────────────
BACKUP_MANIFEST="${HOME}/.dotfiles_backup_manifest"

backup_file() {
  local path="$1"
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    local ts
    ts=$(date +%Y%m%d_%H%M%S)
    local bak="${path}_backup_${ts}"
    mv "$path" "$bak"
    echo "$bak" >> "$BACKUP_MANIFEST"
    info "Backed up ${path} → ${bak}"
  fi
}

restore_latest_backup() {
  local path="$1"
  local latest
  latest=$(find "$(dirname "$path")" -maxdepth 1 -name "$(basename "$path")_backup_*" 2>/dev/null | sort | tail -n1)
  if [ -n "$latest" ]; then
    mv "$latest" "$path"
    success "Restored ${path} from ${latest}"
  else
    warn "No backup found for ${path}"
  fi
}

# ── Config deployment ──────────────────────────────────────────────────────────
# DOTFILES_ROOT must be set to the repo root before calling these

deploy_config() {
  local src_rel="$1"   # relative to DOTFILES_ROOT/dotfiles/
  local dest="$2"      # absolute destination path
  local src="${DOTFILES_ROOT}/dotfiles/${src_rel}"
  if [ ! -f "$src" ]; then
    error "Source not found: ${src}"
    return 1
  fi
  backup_file "$dest"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  success "Deployed ${src_rel} → ${dest}"
}

setup_zshrc_d() {
  mkdir -p "${HOME}/.zshrc.d"
}

deploy_zshrc_d() {
  local filename="$1"
  local src="${DOTFILES_ROOT}/dotfiles/.zshrc.d/${filename}"
  if [ ! -f "$src" ]; then
    error "Source not found: ${src}"
    return 1
  fi
  setup_zshrc_d
  cp "$src" "${HOME}/.zshrc.d/${filename}"
  success "Deployed .zshrc.d/${filename}"
}

# ── zshrc sourcing block ───────────────────────────────────────────────────────
ZSHRC_MARKER="# === dotfiles modular config ==="

setup_zshrc_sourcing() {
  local zshrc="${HOME}/.zshrc"
  if grep -qF "$ZSHRC_MARKER" "$zshrc" 2>/dev/null; then
    info ".zshrc sourcing block already present — skipping"
    return 0
  fi
  cat >> "$zshrc" << 'BLOCK'

# === dotfiles modular config ===
if [ -d "$HOME/.zshrc.d" ]; then
  for _f in "$HOME/.zshrc.d"/*.zsh; do
    [ -r "$_f" ] && . "$_f"
  done
  unset _f
fi
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
BLOCK
  success "Appended sourcing block to ${zshrc}"
}
