[![Linux](https://github.com/long-910/dotfiles/actions/workflows/linux.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/linux.yml)
[![macOS](https://github.com/long-910/dotfiles/actions/workflows/macos.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/macos.yml)
[![ShellCheck](https://github.com/long-910/dotfiles/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/shellcheck.yml)
[![License](https://img.shields.io/github/license/long-910/dotfiles)](https://github.com/long-910/dotfiles/blob/main/LICENSE)
[![Sponsor](https://img.shields.io/badge/Sponsor-GitHub-pink?logo=github)](https://github.com/sponsors/long-910)

[English](README.md) | [日本語](README.ja.md) | [中文](README.zh.md)

# dotfiles

Development environment setup scripts for macOS, Ubuntu, and WSL.
Select and install only the feature blocks you need via an interactive menu.

---

## Quick Start

### One-line install (curl)

Clone and run the interactive installer in one command:

```bash
curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
```

To install everything non-interactively:

```bash
curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash -s -- --all
```

The repository is cloned to `~/.dotfiles`. Set `DOTFILES_DIR` to override the location:

```bash
DOTFILES_DIR=~/my-dotfiles curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
```

### bootstrap.sh (git clone)

Select feature blocks from an interactive menu.

```bash
git clone https://github.com/long-910/dotfiles.git
cd dotfiles
bash bootstrap.sh
```

### install_and_configure.sh (Legacy)

All-in-one installer. For environments where `bootstrap.sh` is unavailable.

```bash
git clone https://github.com/long-910/dotfiles.git
cd dotfiles
chmod +x install_and_configure.sh
./install_and_configure.sh
```

---

## Feature Blocks

| Block | Tools | Default |
|-------|-------|---------|
| **Core** | zsh, tmux, lsd, emacs, htop, neofetch, yazi | ON |
| **Shell** | starship, fzf, zoxide, atuin | ON |
| **Dev** | gh, ripgrep, direnv, bat, delta, fd, jq, lazygit | ON |
| **Node.js** | fnm + Node LTS + commitizen | OFF |
| **Docker** | Docker CE + Docker Compose | OFF |

Toggle ON/OFF by entering numbers when `bootstrap.sh` starts.
Non-interactive execution is also available:

```bash
bash bootstrap.sh --all                 # All blocks
bash bootstrap.sh --module shell        # Single module
bash bootstrap.sh --non-interactive     # Auto with defaults
bash bootstrap.sh --list                # List modules
```

---

## Tools

### Prompt & Shell Enhancement

| Tool | Description |
|------|-------------|
| [starship](https://starship.rs/) | Fast, customizable cross-shell prompt |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder. `Ctrl-R` for history, `Ctrl-T` for files |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` replacement. `z proj` jumps to frequent dirs |
| [atuin](https://atuin.sh/) | SQLite-based shell history. `Ctrl-R` for fuzzy search |

### Development Tools

| Tool | Description |
|------|-------------|
| [gh](https://cli.github.com/) | GitHub CLI. Manage PRs and Issues from the terminal |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep alternative. Respects `.gitignore` |
| [direnv](https://direnv.net/) | Auto-load per-directory environment variables |
| [bat](https://github.com/sharkdp/bat) | `cat` alternative with syntax highlighting |
| [delta](https://github.com/dandavison/delta) | Git diff pager with syntax highlighting |
| [fd](https://github.com/sharkdp/fd) | Fast `find` alternative |
| [jq](https://jqlang.github.io/jq/) | Command-line JSON processor |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |

### Terminal Multiplexer

| Tool | Description |
|------|-------------|
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer. Auto-starts on login; exit tmux to close the shell |

tmux starts automatically when you open a new terminal and attaches to the most recent existing session, or creates a new one. Closing tmux also exits the shell. To disable, remove `~/.zshrc.d/tmux.zsh`.

### File Management

| Tool | Description |
|------|-------------|
| [lsd](https://github.com/lsd-rs/lsd) | `ls` alternative with icons |
| [yazi](https://yazi-rs.github.io/) | Terminal file manager. Launch with `yy`, cd to exit dir |

> **WSL2 — icons not displaying?**
> lsd uses [Nerd Fonts](https://www.nerdfonts.com/) for file-type icons. On WSL2 the terminal runs on Windows, so the font must be installed on the **Windows** side:
>
> 1. Download a Nerd Font (e.g. **CaskaydiaCove Nerd Font**, **JetBrainsMono Nerd Font**) from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)
> 2. Right-click the `.ttf` file → **Install for all users**
> 3. In Windows Terminal: **Settings → your Ubuntu profile → Appearance → Font face** → select the installed font (e.g. `CaskaydiaCove Nerd Font Mono`)
> 4. Restart the terminal

---

## Customization

### Prompt (starship)

Edit `config/starship.toml` to customize.
After installation, it is placed at `~/.config/starship.toml`.

### Per-directory Environment Variables (direnv)

Create `.envrc` in your project root:

```bash
export DATABASE_URL="postgresql://localhost/myapp"
export NODE_ENV="development"
```

```bash
direnv allow   # Required on first use
```

### Project Templates

Quickly scaffold projects with the `newproject` function:

```bash
newproject node  my-app      # Node.js project
newproject python my-script  # Python project
```

---

## Secrets Management

Store API keys and environment-specific settings in **`~/.zshrc.local`** (not committed to git).

```bash
cp dotfiles/.zshrc.local.example ~/.zshrc.local
# Edit ~/.zshrc.local with your editor
```

See [Doc/en/secrets.md](Doc/en/secrets.md) for details.

---

## Uninstall

```bash
bash uninstall.sh
```

- Removes deployed files from `~/.zshrc.d/`
- Restores backups of `.zshrc`, `.tmux.conf`, `.emacs.el`
- Removes `~/.config/starship.toml` and `~/.config/atuin/config.toml`
- Removes git `commit.template` setting
- Optionally removes installed packages

---

## Documentation

- [tmux](Doc/en/Tmux.md)
- [zsh](Doc/en/zsh.md)
- [Tools](Doc/en/tools.md)
- [Secrets Management](Doc/en/secrets.md)
- [emacs](Doc/en/emacs.md) | [htop](Doc/en/htop.md) | [neofetch](Doc/en/neofetch.md) | [yazi](Doc/en/yazi.md)

---

## Supported Environments

| Environment | Status |
|-------------|--------|
| macOS (Apple Silicon / Intel) | ✅ |
| Ubuntu 22.04 / 24.04 | ✅ |
| WSL2 (Ubuntu) | ✅ |

---

## License

MIT — See [LICENSE](LICENSE) for details.
