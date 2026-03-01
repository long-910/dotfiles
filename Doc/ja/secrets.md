# 秘密情報の管理

API キーやトークンなどの秘密情報は **絶対に git リポジトリにコミットしないでください**。
このドキュメントでは、dotfiles リポジトリで秘密情報を安全に管理する方法を説明します。

---

## ~/.zshrc.local を使う（推奨）

`.zshrc.local` は git の管理外ファイルで、`~/.zshrc` から自動的に読み込まれます。

```bash
# テンプレートをコピー
cp dotfiles/.zshrc.local.example ~/.zshrc.local

# エディタで編集
$EDITOR ~/.zshrc.local
```

`.zshrc.local` の内容例：

```zsh
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export AWS_DEFAULT_REGION="ap-northeast-1"
```

`.gitignore` に `*.local` が追加されているため、誤ってコミットされません。

---

## direnv を使う（プロジェクト単位）

プロジェクトごとに異なる認証情報を使う場合は `direnv` が便利です。

```bash
# プロジェクトディレクトリで
echo 'export DATABASE_URL="postgresql://localhost/myapp_dev"' > .envrc
direnv allow
```

`.envrc` は `.gitignore` に追加しておくことを推奨します：

```
.envrc
.envrc.local
```

---

## シークレット管理ツール（上級者向け）

より堅牢な管理が必要な場合：

| ツール | 用途 |
|-------|------|
| [1Password CLI](https://developer.1password.com/docs/cli/) | 1Password からシークレットを注入 |
| [Bitwarden CLI](https://bitwarden.com/help/cli/) | Bitwarden からシークレットを注入 |
| [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) | クラウドシークレット管理 |
| [HashiCorp Vault](https://www.vaultproject.io/) | エンタープライズ向けシークレット管理 |

---

## 誤ってコミットしてしまった場合

1. **すぐにシークレットを無効化・ローテーション**する
2. git 履歴からシークレットを削除する：
   ```bash
   # BFG Repo Cleaner を使用
   bfg --replace-text secrets.txt
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```
3. チームメンバーに通知する

> [!CAUTION]
> 一度 push したシークレットは「削除済み」でも外部に漏洩した可能性があります。
> 必ずシークレットをローテーションしてください。
