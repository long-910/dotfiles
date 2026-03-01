# emacs 配置

`dotfiles/.emacs.el` 配置内容概览。
安装路径：`~/.emacs.el`

---

## 软件包配置

添加 MELPA 和 Marmalade 软件包源，并调用 `package-initialize`。

```elisp
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
```

---

## 按键绑定自定义

| 按键 | 动作 |
|------|------|
| `Ctrl-Z` | 撤销（覆盖默认的 `suspend-frame`） |

---

## 自动补全（auto-complete）

使用 `auto-complete-config`。

- `TAB` 触发补全
- 补全菜单显示时用 `Ctrl-N` / `Ctrl-P` 选择候选项
- 启用模糊匹配
- 启用的模式：`text-mode`、`fundamental-mode`、`org-mode`、`yatex-mode`

---

## Python 补全（jedi）

`jedi.el` 提供 Python 代码补全。

- 输入 `.` 时自动触发补全（`jedi:complete-on-dot`）
- `<C-tab>` 从 jedi 解绑，用于窗口切换
- 补全源：文件名 + jedi 直接补全（已移除同模式词汇补全）

---

## 显示设置

| 设置 | 效果 |
|------|------|
| `show-paren-mode` | 高亮匹配括号 |
| `global-linum-mode` | 所有缓冲区显示行号（3 位宽） |

---

## 加载路径

```elisp
(setq load-path (cons "~/.emacs.d/elisp" load-path))
```

可将本地 Emacs Lisp 文件放置于 `~/.emacs.d/elisp/`。
