# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository for setting up a development environment on macOS, Ubuntu/Debian, and WSL2. It includes configuration files for zsh, tmux, emacs, lsd, htop, neofetch, and yazi, along with an automated install script and a modular bootstrap system.

## Repository Structure

```
dotfiles/
├── bootstrap.sh               ← NEW: interactive setup with feature selection
├── uninstall.sh               ← NEW: one-command uninstall
├── install_and_configure.sh   ← ORIGINAL: monolithic installer (DO NOT MODIFY — CI uses it)
├── modules/
│   ├── lib.sh                 ← shared helpers (colors, OS detect, pkg_install, backup)
│   ├── core.sh                ← existing tools: zsh/tmux/lsd/emacs/htop/neofetch/yazi + tmux.zsh
│   ├── shell.sh               ← starship, fzf, zoxide, atuin
│   ├── dev.sh                 ← gh, ripgrep, direnv, bat, delta, fd, jq, lazygit
│   ├── node.sh                ← fnm + Node LTS + commitizen
│   └── docker.sh              ← Docker CE + docker compose
├── dotfiles/
│   ├── .zshrc                 ← deployed to $HOME; has modular sourcing block appended
│   ├── .tmux.conf             ← UNCHANGED
│   ├── .emacs.el              ← UNCHANGED
│   ├── .gitmessage            ← conventional commit template
│   ├── .zshrc.local.example   ← secrets/local config template (copy to ~/.zshrc.local)
│   └── .zshrc.d/
│       ├── tmux.zsh           ← auto-attach to tmux session on shell start
│       ├── fzf.zsh            ← fzf keybindings + rg integration + helpers
│       ├── zoxide.zsh         ← eval "$(zoxide init zsh)"
│       ├── starship.zsh       ← eval "$(starship init zsh)"
│       ├── atuin.zsh          ← eval "$(atuin init zsh --disable-up-arrow)"
│       ├── direnv.zsh         ← eval "$(direnv hook zsh)"
│       ├── node.zsh           ← fnm env initialization
│       ├── docker.zsh         ← docker/compose aliases and helpers
│       └── commit.zsh         ← git aliases + gcommit() + newproject()
├── config/
│   ├── starship.toml          ← two-line prompt with git/node/python info
│   └── atuin/
│       └── config.toml        ← fuzzy search, emacs keybindings, no auto-sync
├── templates/
│   ├── node/                  ← package.json, .gitignore stubs
│   └── python/                ← pyproject.toml, .gitignore stubs
├── Doc/
│   ├── en/                    ← English documentation (default)
│   │   ├── Tmux.md, zsh.md, tools.md, secrets.md
│   │   ├── emacs.md, htop.md, neofetch.md, yazi.md
│   ├── ja/                    ← Japanese documentation
│   │   └── (same files as en/)
│   └── zh/                    ← Simplified Chinese documentation
│       └── (same files as en/)
└── tmux-mem-cpu-load/         ← git submodule / local clone
```

## Running the Install Script (original, CI-tested)

```bash
chmod +x install_and_configure.sh
./install_and_configure.sh
```

## Running bootstrap.sh (new modular system)

```bash
bash bootstrap.sh                        # interactive menu
bash bootstrap.sh --all                  # install everything
bash bootstrap.sh --module shell         # single module
bash bootstrap.sh --non-interactive      # defaults (core+shell+dev)
bash bootstrap.sh --list                 # list modules
```

The bootstrap system:
1. Sources all `modules/*.sh` files
2. Shows an interactive feature selection menu
3. Calls the appropriate `install_<module>()` function for each selected block
4. Calls `setup_zshrc_sourcing()` to append the `.zshrc.d` sourcing block to `~/.zshrc`

## CI / Linting

Three GitHub Actions workflows run on push/PR to `main`:
- **Linux**: runs `install_and_configure.sh` on `ubuntu-latest`
- **MacOS**: runs `install_and_configure.sh` on `macos-latest`
- **ShellCheck**: lints all shell scripts (`.zshrc` is excluded)

To lint locally:
```bash
shellcheck install_and_configure.sh
shellcheck bootstrap.sh uninstall.sh modules/*.sh
```

## Key Configuration Details

### Tmux (`dotfiles/.tmux.conf`)
- Prefix key is `Ctrl-t` (not the default `Ctrl-b`)
- Status bar displays memory/CPU via `tmux-mem-cpu-load`
- Custom pane splits: `prefix+2` = vertical, `prefix+3` = horizontal (both preserve current path)

### Zsh (`dotfiles/.zshrc`)
- `ls` is aliased to `lsd`
- `yy` function wraps yazi to cd to the directory yazi exits in
- History: 1,000,000 entries, shared across sessions, deduplication enabled
- Modular sourcing block at the end loads `~/.zshrc.d/*.zsh` and `~/.zshrc.local`

### .zshrc.d pattern
All per-tool zsh configuration lives in `dotfiles/.zshrc.d/*.zsh`. Each file:
- Guards its `eval` call with `command -v <tool>` so it's a no-op if the tool is not installed
- Is deployed to `~/.zshrc.d/` by the corresponding module's `install_*()` function
- Is sourced automatically by the block appended to `~/.zshrc`

### Secrets
Machine-specific config and secrets go in `~/.zshrc.local` (never committed).
Template: `dotfiles/.zshrc.local.example`

### Adding a New Tool
1. Add installation logic to `modules/dev.sh` or a new `modules/<name>.sh`
2. Create `dotfiles/.zshrc.d/<tool>.zsh` with guarded `eval`/aliases
3. Register in `bootstrap.sh` FEATURE_NAMES/FEATURE_LABELS arrays
4. Add a `deploy_zshrc_d "<tool>.zsh"` call in the module's deploy function
5. Add documentation to `Doc/en/tools.md`, `Doc/ja/tools.md`, `Doc/zh/tools.md`
6. For a core tool: also add `check_and_install "toolname"` to `install_and_configure.sh`
