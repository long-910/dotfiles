# shellcheck shell=bash
# ~/.zshrc.d/commit.zsh — Git aliases and conventional commit helper

if command -v git >/dev/null 2>&1; then

# ── Status / diff ──────────────────────────────────────────────────────────────
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'

# ── Staging / commit ───────────────────────────────────────────────────────────
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'

# ── Branch / checkout ─────────────────────────────────────────────────────────
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbr='git branch -vv'

# ── Push / pull ────────────────────────────────────────────────────────────────
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull --rebase'

# ── Log ───────────────────────────────────────────────────────────────────────
alias glog='git log --oneline --decorate -20'
alias glogg='git log --oneline --decorate --graph --all -30'

# ── gcommit: conventional commit helper ───────────────────────────────────────
# Usage: gcommit <type> "<description>" [scope]
# Example: gcommit feat "add dark mode" ui
gcommit() {
  local type="${1:?Usage: gcommit <type> <description> [scope]}"
  local desc="${2:?Usage: gcommit <type> <description> [scope]}"
  local scope="${3:-}"
  local subject
  if [ -n "$scope" ]; then
    subject="${type}(${scope}): ${desc}"
  else
    subject="${type}: ${desc}"
  fi
  git commit -m "$subject"
}

# ── newproject: create project from template ──────────────────────────────────
# Usage: newproject <type> <name>  (type: node | python)
newproject() {
  local tmpl_type="${1:?Usage: newproject <type> <name>  (node|python)}"
  local name="${2:?Usage: newproject <type> <name>}"
  local tmpl_dir
  # Resolve template dir relative to this file's repo location
  # Fall back gracefully if DOTFILES_ROOT not set
  tmpl_dir="${DOTFILES_ROOT:-${HOME}/.dotfiles}/templates/${tmpl_type}"
  if [ ! -d "$tmpl_dir" ]; then
    echo "Template not found: ${tmpl_dir}" >&2
    return 1
  fi
  mkdir -p "$name"
  cp -r "${tmpl_dir}/." "$name/"
  # Replace placeholder PROJECT_NAME in files
  find "$name" -type f | while read -r f; do
    sed -i "s/PROJECT_NAME/${name}/g" "$f" 2>/dev/null || true
  done
  cd "$name" || return
  git init
  echo "Created ${tmpl_type} project '${name}'"
}

fi # command -v git
