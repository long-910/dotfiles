# 密钥管理

**切勿将 API 密钥、令牌或其他密钥提交到 git 仓库。**
本文档说明如何在 dotfiles 中安全地管理密钥。

---

## 使用 ~/.zshrc.local（推荐）

`.zshrc.local` 不受 git 管理，且会由 `~/.zshrc` 自动加载。

```bash
# 复制模板
cp dotfiles/.zshrc.local.example ~/.zshrc.local

# 用编辑器修改
$EDITOR ~/.zshrc.local
```

`.zshrc.local` 内容示例：

```zsh
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export AWS_DEFAULT_REGION="ap-northeast-1"
```

`.gitignore` 中已添加 `*.local`，不会被意外提交。

---

## 使用 direnv（按项目）

对于每个项目使用不同凭据的场景，`direnv` 非常方便。

```bash
# 在项目目录中
echo 'export DATABASE_URL="postgresql://localhost/myapp_dev"' > .envrc
direnv allow
```

建议将 `.envrc` 添加到项目的 `.gitignore`：

```
.envrc
.envrc.local
```

---

## 密钥管理工具（进阶）

需要更强大管理时：

| 工具 | 用途 |
|------|------|
| [1Password CLI](https://developer.1password.com/docs/cli/) | 从 1Password 注入密钥 |
| [Bitwarden CLI](https://bitwarden.com/help/cli/) | 从 Bitwarden 注入密钥 |
| [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) | 云端密钥管理 |
| [HashiCorp Vault](https://www.vaultproject.io/) | 企业级密钥管理 |

---

## 如果不小心提交了密钥

1. **立即撤销并轮换密钥**
2. 从 git 历史中删除密钥：
   ```bash
   # 使用 BFG Repo Cleaner
   bfg --replace-text secrets.txt
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```
3. 通知团队成员

> [!CAUTION]
> 一旦推送，即使"已删除"，密钥也可能已经泄露。
> 务必轮换您的密钥。
