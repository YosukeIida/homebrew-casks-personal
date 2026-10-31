#!/usr/bin/env bash
# Casks/herdr-app.rb と Casks/herdr-core.rb を releases.herdr.dev の latest に揃える。
# sha256 は配布元の latest.json が target ごとに返す値を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば更新した cask を "name to version" で書く。
set -euo pipefail

cd "$(dirname "$0")/.."
base=https://releases.herdr.dev

sha() {
  local s
  s="$(jq -r --arg t "$2" '.targets[$t].sha256' <<<"$1")"
  if [[ ! "$s" =~ ^[0-9a-f]{64}$ ]]; then
    echo "missing sha256 for $2" >&2
    exit 1
  fi
  echo "$s"
}

# $1: cask 名, $2: manifest のパス（app / core）
bump() {
  local cask="Casks/$1.rb" manifest version current arm intel
  manifest="$(curl -fsS "$base/$2/latest.json")"
  version="$(jq -r .version <<<"$manifest")"
  if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
    echo "unexpected version for $1: $version" >&2
    exit 1
  fi
  current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$cask")"
  if [[ "$current" == "$version" ]]; then
    echo "$1 is up to date ($current)"
    return
  fi

  arm="$(sha "$manifest" macos-aarch64)"
  sed -i.bak -E \
    -e "s/^  version \"[^\"]+\"$/  version \"$version\"/" \
    -e "s/^(  sha256 (arm: +)?)\"[0-9a-f]{64}\"/\1\"$arm\"/" \
    "$cask"
  if grep -q '^         intel: ' "$cask"; then
    intel="$(sha "$manifest" macos-x86_64)"
    sed -i.bak -E "s/^(         intel: )\"[0-9a-f]{64}\"/\1\"$intel\"/" "$cask"
  fi
  rm -f "$cask.bak"

  grep -q "\"$version\"" "$cask" && grep -q "\"$arm\"" "$cask" || {
    echo "failed to rewrite $cask" >&2
    exit 1
  }
  echo "$1: $current -> $version"
  updated+=("$1 to $version")
}

updated=()
bump herdr-app app
bump herdr-core core

if [[ -n "${GITHUB_OUTPUT:-}" && ${#updated[@]} -gt 0 ]]; then
  echo "version=$(IFS=,; echo "${updated[*]}" | sed 's/,/, /g')" >>"$GITHUB_OUTPUT"
fi
