# shellcheck shell=bash
# Auto-start tmux when opening a new terminal.
# - If any session exists, attach to the most recent one.
# - Otherwise, create a new session.
# - When tmux exits, the shell (and terminal window) also exits.
# Skip if: already inside tmux, tmux not installed, or VSCode terminal.
if command -v tmux >/dev/null 2>&1 \
  && [ -z "${TMUX:-}" ] \
  && [ "${TERM_PROGRAM:-}" != "vscode" ]; then
  if tmux list-sessions >/dev/null 2>&1; then
    exec tmux attach-session
  else
    exec tmux new-session
  fi
fi
