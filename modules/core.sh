#!/usr/bin/env bash
# modules/core.sh — Core tools: zsh, tmux, lsd, emacs, htop, neofetch, yazi

# shellcheck source=modules/lib.sh
: "${DOTFILES_ROOT:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"

install_core() {
  step "Core Tools"
  detect_os

  if [ "$PKG_MGR" = "brew" ]; then
    _install_core_brew
  else
    _install_core_apt
  fi

  _deploy_core_configs
}

_install_core_brew() {
  local tools=(lsd zsh emacs tmux htop neofetch yazi)
  for t in "${tools[@]}"; do
    if has_cmd "$t"; then
      info "${t} already installed"
    else
      pkg_install "$t"
    fi
  done

  # tmux-mem-cpu-load
  if ! has_cmd tmux-mem-cpu-load; then
    info "Installing tmux-mem-cpu-load..."
    brew install tmux-mem-cpu-load
  fi
}

_install_core_apt() {
  sudo apt-get update -qq

  # lsd
  if ! has_cmd lsd; then
    info "Installing lsd..."
    local lsd_ver="1.1.5"
    local deb="lsd_${lsd_ver}_amd64.deb"
    local url="https://github.com/lsd-rs/lsd/releases/download/v${lsd_ver}/${deb}"
    local tmp
    tmp=$(mktemp -d)
    if curl -fsSL "$url" -o "${tmp}/${deb}"; then
      sudo dpkg -i "${tmp}/${deb}" || sudo apt-get install -f -y
    else
      warn "lsd release download failed; trying apt..."
      sudo apt-get install -y lsd || warn "lsd not available via apt"
    fi
    rm -rf "$tmp"
  else
    info "lsd already installed"
  fi

  local apt_tools=(zsh emacs tmux htop neofetch)
  for t in "${apt_tools[@]}"; do
    if has_cmd "$t"; then
      info "${t} already installed"
    else
      pkg_install "$t"
    fi
  done

  # yazi: try apt → fallback cargo
  if ! has_cmd yazi; then
    if apt-cache show yazi >/dev/null 2>&1; then
      pkg_install yazi
    elif has_cmd cargo; then
      info "Installing yazi via cargo..."
      cargo install --locked yazi-fm
    else
      warn "yazi: apt package not found and cargo unavailable; skipping"
    fi
  else
    info "yazi already installed"
  fi

  # tmux-mem-cpu-load: build from submodule
  if ! has_cmd tmux-mem-cpu-load; then
    local tmc_dir="${DOTFILES_ROOT}/tmux-mem-cpu-load"
    if [ -d "$tmc_dir" ]; then
      info "Building tmux-mem-cpu-load..."
      if has_cmd cmake; then
        (cd "$tmc_dir" && cmake . && make && sudo make install)
      else
        sudo apt-get install -y cmake
        (cd "$tmc_dir" && cmake . && make && sudo make install)
      fi
    else
      warn "tmux-mem-cpu-load source not found; skipping"
    fi
  else
    info "tmux-mem-cpu-load already installed"
  fi
}

_deploy_core_configs() {
  step "Deploying core configs"
  deploy_config ".zshrc"    "${HOME}/.zshrc"
  deploy_config ".tmux.conf" "${HOME}/.tmux.conf"
  deploy_config ".emacs.el"  "${HOME}/.emacs.el"
}
