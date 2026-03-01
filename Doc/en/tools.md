# Tools Guide

Configuration and usage guide for tools installed by the Shell and Dev blocks of `bootstrap.sh`.

---

## starship

**Config file:** `~/.config/starship.toml` (deployed from `config/starship.toml`)

Two-line prompt. Displays current directory, git branch, language version, and command duration.
Node.js, Python, Rust, etc. are only shown when relevant files exist in the directory.

Customization example:

```toml
# starship.toml
[directory]
truncation_length = 3

[cmd_duration]
min_time = 5000   # Only show commands taking more than 5 seconds
```

---

## fzf

**Key bindings:**

| Key | Action |
|-----|--------|
| `Ctrl-T` | Search files and insert into command line |
| `Ctrl-R` | Search command history |
| `Alt-C` | Change directory interactively |

**Custom functions (fzf.zsh):**

```zsh
fcd          # Fuzzy change directory
fkill        # Fuzzy process kill
```

When ripgrep is available, file search automatically respects `.gitignore`.

---

## zoxide

Smart `cd` replacement. Learns directories you frequently navigate to.

```zsh
z proj         # Jump to a frequently used directory containing "proj"
z do sh        # Jump to directory matching both "do" and "sh"
zi             # Interactive selection with fzf
```

---

## atuin

SQLite-based shell history.

**Key bindings:**

| Key | Action |
|-----|--------|
| `Ctrl-R` | Fuzzy history search |
| `↑` | Normal history (up arrow not overridden) |

**Config file:** `~/.config/atuin/config.toml` (deployed from `config/atuin/config.toml`)

---

## direnv

Auto-load environment variables per directory.

```bash
# Create .envrc in your project
echo 'export API_KEY="dev-key"' > .envrc
direnv allow

# Variables are automatically cleared when you leave the directory
```

---

## gh (GitHub CLI)

```bash
gh pr list                        # List pull requests
gh pr create --fill               # Create PR (auto-fill from commit messages)
gh pr checkout 123                # Check out PR locally
gh issue create -t "Bug" -b "..."  # Create an issue
gh repo clone user/repo           # Clone a repository
```

---

## ripgrep (rg)

Fast grep alternative. Respects `.gitignore` automatically.

```bash
rg "TODO"                   # Recursive search in current directory
rg -t py "def main"        # Search Python files only
rg -l "import react"       # Show filenames only
rg --hidden "secret"       # Include hidden files
```

---

## bat

`cat` alternative with syntax highlighting.

```bash
bat file.py                 # Syntax-highlighted output
bat --plain file.py         # No line numbers
bat -A file.py              # Show non-printable characters
```

---

## delta

Syntax-highlighted git diff pager. Automatically configured by `_setup_git_config`.

```bash
git diff                    # delta is used automatically
git log -p                  # Commit diffs also use delta
```

---

## lazygit

TUI git client.

```bash
lazygit    # or: lg
```

**Key bindings inside lazygit:**

| Key | Action |
|-----|--------|
| `s` | Stage file |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `?` | Help |

---

## Git aliases (commit.zsh)

| Alias | Command |
|-------|---------|
| `gs` | `git status -sb` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gpl` | `git pull --rebase` |
| `glog` | One-line git log (20 entries) |
| `glogg` | Graph git log (30 entries) |

**Conventional commits:**

```bash
gcommit feat "add dark mode"       # feat: add dark mode
gcommit fix "login crash" auth     # fix(auth): login crash
```
