#!/bin/bash
# Bootstrap a clean Ubuntu Desktop and provision it.
# Run from a cloned repo:  ./install.sh
# Or without cloning:      curl -fsSL https://raw.githubusercontent.com/lautsevich/my-env/master/install.sh | bash
# Dry run (prints commands, runs the playbook in check mode):  ./install.sh --dry-run

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/lautsevich/my-env.git}"
REPO_DIR="${REPO_DIR:-$HOME/Projects/my-env}"

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

# Print the command in dry-run mode, run it otherwise.
run() {
  if $DRY_RUN; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

run sudo apt-get update
run sudo apt-get upgrade -y
run sudo apt-get install -y git ansible make

# Use the repo this script lives in; otherwise clone it.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" && pwd)"
if [ -f "$SCRIPT_DIR/Makefile" ] && [ -f "$SCRIPT_DIR/playbooks/install.yml" ]; then
  REPO_DIR="$SCRIPT_DIR"
elif [ ! -d "$REPO_DIR/.git" ]; then
  run git clone "$REPO_URL" "$REPO_DIR"
fi

if ! $DRY_RUN; then
  cd "$REPO_DIR"
  make git-hooks
  make provision
  exit
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
