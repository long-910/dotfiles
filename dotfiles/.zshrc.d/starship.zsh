# shellcheck shell=zsh
# ~/.zshrc.d/starship.zsh — Starship prompt

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
