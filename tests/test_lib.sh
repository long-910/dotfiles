#!/usr/bin/env bash
# tests/test_lib.sh — Unit tests for modules/lib.sh (isolated HOME in temp dir)

run_tests() {
  local orig_home="$HOME"
  local TMP_HOME
  TMP_HOME=$(mktemp -d)
  HOME="$TMP_HOME"
  export HOME

  DOTFILES_ROOT="$REPO_ROOT"
  export DOTFILES_ROOT

  # Source lib.sh after setting HOME so BACKUP_MANIFEST points to TMP_HOME
  # shellcheck disable=SC1091
  . "${REPO_ROOT}/modules/lib.sh"

  # ── has_cmd ─────────────────────────────────────────────────────────────────
  assert_cmd_success "has_cmd bash"                   has_cmd bash
  assert_cmd_fail    "has_cmd __nonexistent_xyz__"    has_cmd __nonexistent_xyz__

  # ── detect_os ───────────────────────────────────────────────────────────────
  detect_os
  assert_cmd_success "detect_os sets \$OS non-empty"     test -n "$OS"
  assert_cmd_success "detect_os sets \$PKG_MGR non-empty" test -n "$PKG_MGR"

  # ── backup_file ─────────────────────────────────────────────────────────────
  local test_file="${TMP_HOME}/testfile.txt"
  printf "original content\n" > "$test_file"
  backup_file "$test_file"
  assert_cmd_fail    "backup_file removes original"   test -f "$test_file"
  local bak
  bak=$(find "$TMP_HOME" -maxdepth 1 -name "testfile.txt_backup_*" 2>/dev/null | head -1)
  assert_cmd_success "backup_file creates backup"     test -n "$bak"

  # ── backup_file on nonexistent file: no error ────────────────────────────────
  backup_file "${TMP_HOME}/nonexistent_file_xyz" 2>/dev/null
  assert_eq "backup_file on nonexistent file exits 0" "0" "$?"

  # ── restore_latest_backup ───────────────────────────────────────────────────
  restore_latest_backup "$test_file"
  assert_cmd_success "restore_latest_backup restores file" test -f "$test_file"

  # ── setup_zshrc_d ───────────────────────────────────────────────────────────
  setup_zshrc_d
  assert_cmd_success "setup_zshrc_d creates ~/.zshrc.d" test -d "${TMP_HOME}/.zshrc.d"

  # ── deploy_config ───────────────────────────────────────────────────────────
  local deploy_dest="${TMP_HOME}/.zshrc.local.example"
  deploy_config ".zshrc.local.example" "$deploy_dest"
  assert_cmd_success "deploy_config copies file to destination" test -f "$deploy_dest"

  # ── deploy_zshrc_d ──────────────────────────────────────────────────────────
  deploy_zshrc_d "fzf.zsh"
  assert_cmd_success "deploy_zshrc_d copies file to ~/.zshrc.d/" \
    test -f "${TMP_HOME}/.zshrc.d/fzf.zsh"

  # ── setup_zshrc_sourcing ────────────────────────────────────────────────────
  touch "${TMP_HOME}/.zshrc"
  setup_zshrc_sourcing
  assert_cmd_success "setup_zshrc_sourcing appends block to ~/.zshrc" \
    grep -qF "dotfiles modular config" "${TMP_HOME}/.zshrc"

  # Idempotency: calling twice must produce exactly one marker
  setup_zshrc_sourcing
  local count
  count=$(grep -c "dotfiles modular config" "${TMP_HOME}/.zshrc")
  assert_eq "setup_zshrc_sourcing is idempotent (block appears once)" "1" "$count"

  # ── Cleanup ─────────────────────────────────────────────────────────────────
  rm -rf "$TMP_HOME"
  HOME="$orig_home"
  export HOME
}
