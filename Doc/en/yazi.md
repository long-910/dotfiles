# Yazi

Terminal file manager. Written in Rust; asynchronous and fast.

---

## Launch

```bash
yy     # Launch yazi; automatically cd to exit directory
yazi   # Direct launch (no cd after exit)
```

`yy` is a function defined in `.zshrc` that carries yazi's exit directory back to the shell.
If already inside yazi (`YAZI_LEVEL` is set), it runs `exit` to leave the inner shell.

---

## Key Bindings

### Navigation

| Key | Action |
|-----|--------|
| `h` or `←` | Go to parent directory |
| `l` or `→` / `Enter` | Open selected item (enter directory) |
| `j` or `↓` | Move down |
| `k` or `↑` | Move up |
| `gg` | Jump to top |
| `G` | Jump to bottom |
| `H` | Jump to top of screen |
| `M` | Jump to middle of screen |
| `L` | Jump to bottom of screen |

### File Operations

| Key | Action |
|-----|--------|
| `Space` | Tag file (multi-select) |
| `v` | Toggle visual mode (select all, etc.) |
| `y` | Yank (copy) |
| `x` | Cut |
| `p` | Paste |
| `d` | Move to trash |
| `D` | Permanently delete (with confirmation) |
| `a` | Create new file / directory (trailing `/` for directory) |
| `r` | Rename |

### View & Search

| Key | Action |
|-----|--------|
| `.` | Toggle hidden files |
| `/` | Filter by filename |
| `f` | Fuzzy search (fzf-like) |
| `s` | Change sort order |
| `z` | Jump to directory with zoxide |

### Tabs

| Key | Action |
|-----|--------|
| `t` | Open new tab |
| `1` – `9` | Switch to tab |
| `[` / `]` | Previous / next tab |

### Other

| Key | Action |
|-----|--------|
| `q` | Quit |
| `~` | Go to home directory |
| `-` | Go back to previous directory |
| `o` | Open with default application |
| `e` | Open with editor |
| `i` | Full-screen preview |
| `?` | Show all key bindings |

---

## Configuration Files

Place configuration in `~/.config/yazi/` (defaults are used if not present).

```
~/.config/yazi/
├── yazi.toml      # General settings (sorting, etc.)
├── keymap.toml    # Key binding customization
├── theme.toml     # Theme and colors
└── plugins/       # Plugins
```

---

## Preview Support

Asynchronously previews text, images (on supported terminals), PDFs, audio, and video thumbnails.
Image preview requires kitty, iTerm2, WezTerm, or another compatible terminal.
