#!/bin/bash
# Bootstrap a clean Ubuntu Desktop and provision it.
# Recommended: download the installer, read it, then run it:
#   curl -fsSLo install.sh https://raw.githubusercontent.com/lautsevich/my-env/master/install.sh
#   less install.sh
#   bash install.sh
# From a cloned repo:  ./install.sh
# Dry run (prints commands, runs the playbook in check mode):  add --dry-run
#
# Optional: REF selects the branch or tag to clone (default: master).

set -euo pipefail

# Everything runs from main(), called on the last line: if the download is cut short,
# that line is missing and nothing runs.
main() {
  local REPO_URL="${REPO_URL:-https://github.com/lautsevich/my-env.git}"
  local REPO_DIR="${REPO_DIR:-$HOME/Projects/my-env}"
  local REF="${REF:-master}"

  DRY_RUN=false
  for arg in "$@"; do
    case "$arg" in
      --dry-run) DRY_RUN=true ;;
      *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
  done

  run sudo apt-get update
  run sudo apt-get upgrade -y
  run sudo apt-get install -y git ansible make

  # Use the repo this script lives in; otherwise clone it at REF.
  local SCRIPT_DIR
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" && pwd)"
  if [ -f "$SCRIPT_DIR/Makefile" ] && [ -f "$SCRIPT_DIR/playbooks/install.yml" ]; then
    REPO_DIR="$SCRIPT_DIR"
  elif [ ! -d "$REPO_DIR/.git" ]; then
    run git clone --branch "$REF" "$REPO_URL" "$REPO_DIR"
  fi

  if ! $DRY_RUN; then
    cd "$REPO_DIR"
    make git-hooks
    make provision
    return
  fi

  echo "[dry-run] using repo $REPO_DIR"
  echo "[dry-run] make git-hooks"
  if [ ! -d "$REPO_DIR/.git" ]; then
    echo "[dry-run] repo is not cloned yet, skipping the playbook check run"
  elif ! command -v ansible-playbook >/dev/null; then
    echo "[dry-run] Ansible is not installed yet, skipping the playbook check run"
  else
    cd "$REPO_DIR"
    make check
  fi
}

# Print the command in dry-run mode, run it otherwise.
run() {
  if $DRY_RUN; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

main "$@"
