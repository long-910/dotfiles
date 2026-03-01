#!/usr/bin/env bash
# modules/docker.sh — Docker CE + Docker Compose

# shellcheck source=modules/lib.sh
: "${DOTFILES_ROOT:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"

install_docker() {
  step "Docker"
  detect_os

  case "$OS" in
    macos)
      _docker_macos
      ;;
    wsl)
      _docker_wsl
      ;;
    linux)
      _docker_linux
      ;;
  esac

  _deploy_docker_config
}

_docker_macos() {
  if has_cmd docker; then
    info "Docker already installed"
    return
  fi
  warn "macOS: Please install Docker Desktop from https://www.docker.com/products/docker-desktop/"
  warn "Alternatively: brew install --cask docker"
  read -r -p "Open Docker Desktop download page? [y/N] " ans
  case "$ans" in
    [Yy]*) open "https://www.docker.com/products/docker-desktop/" ;;
  esac
}

_docker_wsl() {
  # Check if Docker Desktop bridge is available
  if has_cmd docker; then
    info "Docker available via Docker Desktop bridge"
    return
  fi
  warn "WSL: Docker Desktop integration recommended."
  warn "Enable 'Use WSL 2 based engine' in Docker Desktop settings."
  warn "Falling back to docker-ce installation..."
  _docker_linux
}

_docker_linux() {
  if has_cmd docker; then
    info "Docker already installed"
    _ensure_compose
    return
  fi
  info "Installing Docker CE..."

  # Remove old packages
  for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg" 2>/dev/null || true
  done

  sudo apt-get update -qq
  sudo apt-get install -y ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # shellcheck disable=SC1091
  _codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
${_codename} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Add user to docker group
  if ! groups "$USER" | grep -q docker; then
    sudo usermod -aG docker "$USER"
    warn "Added ${USER} to docker group. Log out and back in to apply."
  fi

  success "Docker CE installed"
  _ensure_compose
}

_ensure_compose() {
  if has_cmd docker-compose || docker compose version >/dev/null 2>&1; then
    info "docker compose available"
  else
    info "Installing docker-compose standalone..."
    if [ "$PKG_MGR" = "brew" ]; then
      brew install docker-compose
    else
      sudo apt-get install -y docker-compose-plugin
    fi
  fi
}

_deploy_docker_config() {
  step "Deploying docker config"
  setup_zshrc_d
  deploy_zshrc_d "docker.zsh"
}
