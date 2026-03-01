#!/usr/bin/env bash
# install.sh — One-line installer for long-910/dotfiles
# Usage: curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
#        curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash -s -- --all
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
REPO="https://github.com/long-910/dotfiles.git"

echo "=> Installing long-910/dotfiles into ${DOTFILES_DIR}"

if [ -d "${DOTFILES_DIR}/.git" ]; then
  echo "=> Repository already exists — pulling latest changes"
  git -C "${DOTFILES_DIR}" pull --ff-only
else
  echo "=> Cloning repository"
  git clone --depth=1 "${REPO}" "${DOTFILES_DIR}"
fi

# When piped from curl, stdin is the pipe (not a TTY).
# Redirect from /dev/tty so the interactive menu can read keyboard input.
if [ ! -t 0 ] && [ -c /dev/tty ]; then
  exec bash "${DOTFILES_DIR}/bootstrap.sh" "$@" </dev/tty
else
  exec bash "${DOTFILES_DIR}/bootstrap.sh" "$@"
fi
