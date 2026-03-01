#!/usr/bin/env bash
# modules/node.sh — Node.js via fnm + commitizen

# shellcheck source=modules/lib.sh
: "${DOTFILES_ROOT:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"

install_node() {
  step "Node.js (fnm + LTS)"
  detect_os

  _install_fnm
  _bootstrap_node
  _deploy_node_config
}

_install_fnm() {
  if has_cmd fnm; then
    info "fnm already installed"
    return
  fi
  info "Installing fnm..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install fnm
  else
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "${HOME}/.local/bin" --skip-shell
  fi
}

_bootstrap_node() {
  # Temporarily eval fnm so we can use it in this session
  local fnm_bin
  fnm_bin=$(command -v fnm 2>/dev/null || echo "${HOME}/.local/bin/fnm")
  if [ ! -x "$fnm_bin" ]; then
    warn "fnm not found; skipping Node install"
    return
  fi

  eval "$("$fnm_bin" env --use-on-cd 2>/dev/null)" || true

  info "Installing Node.js LTS..."
  "$fnm_bin" install --lts
  "$fnm_bin" use lts-latest || "$fnm_bin" use lts/iron

  # Optional: commitizen
  if has_cmd npm; then
    if ! has_cmd cz; then
      info "Installing commitizen globally..."
      npm install -g commitizen cz-conventional-changelog
      echo '{ "path": "cz-conventional-changelog" }' > "${HOME}/.czrc"
      success "commitizen installed"
    else
      info "commitizen already installed"
    fi
  else
    warn "npm not available; skipping commitizen"
  fi
}

_deploy_node_config() {
  step "Deploying node config"
  setup_zshrc_d
  deploy_zshrc_d "node.zsh"
}
