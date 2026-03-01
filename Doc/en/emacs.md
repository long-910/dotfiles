# emacs Configuration

Summary of `dotfiles/.emacs.el` settings.
Installed to: `~/.emacs.el`

---

## Package Setup

MELPA and Marmalade are added as package archives and `package-initialize` is called.

```elisp
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
```

---

## Key Binding Customization

| Key | Action |
|-----|--------|
| `Ctrl-Z` | Undo (overrides the default `suspend-frame`) |

---

## Auto-complete

Uses `auto-complete-config`.

- `TAB` triggers completion
- Use `Ctrl-N` / `Ctrl-P` to navigate the completion menu
- Fuzzy matching enabled
- Enabled modes: `text-mode`, `fundamental-mode`, `org-mode`, `yatex-mode`

---

## Python Completion (jedi)

`jedi.el` provides Python code completion.

- Auto-triggers on `.` (dot) with `jedi:complete-on-dot`
- `<C-tab>` unbound from jedi to use for window navigation
- Completion sources: filenames + jedi direct (word completion from same-mode buffers removed)

---

## Display Settings

| Setting | Effect |
|---------|--------|
| `show-paren-mode` | Highlight matching parentheses |
| `global-linum-mode` | Show line numbers in all buffers (3-digit width) |

---

## Load Path

```elisp
(setq load-path (cons "~/.emacs.d/elisp" load-path))
```

Place local Emacs Lisp files in `~/.emacs.d/elisp/`.
