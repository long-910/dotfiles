#!/usr/bin/env bash
# uninstall.sh — Remove dotfiles configs and restore backups
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_ROOT

# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"

# ── Files we own in ~/.zshrc.d ─────────────────────────────────────────────────
ZSHRC_D_FILES=(
  tmux.zsh
  fzf.zsh
  zoxide.zsh
  starship.zsh
  atuin.zsh
  direnv.zsh
  node.zsh
  docker.zsh
  commit.zsh
)

# ── Config files we deployed ───────────────────────────────────────────────────
CONFIG_FILES=(
  "${HOME}/.config/starship.toml"
  "${HOME}/.config/atuin/config.toml"
  "${HOME}/.gitmessage"
)

# ── Core configs that have backups ─────────────────────────────────────────────
CORE_CONFIGS=(
  "${HOME}/.zshrc"
  "${HOME}/.tmux.conf"
  "${HOME}/.emacs.el"
)

confirm() {
  local msg="$1"
  printf "${YELLOW}%s [y/N]${RESET} " "$msg"
  read -r ans
  case "$ans" in
    [Yy]*) return 0 ;;
    *)     return 1 ;;
  esac
}

remove_zshrc_d() {
  step "Removing ~/.zshrc.d plugin files"
  for f in "${ZSHRC_D_FILES[@]}"; do
    local path="${HOME}/.zshrc.d/${f}"
    if [ -f "$path" ]; then
      rm -f "$path"
      success "Removed ${path}"
    fi
  done
  # Remove directory if empty
  if [ -d "${HOME}/.zshrc.d" ] && [ -z "$(ls -A "${HOME}/.zshrc.d")" ]; then
    rmdir "${HOME}/.zshrc.d"
    info "Removed empty ~/.zshrc.d"
  fi
}

restore_core_configs() {
  step "Restoring core config backups"
  for path in "${CORE_CONFIGS[@]}"; do
    restore_latest_backup "$path"
  done
}

remove_config_files() {
  step "Removing deployed config files"
  for path in "${CONFIG_FILES[@]}"; do
    if [ -f "$path" ]; then
      rm -f "$path"
      success "Removed ${path}"
    fi
  done
}

remove_git_settings() {
  step "Removing git config entries"
  git config --global --unset commit.template 2>/dev/null && success "Removed commit.template" || true
  git config --global --unset core.pager 2>/dev/null && success "Removed core.pager" || true
  git config --global --unset interactive.diffFilter 2>/dev/null || true
  git config --global --unset delta.navigate 2>/dev/null || true
  git config --global --unset delta.side-by-side 2>/dev/null || true
  git config --global --unset delta.line-numbers 2>/dev/null || true
}

uninstall_packages() {
  step "Package removal"
  local extra_tools=(starship fzf zoxide atuin gh ripgrep direnv bat delta fd-find jq lazygit fnm)
  warn "The following packages may have been installed by bootstrap:"
  printf "  %s\n" "${extra_tools[@]}"
  if confirm "Remove these packages?"; then
    detect_os
    for pkg in "${extra_tools[@]}"; do
      if has_cmd "$pkg"; then
        if [ "$PKG_MGR" = "brew" ]; then
          brew uninstall "$pkg" 2>/dev/null || warn "Could not remove ${pkg}"
        else
          sudo apt-get remove -y "$pkg" 2>/dev/null || warn "Could not remove ${pkg}"
        fi
      fi
    done
  else
    info "Skipping package removal"
  fi
}

main() {
  printf "\n%s╔══════════════════════════════════════════════════════════════╗%s\n" "$BOLD" "$RESET"
  printf "%s║                 dotfiles — uninstall                         ║%s\n" "$BOLD" "$RESET"
  printf "%s╚══════════════════════════════════════════════════════════════╝%s\n\n" "$BOLD" "$RESET"

  confirm "This will remove dotfiles configs and restore backups. Continue?" || {
    info "Aborted."
    exit 0
  }

  remove_zshrc_d
  restore_core_configs
  remove_config_files
  remove_git_settings

  if confirm "Remove installed packages (starship, fzf, zoxide, atuin, etc.)?"; then
    uninstall_packages
  fi

  success "Uninstall complete. Run 'source ~/.zshrc' or restart your shell."
}

main "$@"
