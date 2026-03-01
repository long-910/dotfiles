# shellcheck shell=bash
# ~/.zshrc.d/atuin.zsh — Atuin shell history
# --disable-up-arrow keeps default ↑ behavior; use Ctrl-R for atuin search

# Add ~/.atuin/bin to PATH when installed via curl installer
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi
