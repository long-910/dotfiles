#!/usr/bin/env bash
# tests/test_bootstrap.sh — CLI validation tests for bootstrap.sh

run_tests() {
  local bootstrap="${REPO_ROOT}/bootstrap.sh"
  local list_output list_rc

  # --list exits 0
  list_output=$(bash "$bootstrap" --list 2>&1)
  list_rc=$?
  assert_eq "--list exits 0" "0" "$list_rc"

  # --list output contains all expected module names
  assert_contains "--list contains 'core'"   "$list_output" "core"
  assert_contains "--list contains 'shell'"  "$list_output" "shell"
  assert_contains "--list contains 'dev'"    "$list_output" "dev"
  assert_contains "--list contains 'node'"   "$list_output" "node"
  assert_contains "--list contains 'docker'" "$list_output" "docker"

  # Unknown flag exits non-zero
  assert_cmd_fail "--unknown-flag exits non-zero" bash "$bootstrap" --unknown-flag-xyz
}
