# emacs 設定

`dotfiles/.emacs.el` の設定内容まとめ。
インストール先: `~/.emacs.el`

---

## パッケージ設定

MELPA と Marmalade を追加して `package-initialize` を実行。

```elisp
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
```

---

## キーバインドカスタマイズ

| キー | 動作 |
|------|------|
| `Ctrl-Z` | undo（デフォルトの `suspend-frame` を上書き） |

---

## 自動補完 (auto-complete)

`auto-complete-config` を使用。

- `TAB` で補完トリガー
- 補完メニュー表示中は `Ctrl-N` / `Ctrl-P` で候補選択
- 曖昧マッチ（fuzzy）有効
- 有効モード: `text-mode`, `fundamental-mode`, `org-mode`, `yatex-mode`

---

## Python 補完 (jedi)

`jedi.el` で Python のコード補完を提供。

- `.` 入力で自動補完トリガー（`jedi:complete-on-dot`）
- `<C-tab>` は jedi から外し、ウィンドウ移動に使用
- 補完ソース: ファイル名 + jedi ダイレクト（同一モードの単語補完は除外）

---

## 表示設定

| 設定 | 効果 |
|------|------|
| `show-paren-mode` | 対応する括弧をハイライト |
| `global-linum-mode` | 全バッファで行番号を表示（3桁幅） |

---

## ロードパス

```elisp
(setq load-path (cons "~/.emacs.d/elisp" load-path))
```

`~/.emacs.d/elisp/` にローカルの Emacs Lisp ファイルを置けます。
