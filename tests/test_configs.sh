#!/usr/bin/env bash
# tests/test_configs.sh — File existence and content validation (no installs)

run_tests() {
  local r="$REPO_ROOT"

  # ── Executables ─────────────────────────────────────────────────────────────
  assert_executable "bootstrap.sh is executable"  "${r}/bootstrap.sh"
  assert_executable "uninstall.sh is executable"  "${r}/uninstall.sh"

  # ── Module files ────────────────────────────────────────────────────────────
  for _m in lib.sh core.sh shell.sh dev.sh node.sh docker.sh; do
    assert_file_exists "modules/${_m}" "${r}/modules/${_m}"
  done

  # ── .zshrc.d files ──────────────────────────────────────────────────────────
  for _f in tmux.zsh fzf.zsh zoxide.zsh starship.zsh atuin.zsh direnv.zsh node.zsh docker.zsh commit.zsh; do
    assert_file_exists ".zshrc.d/${_f}" "${r}/dotfiles/.zshrc.d/${_f}"
  done

  # ── Config files ────────────────────────────────────────────────────────────
  assert_file_exists "config/starship.toml"           "${r}/config/starship.toml"
  assert_file_exists "config/atuin/config.toml"       "${r}/config/atuin/config.toml"
  assert_file_exists "dotfiles/.gitmessage"            "${r}/dotfiles/.gitmessage"
  assert_file_exists "dotfiles/.zshrc.local.example"  "${r}/dotfiles/.zshrc.local.example"

  # ── Templates ───────────────────────────────────────────────────────────────
  assert_file_exists "templates/node/package.json"      "${r}/templates/node/package.json"
  assert_file_exists "templates/python/pyproject.toml"  "${r}/templates/python/pyproject.toml"

  # ── Every .zshrc.d file has a command -v guard ──────────────────────────────
  for _f in "${r}/dotfiles/.zshrc.d/"*.zsh; do
    local _fname
    _fname=$(basename "$_f")
    assert_cmd_success ".zshrc.d/${_fname} has 'command -v' guard" grep -q "command -v" "$_f"
  done

  # ── dotfiles/.zshrc has exactly one modular config marker ───────────────────
  local _mc
  _mc=$(grep -c "dotfiles modular config" "${r}/dotfiles/.zshrc" 2>/dev/null || printf "0")
  assert_eq ".zshrc has exactly one modular config marker" "1" "$_mc"

  # ── .gitignore contains .zshrc.local ────────────────────────────────────────
  assert_cmd_success ".gitignore contains '.zshrc.local'" \
    grep -qF ".zshrc.local" "${r}/.gitignore"

  # ── starship.toml contains [character] ──────────────────────────────────────
  assert_cmd_success "starship.toml contains '[character]'" \
    grep -qF "[character]" "${r}/config/starship.toml"

  # ── atuin/config.toml contains search_mode ──────────────────────────────────
  assert_cmd_success "atuin/config.toml contains 'search_mode'" \
    grep -q "search_mode" "${r}/config/atuin/config.toml"
}
