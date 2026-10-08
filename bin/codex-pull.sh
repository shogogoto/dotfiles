#!/usr/bin/env bash
set -euo pipefail

SERVER="dev"
SSH_OPTS='ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=6'

rsync -av --partial --append-verify \
  -e "$SSH_OPTS" \
  "$SERVER":~/.codex/sessions/ \
  ~/.codex/sessions/

rsync -av --partial \
  -e "$SSH_OPTS" \
  "$SERVER":~/chatgpt-web/ \
  ~/chatgpt-web/
