# htop

Interactive process viewer. A feature-rich alternative to `top`.

---

## Launch

```bash
htop
```

---

## Key Bindings

### Navigation

| Key | Action |
|-----|--------|
| `↑` / `↓` | Select process |
| `PgUp` / `PgDn` | Page up/down |
| `Home` / `End` | Jump to first/last |

### Sorting

| Key | Action |
|-----|--------|
| `P` | Sort by CPU usage |
| `M` | Sort by memory usage |
| `T` | Sort by run time |
| `F6` or `>` | Choose sort column |
| `I` | Invert sort order |

### Filter & Search

| Key | Action |
|-----|--------|
| `F3` or `/` | Search by process name |
| `F4` or `\` | Filter (narrow down) |
| `F5` | Toggle tree view |

### Process Management

| Key | Action |
|-----|--------|
| `F9` or `k` | Send signal (kill) |
| `F7` or `]` | Lower nice value (higher priority) |
| `F8` or `[` | Raise nice value (lower priority) |
| `Space` | Tag process (multi-select) |
| `U` | Untag all |

### View Toggles

| Key | Action |
|-----|--------|
| `F2` | Settings screen |
| `F1` or `h` | Help |
| `t` | Toggle tree view |
| `H` | Show/hide user threads |
| `K` | Show/hide kernel threads |

### Other

| Key | Action |
|-----|--------|
| `F10` or `q` | Quit |
| `u` | Show processes for a specific user |
| `a` | Set CPU affinity for a process |

---

## Configuration File

Settings are saved to `~/.config/htop/htoprc` (configurable via `F2`).

---

## Reading the Display

Top-section meters:
- **CPU bars** — Per-core usage (color-coded: `user` / `system` / `nice` / `io-wait`)
- **Mem / Swp bars** — Memory and swap usage
- **Tasks / Load / Uptime** — Process count, load average, system uptime
