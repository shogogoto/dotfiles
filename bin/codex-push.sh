#!/usr/bin/env bash
set -euo pipefail

SERVER="dev"
SSH_OPTS='ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=6'

SRC="$HOME/.codex/sessions/"
DST="$SERVER":~/.codex/sessions/

echo "=== Dry run ==="
rsync -av --dry-run --partial --append-verify \
  -e "$SSH_OPTS" \
  "$SRC" \
  "$DST"

echo
read -r -p "この内容で push しますか？ [y/N]: " answer

case "$answer" in
  y|Y|yes|YES|Yes)
    echo
    echo "=== Push ==="
    rsync -av --partial --append-verify \
      -e "$SSH_OPTS" \
      "$SRC" \
      "$DST"
    ;;
  *)
    echo "キャンセルしました。"
    exit 0
    ;;
esac
