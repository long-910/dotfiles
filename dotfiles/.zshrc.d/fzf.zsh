# shellcheck shell=zsh
# ~/.zshrc.d/fzf.zsh — fzf keybindings and helpers

# Source fzf shell integration (try common locations)
if command -v fzf >/dev/null 2>&1; then
  # fzf >= 0.48 has built-in --zsh flag
  if fzf --version 2>/dev/null | awk -F'[. ]' '{exit ($1 > 0 || $2 >= 48) ? 0 : 1}' 2>/dev/null; then
    eval "$(fzf --zsh)"
  else
    for _fzf_src in \
      "${HOME}/.fzf.zsh" \
      /usr/share/doc/fzf/examples/key-bindings.zsh \
      /opt/homebrew/opt/fzf/shell/key-bindings.zsh; do
      # shellcheck disable=SC1090
      [ -r "$_fzf_src" ] && source "$_fzf_src" && break
    done
    unset _fzf_src
  fi

  # Use ripgrep as default command if available (respects .gitignore)
  if command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  # Preview with bat (or cat fallback)
  if command -v bat >/dev/null 2>&1; then
    _FZF_PREVIEW_CMD='bat --color=always --style=numbers --line-range=:200 {}'
  elif command -v batcat >/dev/null 2>&1; then
    _FZF_PREVIEW_CMD='batcat --color=always --style=numbers --line-range=:200 {}'
  else
    _FZF_PREVIEW_CMD='cat {}'
  fi

  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview-window=right:50%:wrap"
  export FZF_CTRL_T_OPTS="--preview '${_FZF_PREVIEW_CMD}'"
  unset _FZF_PREVIEW_CMD

  # fcd: interactive directory jump
  fcd() {
    local dir
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf +m --preview 'ls -la {}') && cd "$dir" || return
  }

  # fkill: fuzzy kill process
  fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ -n "$pid" ]; then
      echo "$pid" | xargs kill -"${1:-9}"
    fi
  }
fi
