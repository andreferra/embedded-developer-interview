#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_ROOT="$(mktemp -d 2>/dev/null || mktemp -d -t interview-smoke)"
trap 'rm -rf "$TMP_ROOT"' EXIT

log() {
  printf '\n[smoke] %s\n' "$1"
}

run_git_script_with_arg() {
  local script_name="$1"
  local target_dir="$TMP_ROOT/$2"
  log "Running $script_name → $target_dir"
  bash "$ROOT_DIR/scripts/git/$script_name" "$target_dir" >/dev/null
  if [ ! -d "$target_dir/.git" ]; then
    echo "Expected git repository at $target_dir" >&2
    exit 1
  fi
}

run_git_script_noarg() {
  local script_name="$1"
  local workspace="$TMP_ROOT/$2"
  local expected_repo="$3"
  mkdir -p "$workspace"
  log "Running $script_name inside $workspace"
  (cd "$workspace" && bash "$ROOT_DIR/scripts/git/$script_name" >/dev/null)
  if [ ! -d "$workspace/$expected_repo/.git" ]; then
    echo "Expected git repository at $workspace/$expected_repo" >&2
    exit 1
  fi
}

run_cpp_script() {
  local script_name="$1"
  local expected_dir="$2"
  local workspace="$TMP_ROOT/${expected_dir}-workspace"
  mkdir -p "$workspace"
  log "Running $script_name inside $workspace"
  (cd "$workspace" && bash "$ROOT_DIR/scripts/cpp/$script_name" >/dev/null)
  if [ ! -d "$workspace/$expected_dir/.git" ]; then
    echo "Expected git repository at $workspace/$expected_dir" >&2
    exit 1
  fi
}

run_cmake_script() {
  local workspace="$TMP_ROOT/cmake-workspace"
  mkdir -p "$workspace"
  log "Running cmake-setup.sh inside $workspace"
  (cd "$workspace" && bash "$ROOT_DIR/scripts/cmake/cmake-setup.sh" >/dev/null)
  if [ ! -d "$workspace/cmake-challenge/.git" ]; then
    echo "Expected git repository at $workspace/cmake-challenge" >&2
    exit 1
  fi
}

run_git_script_with_arg "setup_git_junior.sh" "git-playground-junior"
run_git_script_with_arg "setup_git_mid.sh" "git-playground-mid"
run_git_script_with_arg "setup_git_senior.sh" "git-playground-senior"
run_git_script_noarg "setup_interview_repo.sh" "git-interview-repo" "cpp-interview-practice"

run_cpp_script "setup_memory_leak.sh" "cpp-memory-leak"
run_cpp_script "setup_race_condition.sh" "cpp-race-condition"
run_cpp_script "setup_buffer_overflow.sh" "cpp-buffer-overflow"
run_cpp_script "setup_rule_of_three.sh" "cpp-rule-of-three"

run_cmake_script

log "All smoke tests passed."
