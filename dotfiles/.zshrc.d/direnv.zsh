# shellcheck shell=bash
# ~/.zshrc.d/direnv.zsh — direnv per-directory environment

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
