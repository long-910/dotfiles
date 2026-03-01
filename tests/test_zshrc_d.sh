#!/usr/bin/env bash
# tests/test_zshrc_d.sh — Syntax validation via bash -n

run_tests() {
  local r="$REPO_ROOT"

  # ── Shell scripts ────────────────────────────────────────────────────────────
  for _f in \
    "${r}/bootstrap.sh" \
    "${r}/uninstall.sh" \
    "${r}/install_and_configure.sh" \
    "${r}/modules/lib.sh" \
    "${r}/modules/core.sh" \
    "${r}/modules/shell.sh" \
    "${r}/modules/dev.sh" \
    "${r}/modules/node.sh" \
    "${r}/modules/docker.sh"
  do
    local _name
    _name=$(basename "$_f")
    assert_cmd_success "bash -n ${_name}" bash -n "$_f"
  done

  # ── .zshrc.d/*.zsh files ────────────────────────────────────────────────────
  for _f in "${r}/dotfiles/.zshrc.d/"*.zsh; do
    local _name
    _name=$(basename "$_f")
    assert_cmd_success "bash -n .zshrc.d/${_name}" bash -n "$_f"
  done

  # ── dotfiles/.zshrc ─────────────────────────────────────────────────────────
  assert_cmd_success "bash -n dotfiles/.zshrc" bash -n "${r}/dotfiles/.zshrc"
}
