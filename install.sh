#!/bin/bash
# Bootstrap a clean Ubuntu Desktop and provision it.
# Run from a cloned repo:  ./install.sh
# Or without cloning:      curl -fsSL https://raw.githubusercontent.com/lautsevich/my-env/master/install.sh | bash

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/lautsevich/my-env.git}"
REPO_DIR="${REPO_DIR:-$HOME/Projects/my-env}"

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git ansible make

# Use the repo this script lives in; otherwise clone it.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" && pwd)"
if [ -f "$SCRIPT_DIR/Makefile" ] && [ -f "$SCRIPT_DIR/playbooks/install.yml" ]; then
  REPO_DIR="$SCRIPT_DIR"
elif [ ! -d "$REPO_DIR/.git" ]; then
  git clone "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"
make provision
