[![Linux](https://github.com/long-910/dotfiles/actions/workflows/linux.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/linux.yml)
[![macOS](https://github.com/long-910/dotfiles/actions/workflows/macos.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/macos.yml)
[![ShellCheck](https://github.com/long-910/dotfiles/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/shellcheck.yml)
[![License](https://img.shields.io/github/license/long-910/dotfiles)](https://github.com/long-910/dotfiles/blob/main/LICENSE)
[![Sponsor](https://img.shields.io/badge/Sponsor-GitHub-pink?logo=github)](https://github.com/sponsors/long-910)

[English](README.md) | [日本語](README.ja.md) | [中文](README.zh.md)

# dotfiles

适用于 macOS、Ubuntu 和 WSL 的开发环境搭建脚本。
通过交互式菜单选择并安装所需的功能模块。

---

## 快速开始

### 一键安装（curl）

用一条命令克隆并启动交互式安装程序：

```bash
curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
```

非交互式安装所有模块：

```bash
curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash -s -- --all
```

仓库将克隆到 `~/.dotfiles`，可通过 `DOTFILES_DIR` 自定义路径：

```bash
DOTFILES_DIR=~/my-dotfiles curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
```

### bootstrap.sh（git clone）

通过交互式菜单选择功能模块进行安装。

```bash
git clone https://github.com/long-910/dotfiles.git
cd dotfiles
bash bootstrap.sh
```

### install_and_configure.sh（传统方式）

一键安装。适用于 `bootstrap.sh` 无法使用的环境。

```bash
git clone https://github.com/long-910/dotfiles.git
cd dotfiles
chmod +x install_and_configure.sh
./install_and_configure.sh
```

---

## 功能模块

| 模块 | 包含工具 | 默认 |
|------|---------|------|
| **Core** | zsh, tmux, lsd, emacs, htop, neofetch, yazi | ON |
| **Shell** | starship, fzf, zoxide, atuin | ON |
| **Dev** | gh, ripgrep, direnv, bat, delta, fd, jq, lazygit | ON |
| **Node.js** | fnm + Node LTS + commitizen | OFF |
| **Docker** | Docker CE + Docker Compose | OFF |

启动 `bootstrap.sh` 时输入数字来切换 ON/OFF。也支持非交互式执行：

```bash
bash bootstrap.sh --all                 # 安装所有模块
bash bootstrap.sh --module shell        # 仅安装指定模块
bash bootstrap.sh --non-interactive     # 使用默认配置自动运行
bash bootstrap.sh --list                # 列出所有模块
```

---

## 工具详情

### 提示符与 Shell 增强

| 工具 | 说明 |
|------|------|
| [starship](https://starship.rs/) | 快速、可定制的跨 Shell 提示符 |
| [fzf](https://github.com/junegunn/fzf) | 模糊查找器。`Ctrl-R` 搜索历史记录，`Ctrl-T` 搜索文件 |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | 智能 `cd` 替代。`z proj` 跳转到常用目录 |
| [atuin](https://atuin.sh/) | 基于 SQLite 的 Shell 历史记录。`Ctrl-R` 模糊搜索 |

### 开发工具

| 工具 | 说明 |
|------|------|
| [gh](https://cli.github.com/) | GitHub CLI。在终端管理 PR 和 Issue |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速 grep 替代。自动遵循 `.gitignore` |
| [direnv](https://direnv.net/) | 按目录自动加载环境变量 |
| [bat](https://github.com/sharkdp/bat) | 带语法高亮的 `cat` 替代 |
| [delta](https://github.com/dandavison/delta) | 带语法高亮的 git diff 分页器 |
| [fd](https://github.com/sharkdp/fd) | 高速 `find` 替代 |
| [jq](https://jqlang.github.io/jq/) | 命令行 JSON 处理器 |
| [lazygit](https://github.com/jesseduffield/lazygit) | git 的终端 UI |

### 终端复用器

| 工具 | 说明 |
|------|------|
| [tmux](https://github.com/tmux/tmux) | 终端复用器。登录时自动启动；退出 tmux 同时退出 Shell |

打开新终端时 tmux 会自动启动，并附加到最近的现有会话（不存在则创建新会话）。关闭 tmux 时 Shell 也会一并退出。如需禁用，请删除 `~/.zshrc.d/tmux.zsh`。

### 文件管理

| 工具 | 说明 |
|------|------|
| [lsd](https://github.com/lsd-rs/lsd) | 带图标的 `ls` 替代 |
| [yazi](https://yazi-rs.github.io/) | 终端文件管理器。用 `yy` 启动，退出后自动切换目录 |

---

## 自定义

### 提示符（starship）

编辑 `config/starship.toml` 进行自定义。
安装后文件位于 `~/.config/starship.toml`。

### 按目录加载环境变量（direnv）

在项目根目录创建 `.envrc`：

```bash
export DATABASE_URL="postgresql://localhost/myapp"
export NODE_ENV="development"
```

```bash
direnv allow   # 首次使用时需要授权
```

### 项目模板

使用 `newproject` 函数快速创建项目：

```bash
newproject node  my-app      # Node.js 项目
newproject python my-script  # Python 项目
```

---

## 密钥管理

API 密钥和特定于机器的配置请写入 **`~/.zshrc.local`**（不会提交到 git）。

```bash
cp dotfiles/.zshrc.local.example ~/.zshrc.local
# 用编辑器修改 ~/.zshrc.local
```

详情请参阅 [Doc/zh/secrets.md](Doc/zh/secrets.md)。

---

## 卸载

```bash
bash uninstall.sh
```

- 删除 `~/.zshrc.d/` 中部署的文件
- 恢复 `.zshrc`、`.tmux.conf`、`.emacs.el` 的备份
- 删除 `~/.config/starship.toml` 和 `~/.config/atuin/config.toml`
- 删除 git `commit.template` 配置
- 可选择性地卸载已安装的软件包

---

## 文档

- [tmux 配置](Doc/zh/Tmux.md)
- [zsh 配置](Doc/zh/zsh.md)
- [工具详情](Doc/zh/tools.md)
- [密钥管理](Doc/zh/secrets.md)
- [emacs](Doc/zh/emacs.md) | [htop](Doc/zh/htop.md) | [neofetch](Doc/zh/neofetch.md) | [yazi](Doc/zh/yazi.md)

---

## 支持环境

| 环境 | 状态 |
|------|------|
| macOS (Apple Silicon / Intel) | ✅ |
| Ubuntu 22.04 / 24.04 | ✅ |
| WSL2 (Ubuntu) | ✅ |

---

## 许可证

MIT — 详情请参阅 [LICENSE](LICENSE)。
