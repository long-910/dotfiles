#!/usr/bin/env bash
# modules/shell.sh — Shell enhancements: starship, fzf, zoxide, atuin

# shellcheck source=modules/lib.sh
: "${DOTFILES_ROOT:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"

install_shell() {
  step "Shell Tools (starship, fzf, zoxide, atuin)"
  detect_os

  _install_starship
  _install_fzf
  _install_zoxide
  _install_atuin

  _deploy_shell_configs
}

_install_starship() {
  if has_cmd starship; then
    info "starship already installed"
    return
  fi
  info "Installing starship..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install starship
  elif apt-cache show starship >/dev/null 2>&1; then
    sudo apt-get install -y starship
  else
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
  fi
}

_install_fzf() {
  if has_cmd fzf; then
    info "fzf already installed"
    return
  fi
  info "Installing fzf..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install fzf
  else
    sudo apt-get install -y fzf || {
      git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
      "${HOME}/.fzf/install" --all --no-bash --no-fish
    }
  fi
}

_install_zoxide() {
  if has_cmd zoxide; then
    info "zoxide already installed"
    return
  fi
  info "Installing zoxide..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install zoxide
  elif apt-cache show zoxide >/dev/null 2>&1; then
    sudo apt-get install -y zoxide
  else
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi
}

_install_atuin() {
  if has_cmd atuin; then
    info "atuin already installed"
  else
    info "Installing atuin..."
    if [ "$PKG_MGR" = "brew" ]; then
      brew install atuin
    else
      # ATUIN_NO_MODIFY_SHELL=1 prevents atuin's installer from appending
      # init code to ~/.zshrc — our .zshrc.d/atuin.zsh handles that instead.
      ATUIN_NO_MODIFY_SHELL=1 curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | ATUIN_NO_MODIFY_SHELL=1 sh
    fi
  fi

  # Remove any lines atuin's installer may have already appended to ~/.zshrc.
  # These duplicate the .zshrc.d/atuin.zsh setup and cause
  # "(eval):1: can't change option: zle" on every shell start.
  if grep -q '\.atuin/bin/env\|atuin init' "${HOME}/.zshrc" 2>/dev/null; then
    info "Removing duplicate atuin init lines from ~/.zshrc..."
    sed -i '/^\. ".*\.atuin\/bin\/env"/d' "${HOME}/.zshrc"
    sed -i '/^eval "\$(atuin init/d'      "${HOME}/.zshrc"
    success "Cleaned up ~/.zshrc"
  fi
}

_deploy_shell_configs() {
  step "Deploying shell configs"
  setup_zshrc_d
  deploy_zshrc_d "starship.zsh"
  deploy_zshrc_d "fzf.zsh"
  deploy_zshrc_d "zoxide.zsh"
  deploy_zshrc_d "atuin.zsh"

  # starship config
  mkdir -p "${HOME}/.config"
  if [ -f "${DOTFILES_ROOT}/config/starship.toml" ]; then
    backup_file "${HOME}/.config/starship.toml"
    cp "${DOTFILES_ROOT}/config/starship.toml" "${HOME}/.config/starship.toml"
    success "Deployed starship.toml"
  fi

  # atuin config
  mkdir -p "${HOME}/.config/atuin"
  if [ -f "${DOTFILES_ROOT}/config/atuin/config.toml" ]; then
    backup_file "${HOME}/.config/atuin/config.toml"
    cp "${DOTFILES_ROOT}/config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
    success "Deployed atuin/config.toml"
  fi
}
