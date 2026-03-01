# zsh 設定

`dotfiles/.zshrc` の設定内容まとめ。

---

## エイリアス

| エイリアス | 展開 | 説明 |
|-----------|------|------|
| `ls` | `lsd` | アイコン付きディレクトリ一覧 |
| `l`, `ll` | `ls -l` | 詳細表示 |
| `la` | `ls -a` | 隠しファイルも表示 |
| `lla` | `ls -la` | 詳細＋隠しファイル |
| `lt` | `ls --tree` | ツリー表示 |
| `llt` | `ll --tree` | 詳細ツリー表示 |
| `rm` | `rm -i` | 削除前に確認 |
| `cp` | `cp -i` | 上書き前に確認 |
| `mv` | `mv -i` | 上書き前に確認 |
| `mkdir` | `mkdir -p` | 中間ディレクトリも作成 |
| `sudo` | `sudo ` | sudo の後ろでもエイリアスを有効化 |

**グローバルエイリアス（パイプ後でも展開される）:**

| エイリアス | 展開 |
|-----------|------|
| `L` | `\| less` |
| `G` | `\| grep` |

---

## キーバインド

emacs 風キーバインド（`bindkey -e`）が基本。

| キー | 動作 |
|------|------|
| `Ctrl-R` | ワイルドカード対応のインクリメンタルヒストリ検索 |
| `Ctrl-A` | 行頭へ移動 |
| `Ctrl-E` | 行末へ移動 |
| `Ctrl-W` | 単語区切り（`/ = ; @ : { } , |` 含む）で1単語削除 |
| `Ctrl-U` | カーソルより前を全削除 |
| `Ctrl-K` | カーソルより後を全削除 |

---

## ヒストリ設定

| 設定 | 値 |
|------|-----|
| 保存件数 (`HISTSIZE` / `SAVEHIST`) | 1,000,000 |
| 保存ファイル | `~/.zsh_history` |
| セッション間共有 | `share_history` |
| 重複除去 | `hist_ignore_all_dups` / `hist_save_nodups` |
| スペース始まりは除外 | `hist_ignore_space` |
| 余分なスペース削除 | `hist_reduce_blanks` |

---

## 主要オプション

| オプション | 効果 |
|-----------|------|
| `auto_cd` | ディレクトリ名だけで `cd` |
| `auto_pushd` | `cd` のたびにディレクトリスタックに積む |
| `pushd_ignore_dups` | スタックの重複を除去 |
| `magic_equal_subst` | `=` の後もパス補完 |
| `interactive_comments` | `#` 以降をコメントとして扱う |
| `no_beep` | ビープ音を無効化 |
| `extended_glob` | 高機能ワイルドカード (`**`, `^`, `~`) |
| `auto_menu` | 補完候補が複数のとき一覧表示 |

---

## 補完設定

- 小文字入力で大文字にもマッチ（`m:{a-z}={A-Z}`）
- `../` の後は現在ディレクトリを補完しない
- `sudo` の後もコマンド名を補完
- `ps` のプロセス名を補完

---

## 関数

### `chpwd` — cd 後に自動 ls

```zsh
cd ~/project   # → 自動的に lsd で一覧表示
```

### `yy` — yazi を使ったディレクトリ移動

```zsh
yy             # yazi を起動し、終了後そのディレクトリに cd
```

すでに yazi 内にいる場合（`YAZI_LEVEL` が設定されている）は `exit` で抜けます。

---

## モジュール読み込み

`.zshrc` 末尾に追加されるブロック：

```zsh
# ~/.zshrc.d/*.zsh を自動読み込み（bootstrap.sh が配置）
for _f in "$HOME/.zshrc.d"/*.zsh; do
  [ -r "$_f" ] && . "$_f"
done

# マシン固有・秘密情報（git 管理外）
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
```

各 `.zshrc.d/*.zsh` は `command -v <tool>` ガードが付いており、
ツールが未インストールでも安全に無視されます。
