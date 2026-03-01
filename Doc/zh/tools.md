# 工具详情指南

`bootstrap.sh` 的 Shell / Dev 模块安装的工具配置与使用说明。

---

## starship

**配置文件：** `~/.config/starship.toml`（从 `config/starship.toml` 部署）

双行提示符。显示当前目录、git 分支、语言版本及命令执行时间。
Node.js、Python、Rust 等仅在目录下存在相关文件时显示。

自定义示例：

```toml
# starship.toml
[directory]
truncation_length = 3

[cmd_duration]
min_time = 5000   # 仅显示执行超过 5 秒的命令
```

---

## fzf

**按键绑定：**

| 按键 | 动作 |
|------|------|
| `Ctrl-T` | 搜索文件并插入命令行 |
| `Ctrl-R` | 搜索命令历史 |
| `Alt-C` | 交互式切换目录 |

**自定义函数（fzf.zsh）：**

```zsh
fcd          # 模糊切换目录
fkill        # 模糊 kill 进程
```

安装 ripgrep 后，文件搜索会自动遵循 `.gitignore`。

---

## zoxide

智能 `cd` 替代。自动学习常用目录。

```zsh
z proj         # 跳转到包含 "proj" 的常用目录
z do sh        # 跳转到同时匹配 "do" 和 "sh" 的目录
zi             # 通过 fzf 交互式选择
```

---

## atuin

基于 SQLite 的 Shell 历史记录。

**按键绑定：**

| 按键 | 动作 |
|------|------|
| `Ctrl-R` | 模糊历史记录搜索 |
| `↑` | 普通历史记录（方向键未被覆盖） |

**配置文件：** `~/.config/atuin/config.toml`（从 `config/atuin/config.toml` 部署）

---

## direnv

按目录自动加载环境变量。

```bash
# 在项目中创建 .envrc
echo 'export API_KEY="dev-key"' > .envrc
direnv allow

# 离开目录后环境变量自动清除
```

---

## gh（GitHub CLI）

```bash
gh pr list                        # 列出 PR
gh pr create --fill               # 创建 PR（从提交信息自动填充）
gh pr checkout 123                # 在本地检出 PR
gh issue create -t "Bug" -b "..."  # 创建 Issue
gh repo clone user/repo           # 克隆仓库
```

---

## ripgrep（rg）

高速 grep 替代。自动遵循 `.gitignore`。

```bash
rg "TODO"                   # 在当前目录递归搜索
rg -t py "def main"        # 仅搜索 Python 文件
rg -l "import react"       # 仅显示文件名
rg --hidden "secret"       # 包含隐藏文件
```

---

## bat

带语法高亮的 `cat` 替代。

```bash
bat file.py                 # 带语法高亮的输出
bat --plain file.py         # 无行号
bat -A file.py              # 显示不可见字符
```

---

## delta

带语法高亮的 git diff 分页器。由 `_setup_git_config` 自动配置。

```bash
git diff                    # delta 自动生效
git log -p                  # 提交差异也使用 delta 显示
```

---

## lazygit

git 的 TUI 客户端。

```bash
lazygit    # 或 lg
```

**lazygit 内部按键：**

| 按键 | 动作 |
|------|------|
| `s` | 暂存文件 |
| `c` | 提交 |
| `p` | push |
| `P` | pull |
| `?` | 帮助 |

---

## git 别名（commit.zsh）

| 别名 | 命令 |
|------|------|
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
| `glog` | 单行 git log（20 条） |
| `glogg` | 带图形的 git log（30 条） |

**约定式提交：**

```bash
gcommit feat "add dark mode"       # feat: add dark mode
gcommit fix "login crash" auth     # fix(auth): login crash
```
