#!/usr/bin/env bash
# bootstrap.sh — One-command dotfiles setup with feature selection
# Usage: bash bootstrap.sh [--all | --module <name> | --list | --non-interactive]
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_ROOT

# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/lib.sh"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/core.sh"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/shell.sh"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/dev.sh"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/node.sh"
# shellcheck disable=SC1091
. "${DOTFILES_ROOT}/modules/docker.sh"

# ── Feature registry ───────────────────────────────────────────────────────────
FEATURE_NAMES=("core" "shell" "dev" "node" "docker")
FEATURE_LABELS=(
  "Core Tools     zsh, tmux, lsd, emacs, htop, neofetch, yazi"
  "Shell          starship, fzf, zoxide, atuin"
  "Dev Tools      gh, ripgrep, direnv, bat, delta, fd, jq, lazygit"
  "Node.js        fnm + Node LTS + commitizen"
  "Docker         Docker CE + Docker Compose"
)
# Default: core/shell/dev ON, node/docker OFF
FEATURE_SELECTED=(1 1 1 0 0)

# ── Banner ─────────────────────────────────────────────────────────────────────
print_banner() {
  detect_os
  printf "\n"
  printf "%s╔══════════════════════════════════════════════════════════════╗%s\n" "$BOLD" "$RESET"
  printf "%s║           dotfiles bootstrap — long-910/dotfiles             ║%s\n" "$BOLD" "$RESET"
  printf "%s╚══════════════════════════════════════════════════════════════╝%s\n" "$BOLD" "$RESET"
  printf "  OS: ${GREEN}%s${RESET}   Package manager: ${GREEN}%s${RESET}\n\n" "$OS" "$PKG_MGR"
}

# ── Interactive menu ───────────────────────────────────────────────────────────
print_menu() {
  printf "  %s機能ブロック選択 / Feature Selection%s\n" "$BOLD" "$RESET"
  printf "  %s\n" "────────────────────────────────────────────────────────────"
  local i=0
  for name in "${FEATURE_NAMES[@]}"; do
    local mark=" "
    [ "${FEATURE_SELECTED[$i]}" = "1" ] && mark="x"
    printf "  [%s] %d. %s\n" "$mark" "$((i+1))" "${FEATURE_LABELS[$i]}"
    i=$((i + 1))
  done
  printf "  %s\n" "────────────────────────────────────────────────────────────"
  printf "  番号で切替 / [a]全選択 / [n]全解除 / [Enter]インストール / [q]終了\n"
  printf "  > "
}

run_menu() {
  while true; do
    printf "\033[2J\033[H"  # clear screen
    print_banner
    print_menu
    read -r input

    case "$input" in
      q|Q|quit|exit)
        info "Aborted."
        exit 0
        ;;
      a|A)
        FEATURE_SELECTED=(1 1 1 1 1)
        ;;
      n|N)
        FEATURE_SELECTED=(0 0 0 0 0)
        ;;
      "")
        break
        ;;
      *)
        # Toggle by number(s)
        # shellcheck disable=SC2086
        for tok in $input; do
          if printf '%s' "$tok" | grep -qE '^[1-5]$'; then
            local idx=$((tok - 1))
            if [ "${FEATURE_SELECTED[idx]}" = "1" ]; then
              FEATURE_SELECTED[idx]=0
            else
              FEATURE_SELECTED[idx]=1
            fi
          fi
        done
        ;;
    esac
  done
}

# ── Install selected features ──────────────────────────────────────────────────
install_selected() {
  local i=0
  for name in "${FEATURE_NAMES[@]}"; do
    if [ "${FEATURE_SELECTED[$i]}" = "1" ]; then
      case "$name" in
        core)   install_core   ;;
        shell)  install_shell  ;;
        dev)    install_dev    ;;
        node)   install_node   ;;
        docker) install_docker ;;
      esac
    fi
    i=$((i + 1))
  done
}

# ── CLI argument handling ──────────────────────────────────────────────────────
list_modules() {
  printf "Available modules:\n"
  local i=0
  for name in "${FEATURE_NAMES[@]}"; do
    printf "  %s — %s\n" "$name" "${FEATURE_LABELS[$i]}"
    i=$((i + 1))
  done
}

# ── Main ───────────────────────────────────────────────────────────────────────
main() {
  detect_os

  case "${1:-}" in
    --all)
      FEATURE_SELECTED=(1 1 1 1 1)
      print_banner
      install_selected
      ;;
    --module)
      local mod="${2:-}"
      if [ -z "$mod" ]; then
        error "--module requires a name. Use --list for available modules."
        exit 1
      fi
      print_banner
      FEATURE_SELECTED=(0 0 0 0 0)
      local i=0
      for name in "${FEATURE_NAMES[@]}"; do
        [ "$name" = "$mod" ] && FEATURE_SELECTED[i]=1
        i=$((i + 1))
      done
      install_selected
      ;;
    --list)
      list_modules
      exit 0
      ;;
    --non-interactive)
      print_banner
      install_selected
      ;;
    "")
      print_banner
      run_menu
      install_selected
      ;;
    *)
      error "Unknown option: ${1}"
      printf "Usage: %s [--all | --module <name> | --list | --non-interactive]\n" "$0"
      exit 1
      ;;
  esac

  # Always append the sourcing block to ~/.zshrc
  setup_zshrc_sourcing

  printf "\n"
  success "Bootstrap complete!"
  printf "\n  Run: %ssource ~/.zshrc%s   to apply changes in your current shell.\n\n" "$BOLD" "$RESET"
}

main "$@"
