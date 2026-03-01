# Secrets Management

**Never commit API keys, tokens, or other secrets to a git repository.**
This document explains how to manage secrets safely with this dotfiles setup.

---

## Using ~/.zshrc.local (Recommended)

`.zshrc.local` is not tracked by git and is automatically sourced from `~/.zshrc`.

```bash
# Copy the template
cp dotfiles/.zshrc.local.example ~/.zshrc.local

# Edit with your editor
$EDITOR ~/.zshrc.local
```

Example `.zshrc.local` content:

```zsh
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export AWS_DEFAULT_REGION="ap-northeast-1"
```

`*.local` is listed in `.gitignore`, so it won't be accidentally committed.

---

## Using direnv (Per-project)

For per-project credentials, `direnv` is convenient.

```bash
# In your project directory
echo 'export DATABASE_URL="postgresql://localhost/myapp_dev"' > .envrc
direnv allow
```

It is recommended to add `.envrc` to your project's `.gitignore`:

```
.envrc
.envrc.local
```

---

## Secret Management Tools (Advanced)

For more robust management:

| Tool | Use Case |
|------|----------|
| [1Password CLI](https://developer.1password.com/docs/cli/) | Inject secrets from 1Password |
| [Bitwarden CLI](https://bitwarden.com/help/cli/) | Inject secrets from Bitwarden |
| [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) | Cloud secret management |
| [HashiCorp Vault](https://www.vaultproject.io/) | Enterprise secret management |

---

## If You Accidentally Commit a Secret

1. **Immediately revoke and rotate the secret**
2. Remove the secret from git history:
   ```bash
   # Using BFG Repo Cleaner
   bfg --replace-text secrets.txt
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```
3. Notify your team

> [!CAUTION]
> Once pushed, a secret may have been exposed even after "deletion".
> Always rotate your secrets.
