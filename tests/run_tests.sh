#!/usr/bin/env bash
# tests/run_tests.sh — Test harness and orchestrator
# No set -e intentionally: assertions handle exit codes gracefully

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$TESTS_DIR")"
export TESTS_DIR REPO_ROOT

PASS=0
FAIL=0

# ── Assertion helpers ──────────────────────────────────────────────────────────

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    printf "  \033[32m✓\033[0m %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n    expected: %s\n    got:      %s\n" "$desc" "$expected" "$actual"
    FAIL=$((FAIL + 1))
  fi
}

assert_contains() {
  local desc="$1" haystack="$2" needle="$3"
  if printf '%s' "$haystack" | grep -qF "$needle"; then
    printf "  \033[32m✓\033[0m %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n    expected to contain: %s\n" "$desc" "$needle"
    FAIL=$((FAIL + 1))
  fi
}

assert_file_exists() {
  local desc="$1" path="$2"
  if [ -e "$path" ]; then
    printf "  \033[32m✓\033[0m %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n    file not found: %s\n" "$desc" "$path"
    FAIL=$((FAIL + 1))
  fi
}

assert_executable() {
  local desc="$1" path="$2"
  if [ -x "$path" ]; then
    printf "  \033[32m✓\033[0m %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n    not executable: %s\n" "$desc" "$path"
    FAIL=$((FAIL + 1))
  fi
}

assert_cmd_success() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf "  \033[32m✓\033[0m %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n    command failed: %s\n" "$desc" "$*"
    FAIL=$((FAIL + 1))
  fi
}

assert_cmd_fail() {
  local desc="$1"
  shift
  if ! "$@" >/dev/null 2>&1; then
    printf "  \033[32m✓\033[0m %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n    expected failure but succeeded: %s\n" "$desc" "$*"
    FAIL=$((FAIL + 1))
  fi
}

# ── Run each test file ─────────────────────────────────────────────────────────
for _test_file in "${TESTS_DIR}"/test_*.sh; do
  printf "\n\033[1m── %s ──\033[0m\n" "$(basename "$_test_file")"
  # shellcheck disable=SC1090
  . "$_test_file"
  run_tests
done
unset _test_file

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n\033[1m═══════════════════════════════\033[0m\n"
printf "  \033[32mPassed: %d\033[0m  \033[31mFailed: %d\033[0m\n" "$PASS" "$FAIL"
printf "\033[1m═══════════════════════════════\033[0m\n\n"

[ "$FAIL" -eq 0 ] || exit 1
