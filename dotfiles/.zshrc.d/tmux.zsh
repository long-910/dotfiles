# shellcheck shell=bash
# Auto-start tmux when opening a new terminal.
# - Attaches to existing session "main" or creates a new one.
# - When tmux exits, the shell (and terminal window) also exits.
# Skip if: already inside tmux, tmux not installed, or VSCode terminal.
if command -v tmux >/dev/null 2>&1 \
  && [ -z "${TMUX:-}" ] \
  && [ "${TERM_PROGRAM:-}" != "vscode" ]; then
  exec tmux new-session -A -s main
fi
