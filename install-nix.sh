#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
action="${1:-switch}"
if [[ $# -gt 0 ]]; then shift; fi

case "$action" in
  build|switch) ;;
  -h|--help)
    echo "Usage: ./install-nix.sh [build|switch] [Home Manager options]"
    echo "Requires Nix. See README.md for initial setup and host services."
    exit 0
    ;;
  *) echo "Unknown action: $action (expected build or switch)" >&2; exit 2 ;;
esac

if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is required. Follow the setup instructions in $repo_dir/README.md." >&2
  exit 1
fi

if [[ "$action" == switch ]]; then
  host_user="$(nix --extra-experimental-features nix-command eval --raw --file "$repo_dir/nix/host.nix" username)"
  host_home="$(nix --extra-experimental-features nix-command eval --raw --file "$repo_dir/nix/host.nix" homeDirectory)"
  if [[ "$(id -un)" != "$host_user" || "$HOME" != "$host_home" || "$repo_dir" != "$host_home/dotfiles" ]]; then
    echo "Set nix/host.nix for this user and place the repository at its homeDirectory/dotfiles before switching." >&2
    exit 1
  fi
fi

# Only Nix definitions enter the flake source, excluding local credentials and caches.
# This also works before new Nix files have been added to Git.
flake_dir="$(mktemp -d)"
trap 'rm -rf -- "$flake_dir"' EXIT
cp "$repo_dir/flake.nix" "$repo_dir/flake.lock" "$flake_dir/"
cp -R "$repo_dir/nix" "$flake_dir/nix"
nix --extra-experimental-features 'nix-command flakes' \
  run "path:$flake_dir#home-manager" -- \
  "$action" --flake "path:$flake_dir#gotoh" "$@"
