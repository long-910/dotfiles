#!/usr/bin/env bash
# modules/dev.sh — Dev tools: gh, ripgrep, direnv, bat, delta, fd, jq, lazygit

# shellcheck source=modules/lib.sh
: "${DOTFILES_ROOT:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"

install_dev() {
  step "Dev Tools"
  detect_os

  _install_gh
  _install_ripgrep
  _install_direnv
  _install_bat
  _install_delta
  _install_fd
  _install_jq
  _install_lazygit
  _setup_git_config

  _deploy_dev_configs
}

_install_gh() {
  if has_cmd gh; then info "gh already installed"; return; fi
  info "Installing GitHub CLI..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install gh
  else
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y gh
  fi
}

_install_ripgrep() {
  if has_cmd rg; then info "ripgrep already installed"; return; fi
  info "Installing ripgrep..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install ripgrep
  else
    sudo apt-get install -y ripgrep
  fi
}

_install_direnv() {
  if has_cmd direnv; then info "direnv already installed"; return; fi
  info "Installing direnv..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install direnv
  else
    sudo apt-get install -y direnv
  fi
}

_install_bat() {
  if has_cmd bat || has_cmd batcat; then info "bat already installed"; return; fi
  info "Installing bat..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install bat
  else
    sudo apt-get install -y bat
    # On Ubuntu, binary is batcat — create symlink
    if has_cmd batcat && ! has_cmd bat; then
      mkdir -p "${HOME}/.local/bin"
      ln -sf "$(command -v batcat)" "${HOME}/.local/bin/bat"
      info "Created bat → batcat symlink in ~/.local/bin"
    fi
  fi
}

_install_delta() {
  if has_cmd delta; then info "delta already installed"; return; fi
  info "Installing git-delta..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install git-delta
  elif sudo apt-get install -y git-delta 2>/dev/null; then
    :
  else
    local ver="0.17.0"
    local deb="git-delta_${ver}_amd64.deb"
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/dandavison/delta/releases/download/${ver}/${deb}" \
      -o "${tmp}/${deb}" && sudo dpkg -i "${tmp}/${deb}"
    rm -rf "$tmp"
  fi
}

_install_fd() {
  if has_cmd fd || has_cmd fdfind; then info "fd already installed"; return; fi
  info "Installing fd..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install fd
  else
    sudo apt-get install -y fd-find
    if has_cmd fdfind && ! has_cmd fd; then
      mkdir -p "${HOME}/.local/bin"
      ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
      info "Created fd → fdfind symlink in ~/.local/bin"
    fi
  fi
}

_install_jq() {
  if has_cmd jq; then info "jq already installed"; return; fi
  info "Installing jq..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install jq
  else
    sudo apt-get install -y jq
  fi
}

_install_lazygit() {
  if has_cmd lazygit; then info "lazygit already installed"; return; fi
  info "Installing lazygit..."
  if [ "$PKG_MGR" = "brew" ]; then
    brew install lazygit
  else
    local ver
    ver=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
      | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_x86_64.tar.gz" \
      | tar -xz -C "$tmp"
    sudo install "${tmp}/lazygit" /usr/local/bin/lazygit
    rm -rf "$tmp"
  fi
}

_setup_git_config() {
  step "Git configuration"

  # Commit message template
  if [ -f "${DOTFILES_ROOT}/dotfiles/.gitmessage" ]; then
    cp "${DOTFILES_ROOT}/dotfiles/.gitmessage" "${HOME}/.gitmessage"
    git config --global commit.template "${HOME}/.gitmessage"
    success "Set commit.template"
  fi

  # Default branch
  git config --global init.defaultBranch main
  success "Set init.defaultBranch=main"

  # Delta as pager
  if has_cmd delta; then
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side false
    git config --global delta.line-numbers true
    success "Configured delta as git pager"
  fi
}

_deploy_dev_configs() {
  step "Deploying dev configs"
  setup_zshrc_d
  deploy_zshrc_d "direnv.zsh"
  deploy_zshrc_d "commit.zsh"
}
