# ツール詳細ガイド

`bootstrap.sh` の Shell / Dev ブロックでインストールされるツールの設定と使い方。

---

## starship

**設定ファイル:** `~/.config/starship.toml`（`config/starship.toml` から配置）

2行プロンプト。カレントディレクトリ・git ブランチ・言語バージョン・コマンド実行時間を表示。
Node.js・Python・Rust などは関連ファイルが存在する場合のみ表示。

カスタマイズ例：

```toml
# starship.toml
[directory]
truncation_length = 3

[cmd_duration]
min_time = 5000   # 5秒以上のコマンドのみ表示
```

---

## fzf

**キーバインド:**

| キー | 動作 |
|------|------|
| `Ctrl-T` | ファイル検索して挿入 |
| `Ctrl-R` | ヒストリ検索 |
| `Alt-C` | ディレクトリに移動 |

**カスタム関数（fzf.zsh）:**

```zsh
fcd          # ファジーでディレクトリ移動
fkill        # ファジーでプロセス kill
```

ripgrep がある場合は `.gitignore` を自動的に尊重してファイル検索します。

---

## zoxide

`cd` の賢い代替。頻繁に移動するディレクトリを学習します。

```zsh
z proj         # "proj" を含むよく使うディレクトリへ移動
z do sh        # "do" と "sh" を含むディレクトリへ
zi             # fzf でインタラクティブ選択
```

---

## atuin

SQLite ベースのシェルヒストリ。

**キーバインド:**

| キー | 動作 |
|------|------|
| `Ctrl-R` | ファジーヒストリ検索 |
| `↑` | 通常のヒストリ（無効化していないため従来通り） |

**設定ファイル:** `~/.config/atuin/config.toml`（`config/atuin/config.toml` から配置）

---

## direnv

ディレクトリごとの環境変数自動ロード。

```bash
# プロジェクトで .envrc を作成
echo 'export API_KEY="dev-key"' > .envrc
direnv allow

# ディレクトリを出ると自動的に環境変数がクリアされる
```

---

## gh (GitHub CLI)

```bash
gh pr list                        # PR 一覧
gh pr create --fill               # PR 作成（コミットメッセージから自動）
gh pr checkout 123                # PR をローカルにチェックアウト
gh issue create -t "Bug" -b "..."  # Issue 作成
gh repo clone user/repo           # リポジトリのクローン
```

---

## ripgrep (rg)

高速 grep 代替。`.gitignore` を自動尊重。

```bash
rg "TODO"                   # カレントディレクトリを再帰検索
rg -t py "def main"        # Python ファイルのみ
rg -l "import react"       # ファイル名のみ表示
rg --hidden "secret"       # 隠しファイルも検索
```

---

## bat

シンタックスハイライト付き `cat`。

```bash
bat file.py                 # シンタックスハイライト表示
bat --plain file.py         # 行番号なし
bat -A file.py              # 制御文字を表示
```

---

## delta

シンタックスハイライト付き git diff ページャ。`_setup_git_config` で自動設定されます。

```bash
git diff                    # delta が自動的に使われる
git log -p                  # コミット差分も delta で表示
```

---

## lazygit

git の TUI クライアント。

```bash
lazygit    # または lg
```

**主要キーバインド（lazygit 内）:**

| キー | 動作 |
|------|------|
| `s` | ステージング |
| `c` | コミット |
| `p` | push |
| `P` | pull |
| `?` | ヘルプ |

---

## commit.zsh の git エイリアス

| エイリアス | コマンド |
|-----------|---------|
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
| `glog` | ワンライン git log (20件) |
| `glogg` | グラフ付き git log (30件) |

**コンベンショナルコミット:**

```bash
gcommit feat "add dark mode"       # feat: add dark mode
gcommit fix "login crash" auth     # fix(auth): login crash
```
