# Tmux

## Key Bindings

| Action | Key Binding | Description |
|--------|-------------|-------------|
| New session | `tmux` | Start a new tmux session |
| Attach to session | `tmux attach-session -t <name>` | Attach to an existing tmux session |
| List sessions | `tmux list-sessions` | Show all current sessions |
| Detach from session | `Ctrl-t` + d | Detach from the current session |
| Switch session | `tmux switch-client -n` | Switch to the next session |
| Kill session | `tmux kill-session -t <name>` | Terminate the specified session |
| New window | `Ctrl-t` + c | Create a new window |
| List windows | `Ctrl-t` + w | Show windows in the session |
| Rename window | `Ctrl-t` + , | Rename the current window |
| Kill window | `Ctrl-t` + & | Close the current window |
| Split horizontally | `Ctrl-t` + % | Split the current pane horizontally |
| Split vertically | `Ctrl-t` + " | Split the current pane vertically |
| List panes | `Ctrl-t` + q | Show pane numbers in the current window |
| Switch pane | `Ctrl-t` + arrow keys | Move to the adjacent pane |
| Join pane | `Ctrl-t` + : → `join-pane -s <n>` | Join the specified pane into the current one |
| Resize pane | `Ctrl-t` + : → `resize-pane -D 5` | Resize the current pane downward by 5 units |
| Command mode | `Ctrl-t` + : | Enter command input mode |
| Help | `Ctrl-t` + ? | Show tmux help |
| Zoom pane | `Ctrl-t` + 1 | Toggle zoom for the current pane |
| Split vertically (cwd) | `Ctrl-t` + 2 | Split vertically, preserving current path |
| Split horizontally (cwd) | `Ctrl-t` + 3 | Split horizontally, preserving current path |
| Resize left | `Ctrl-t` + C-h | Resize pane left by 5 units |
| Resize right | `Ctrl-t` + C-l | Resize pane right by 5 units |
| Resize down | `Ctrl-t` + C-j | Resize pane down by 5 units |
| Resize up | `Ctrl-t` + C-k | Resize pane up by 5 units |
| Swap pane up | `Ctrl-t` + s | Swap the current pane with the one above |
| Kill pane | `Ctrl-t` + k | Close the current pane |
| Show all panes | `Ctrl-t` + i | Temporarily show all panes |
