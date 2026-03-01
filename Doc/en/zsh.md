# zsh Configuration

Summary of `dotfiles/.zshrc` settings.

---

## Aliases

| Alias | Expansion | Description |
|-------|-----------|-------------|
| `ls` | `lsd` | Directory listing with icons |
| `l`, `ll` | `ls -l` | Long format |
| `la` | `ls -a` | Include hidden files |
| `lla` | `ls -la` | Long format with hidden files |
| `lt` | `ls --tree` | Tree view |
| `llt` | `ll --tree` | Long format tree view |
| `rm` | `rm -i` | Confirm before deleting |
| `cp` | `cp -i` | Confirm before overwriting |
| `mv` | `mv -i` | Confirm before overwriting |
| `mkdir` | `mkdir -p` | Create intermediate directories |
| `sudo` | `sudo ` | Enable aliases after sudo |

**Global aliases (expand even after pipe):**

| Alias | Expansion |
|-------|-----------|
| `L` | `\| less` |
| `G` | `\| grep` |

---

## Key Bindings

Emacs-style key bindings (`bindkey -e`) are enabled by default.

| Key | Action |
|-----|--------|
| `Ctrl-R` | Incremental history search with wildcard support |
| `Ctrl-A` | Move to beginning of line |
| `Ctrl-E` | Move to end of line |
| `Ctrl-W` | Delete one word backward (splits on `/=;@:{},|`) |
| `Ctrl-U` | Delete everything before cursor |
| `Ctrl-K` | Delete everything after cursor |

---

## History Settings

| Setting | Value |
|---------|-------|
| Size (`HISTSIZE` / `SAVEHIST`) | 1,000,000 |
| File | `~/.zsh_history` |
| Share across sessions | `share_history` |
| Deduplication | `hist_ignore_all_dups` / `hist_save_nodups` |
| Skip space-prefixed commands | `hist_ignore_space` |
| Strip extra whitespace | `hist_reduce_blanks` |

---

## Key Options

| Option | Effect |
|--------|--------|
| `auto_cd` | `cd` by typing a directory name alone |
| `auto_pushd` | Push to directory stack on every `cd` |
| `pushd_ignore_dups` | No duplicate entries in directory stack |
| `magic_equal_subst` | Path completion after `=` |
| `interactive_comments` | Treat `#` as comment in interactive shell |
| `no_beep` | Disable bell |
| `extended_glob` | Advanced wildcards (`**`, `^`, `~`) |
| `auto_menu` | Show completion menu when multiple candidates exist |

---

## Completion

- Lowercase input matches uppercase (`m:{a-z}={A-Z}`)
- Skip current directory after `../`
- Complete command names after `sudo`
- Complete process names for `ps`

---

## Functions

### `chpwd` — auto ls after cd

```zsh
cd ~/project   # → automatically runs lsd
```

### `yy` — directory-aware yazi launcher

```zsh
yy             # Launch yazi; cd to its exit directory afterward
```

If already inside yazi (`YAZI_LEVEL` is set), `exit` leaves the inner shell.

---

## Modular Loading

Block appended to the end of `.zshrc`:

```zsh
# Auto-load ~/.zshrc.d/*.zsh (placed by bootstrap.sh)
for _f in "$HOME/.zshrc.d"/*.zsh; do
  [ -r "$_f" ] && . "$_f"
done

# Machine-specific / secret config (never committed)
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
```

Each `.zshrc.d/*.zsh` file has a `command -v <tool>` guard so it is safely
skipped when the tool is not installed.
