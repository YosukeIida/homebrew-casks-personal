#!/usr/bin/env bash
# Casks/herdr-app.rb を releases.herdr.dev の latest に揃える（herdr-core は brew の外で入れる）。
# sha256 は配布元の latest.json が target ごとに返す値を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば更新したものを "name to version" で書く。
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

# $1: cask のファイル, $2: manifest のパス（app）
bump() {
  local file="$1" name manifest version current arm intel
  name="$(basename "$file" .rb)"
  manifest="$(curl -fsS "$base/$2/latest.json")"
  version="$(jq -r .version <<<"$manifest")"
  if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
    echo "unexpected version for $name: $version" >&2
    exit 1
  fi
  current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$file")"
  if [[ "$current" == "$version" ]]; then
    echo "$name is up to date ($current)"
    return
  fi

  arm="$(sha "$manifest" macos-aarch64)"
  sed -i.bak -E "s/^  version \"[^\"]+\"$/  version \"$version\"/" "$file"
  sed -i.bak -E "s/^(  sha256 (arm: +)?)\"[0-9a-f]{64}\"/\1\"$arm\"/" "$file"
  if grep -q '^         intel: ' "$file"; then
    intel="$(sha "$manifest" macos-x86_64)"
    sed -i.bak -E "s/^(         intel: )\"[0-9a-f]{64}\"/\1\"$intel\"/" "$file"
  fi
  rm -f "$file.bak"

  grep -q "\"$version\"" "$file" && grep -q "\"$arm\"" "$file" \
    && ! grep -q "/$2/$current/" "$file" || {
    echo "failed to rewrite $file" >&2
    exit 1
  }
  echo "$name: $current -> $version"
  updated+=("$name to $version")
}

updated=()
bump Casks/herdr-app.rb app

if [[ -n "${GITHUB_OUTPUT:-}" && ${#updated[@]} -gt 0 ]]; then
  echo "version=$(IFS=,; echo "${updated[*]}" | sed 's/,/, /g')" >>"$GITHUB_OUTPUT"
fi
