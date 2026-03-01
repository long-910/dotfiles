# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

---

## [0.5.0] - 2026-03-01

### Added
- **Kali Linux style starship prompt** (`config/starship.toml`): two-line prompt with `┌──(user@host)─[dir git]` / `└─$` layout; always shows username and hostname; git branch/status, Node/Python/Rust/Go version indicators
- **tmux auto-attach** (`dotfiles/.zshrc.d/tmux.zsh`): attaches to the most recent existing session on shell start, or creates a new one; uses `exec` so closing tmux exits the shell; skips VSCode terminal

### Fixed
- ShellCheck CI: add `# shellcheck shell=bash` directive to all `dotfiles/.zshrc.d/*.zsh` files (SC2148, SC1103)
- ShellCheck CI: add `# shellcheck disable=SC1090` for non-constant `source` in `fzf.zsh` (SC1090)
- ShellCheck CI: move color variables out of `printf` format strings in `bootstrap.sh` and `uninstall.sh` (SC2059)
- ShellCheck CI: remove unnecessary `$` in array subscripts in `bootstrap.sh` (SC2004)
- ShellCheck CI: remove unused `DIM` color variable from `modules/lib.sh` (SC2034)
- ShellCheck CI: replace `# shellcheck source=` with `# shellcheck disable=SC1091` in `uninstall.sh` (SC1091)
- Linux CI: make `yazi` cargo build failure non-fatal in `modules/core.sh`
- Linux CI: pre-install `yazi` binary from GitHub releases in workflow to avoid `cargo` compile failure

### Maintenance
- `dotfiles/.zshrc`: remove duplicate tmux auto-attach block (superseded by `tmux.zsh`)
- `uninstall.sh`: add `tmux.zsh` to `ZSHRC_D_FILES` so it is removed on uninstall
- `tests/test_configs.sh`: add `tmux.zsh` to `.zshrc.d` file existence check
- `README.md/ja/zh`: fix tmux session description (removed incorrect "named `main`" reference)
- `CLAUDE.md`: add `tmux.zsh` to `.zshrc.d/` structure listing

---

## [0.4.0] - 2026-03-01

### Added
- **Modular bootstrap system** (`bootstrap.sh`): interactive feature-selection menu, supports `--all`, `--module <name>`, `--list`, `--non-interactive` flags
- **Uninstall script** (`uninstall.sh`): removes deployed configs and restores backups in one command
- **Module system** (`modules/`):
  - `lib.sh` — shared helpers: color output, OS detection, `pkg_install`, `backup_file`, `deploy_config`
  - `core.sh` — zsh, tmux, lsd, emacs, htop, neofetch, yazi + tmux-mem-cpu-load build
  - `shell.sh` — starship, fzf, zoxide, atuin
  - `dev.sh` — gh, ripgrep, direnv, bat, delta, fd, jq, lazygit + git global config
  - `node.sh` — fnm + Node LTS + commitizen
  - `docker.sh` — Docker CE + Docker Compose
- **`.zshrc.d/` pattern**: per-tool zsh configs with `command -v` guards
  - `fzf.zsh`, `zoxide.zsh`, `starship.zsh`, `atuin.zsh`, `direnv.zsh`, `node.zsh`, `docker.zsh`, `commit.zsh`
- **Tool configs**: `config/starship.toml`, `config/atuin/config.toml`
- **Project templates**: `templates/node/`, `templates/python/`
- **Test suite** (`tests/run_tests.sh`)
- **Linux CI job**: `Install Bootstrap` and `Tests` jobs added to `linux.yml`

---

## [0.3.0] - 2026-03-01

### Added
- **Multilingual documentation**: English (`Doc/en/`), Japanese (`Doc/ja/`), Simplified Chinese (`Doc/zh/`) — 8 files each covering tmux, zsh, tools, secrets, emacs, htop, neofetch, yazi
- **Multilingual README**: `README.md` (English default), `README.ja.md`, `README.zh.md` with language switcher links
- **Git commit template** (`dotfiles/.gitmessage`) for conventional commits
- **Secrets template** (`dotfiles/.zshrc.local.example`)

### Changed
- CI improvements and workflow refinements

---

## [0.2.1] - 2025-xx-xx

### Added
- **yazi** file manager: install + `yy` wrapper function in `.zshrc` to `cd` to the directory yazi exits in

---

## [0.2.0] - 2025-xx-xx

### Added
- **lsd** (ls Deluxe): `ls` aliased to `lsd` in `.zshrc`
- **htop** process viewer
- **neofetch** system info tool

---

## [0.1.1] - 2025-xx-xx

### Fixed
- tmux pane border styling
- tmux `pane_current_path` for new splits

---

## [0.1.0] - 2025-xx-xx

### Added
- Initial dotfiles setup: `.zshrc`, `.tmux.conf`, `.emacs.el`
- Automated installer `install_and_configure.sh` (macOS + Ubuntu/Debian)
- tmux-mem-cpu-load integration for status bar CPU/memory display
- GitHub Actions CI: ShellCheck, Linux, macOS workflows
- MIT License
