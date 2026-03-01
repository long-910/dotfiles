# zsh 配置

`dotfiles/.zshrc` 配置内容概览。

---

## 别名

| 别名 | 展开 | 说明 |
|------|------|------|
| `ls` | `lsd` | 带图标的目录列表 |
| `l`, `ll` | `ls -l` | 详细格式 |
| `la` | `ls -a` | 包含隐藏文件 |
| `lla` | `ls -la` | 详细格式 + 隐藏文件 |
| `lt` | `ls --tree` | 树形显示 |
| `llt` | `ll --tree` | 详细树形显示 |
| `rm` | `rm -i` | 删除前确认 |
| `cp` | `cp -i` | 覆盖前确认 |
| `mv` | `mv -i` | 覆盖前确认 |
| `mkdir` | `mkdir -p` | 自动创建中间目录 |
| `sudo` | `sudo ` | 在 sudo 后也启用别名 |

**全局别名（管道后也可展开）：**

| 别名 | 展开 |
|------|------|
| `L` | `\| less` |
| `G` | `\| grep` |

---

## 按键绑定

默认启用 Emacs 风格按键绑定（`bindkey -e`）。

| 按键 | 动作 |
|------|------|
| `Ctrl-R` | 支持通配符的增量历史记录搜索 |
| `Ctrl-A` | 移动到行首 |
| `Ctrl-E` | 移动到行尾 |
| `Ctrl-W` | 按词删除（分隔符包括 `/=;@:{},|`） |
| `Ctrl-U` | 删除光标之前的所有内容 |
| `Ctrl-K` | 删除光标之后的所有内容 |

---

## 历史记录设置

| 设置 | 值 |
|------|-----|
| 大小（`HISTSIZE` / `SAVEHIST`） | 1,000,000 |
| 文件 | `~/.zsh_history` |
| 会话间共享 | `share_history` |
| 去重 | `hist_ignore_all_dups` / `hist_save_nodups` |
| 跳过空格开头的命令 | `hist_ignore_space` |
| 去除多余空格 | `hist_reduce_blanks` |

---

## 主要选项

| 选项 | 效果 |
|------|------|
| `auto_cd` | 直接输入目录名即可 `cd` |
| `auto_pushd` | 每次 `cd` 都压入目录栈 |
| `pushd_ignore_dups` | 目录栈不保留重复项 |
| `magic_equal_subst` | `=` 后也进行路径补全 |
| `interactive_comments` | 交互式 shell 中 `#` 视为注释 |
| `no_beep` | 禁用提示音 |
| `extended_glob` | 高级通配符（`**`、`^`、`~`） |
| `auto_menu` | 补全候选多时显示菜单 |

---

## 补全设置

- 小写输入匹配大写（`m:{a-z}={A-Z}`）
- `../` 后不补全当前目录
- `sudo` 后也补全命令名
- 补全 `ps` 的进程名

---

## 函数

### `chpwd` — cd 后自动 ls

```zsh
cd ~/project   # → 自动执行 lsd 列出目录内容
```

### `yy` — 带目录切换的 yazi 启动器

```zsh
yy             # 启动 yazi，退出后自动 cd 到对应目录
```

若已在 yazi 内部（`YAZI_LEVEL` 已设置），则执行 `exit` 退出内层 shell。

---

## 模块化加载

追加到 `.zshrc` 末尾的代码块：

```zsh
# 自动加载 ~/.zshrc.d/*.zsh（由 bootstrap.sh 部署）
for _f in "$HOME/.zshrc.d"/*.zsh; do
  [ -r "$_f" ] && . "$_f"
done

# 机器专属 / 密钥配置（不纳入 git 管理）
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
```

每个 `.zshrc.d/*.zsh` 文件都带有 `command -v <工具>` 检查，未安装该工具时会安全跳过。
