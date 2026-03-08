[![Linux](https://github.com/long-910/dotfiles/actions/workflows/linux.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/linux.yml)
[![macOS](https://github.com/long-910/dotfiles/actions/workflows/macos.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/macos.yml)
[![ShellCheck](https://github.com/long-910/dotfiles/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/long-910/dotfiles/actions/workflows/shellcheck.yml)
[![License](https://img.shields.io/github/license/long-910/dotfiles)](https://github.com/long-910/dotfiles/blob/main/LICENSE)
[![Sponsor](https://img.shields.io/badge/Sponsor-GitHub-pink?logo=github)](https://github.com/sponsors/long-910)

[English](README.md) | [日本語](README.ja.md) | [中文](README.zh.md)

# dotfiles

macOS・Ubuntu・WSL 向け開発環境セットアップスクリプト集です。
インタラクティブメニューで必要な機能ブロックだけを選択してインストールできます。

---

## クイックスタート

### ワンライナーインストール（curl）

1コマンドでクローンしてインタラクティブインストーラーを起動：

```bash
curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
```

すべてを非インタラクティブにインストールする場合：

```bash
curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash -s -- --all
```

リポジトリは `~/.dotfiles` にクローンされます。`DOTFILES_DIR` で変更可能：

```bash
DOTFILES_DIR=~/my-dotfiles curl -fsSL https://raw.githubusercontent.com/long-910/dotfiles/main/install.sh | bash
```

### bootstrap.sh（git clone）

インタラクティブメニューで機能ブロックを選択してインストール。

```bash
git clone https://github.com/long-910/dotfiles.git
cd dotfiles
bash bootstrap.sh
```

### install_and_configure.sh（従来版）

一括インストール。`bootstrap.sh` が使用できない環境向け。

```bash
git clone https://github.com/long-910/dotfiles.git
cd dotfiles
chmod +x install_and_configure.sh
./install_and_configure.sh
```

---

## 機能ブロック

| ブロック | 含まれるツール | デフォルト |
|---------|--------------|-----------|
| **Core** | zsh, tmux, lsd, emacs, htop, neofetch, yazi | ON |
| **Shell** | starship, fzf, zoxide, atuin | ON |
| **Dev** | gh, ripgrep, direnv, bat, delta, fd, jq, lazygit | ON |
| **Node.js** | fnm + Node LTS + commitizen | OFF |
| **Docker** | Docker CE + Docker Compose | OFF |

`bootstrap.sh` 起動時に番号を入力して ON/OFF を切り替えられます。
非インタラクティブ実行も可能です：

```bash
bash bootstrap.sh --all                 # 全ブロック
bash bootstrap.sh --module shell        # 特定モジュールのみ
bash bootstrap.sh --non-interactive     # デフォルト設定で自動実行
bash bootstrap.sh --list                # モジュール一覧表示
```

---

## ツール詳細

### プロンプト・シェル強化

| ツール | 説明 |
|-------|------|
| [starship](https://starship.rs/) | 高速・カスタマイズ可能なクロスシェルプロンプト |
| [fzf](https://github.com/junegunn/fzf) | ファジーファインダー。Ctrl-R でヒストリ検索、Ctrl-T でファイル検索 |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` の賢い代替。`z proj` で頻繁に使うディレクトリへジャンプ |
| [atuin](https://atuin.sh/) | SQLite ベースのシェルヒストリ。Ctrl-R でファジー検索 |

### 開発ツール

| ツール | 説明 |
|-------|------|
| [gh](https://cli.github.com/) | GitHub CLI。PR・Issue をターミナルから操作 |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速 grep 代替。`.gitignore` を自動的に尊重 |
| [direnv](https://direnv.net/) | ディレクトリごとの環境変数自動ロード |
| [bat](https://github.com/sharkdp/bat) | シンタックスハイライト付き `cat` 代替 |
| [delta](https://github.com/dandavison/delta) | シンタックスハイライト付き git diff ページャ |
| [fd](https://github.com/sharkdp/fd) | 高速 `find` 代替 |
| [jq](https://jqlang.github.io/jq/) | コマンドライン JSON プロセッサ |
| [lazygit](https://github.com/jesseduffield/lazygit) | git のターミナル UI |

### ターミナルマルチプレクサ

| ツール | 説明 |
|-------|------|
| [tmux](https://github.com/tmux/tmux) | ターミナルマルチプレクサ。ログイン時に自動起動し、tmux 終了でシェルも終了 |

新しいターミナルを開くと tmux が自動的に起動し、既存のセッションがあればアタッチし、なければ新しいセッションを作成します。tmux を終了するとシェルも終了します。無効にするには `~/.zshrc.d/tmux.zsh` を削除してください。

### ファイル管理

| ツール | 説明 |
|-------|------|
| [lsd](https://github.com/lsd-rs/lsd) | アイコン付き `ls` 代替 |
| [yazi](https://yazi-rs.github.io/) | ターミナルファイルマネージャ。`yy` コマンドで起動し、終了後そのディレクトリに移動 |

> **WSL2 でアイコンが表示されない場合**
> lsd のアイコン表示には [Nerd Fonts](https://www.nerdfonts.com/) が必要です。WSL2 ではターミナルが Windows 側で動作するため、フォントは **Windows 側にインストール** する必要があります。
>
> 1. [nerdfonts.com](https://www.nerdfonts.com/font-downloads) から Nerd Font をダウンロード（例：**CaskaydiaCove Nerd Font**、**JetBrainsMono Nerd Font**）
> 2. `.ttf` ファイルを右クリック → **「すべてのユーザーのためにインストール」**
> 3. Windows Terminal：**設定 → Ubuntu プロファイル → 外観 → フォントフェイス** → インストールしたフォントを選択（例：`CaskaydiaCove Nerd Font Mono`）
> 4. ターミナルを再起動

---

## カスタマイズ

### プロンプト (starship)

`config/starship.toml` を編集してカスタマイズできます。
インストール後は `~/.config/starship.toml` に配置されます。

### ディレクトリ別環境変数 (direnv)

プロジェクトルートに `.envrc` を作成：

```bash
export DATABASE_URL="postgresql://localhost/myapp"
export NODE_ENV="development"
```

```bash
direnv allow   # 初回のみ許可
```

### プロジェクトテンプレート

`newproject` 関数でプロジェクトを素早く作成できます：

```bash
newproject node  my-app     # Node.js プロジェクト
newproject python my-script  # Python プロジェクト
```

---

## 秘密情報の管理

API キーや環境固有の設定は **`~/.zshrc.local`** に記載します（git に含まれません）。

```bash
cp dotfiles/.zshrc.local.example ~/.zshrc.local
# エディタで ~/.zshrc.local を編集
```

詳細は [Doc/ja/secrets.md](Doc/ja/secrets.md) を参照してください。

---

## アンインストール

```bash
bash uninstall.sh
```

- `~/.zshrc.d/` 内の配置ファイルを削除
- `.zshrc`、`.tmux.conf`、`.emacs.el` のバックアップを復元
- `~/.config/starship.toml`、`~/.config/atuin/config.toml` を削除
- git の `commit.template` 設定を削除
- 任意でインストールしたパッケージを削除

---

## ドキュメント

- [tmux 設定](Doc/ja/Tmux.md)
- [zsh 設定](Doc/ja/zsh.md)
- [ツール詳細](Doc/ja/tools.md)
- [秘密情報の管理](Doc/ja/secrets.md)
- [emacs](Doc/ja/emacs.md) | [htop](Doc/ja/htop.md) | [neofetch](Doc/ja/neofetch.md) | [yazi](Doc/ja/yazi.md)

---

## 対応環境

| 環境 | 状態 |
|------|------|
| macOS (Apple Silicon / Intel) | ✅ |
| Ubuntu 22.04 / 24.04 | ✅ |
| WSL2 (Ubuntu) | ✅ |

---

## ライセンス

MIT — 詳細は [LICENSE](LICENSE) を参照してください。
