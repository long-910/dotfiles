# shellcheck shell=bash
# ~/.zshrc.d/node.zsh — fnm Node.js version manager (lazy-load)

if command -v fnm >/dev/null 2>&1; then
  [ ! -d "${XDG_RUNTIME_DIR:-}" ] && export XDG_RUNTIME_DIR=/tmp
  eval "$(fnm env --use-on-cd)"
fi
