#!/usr/bin/env bash
# Casks/claude-code@latest.rb を Claude Code の latest チャンネルに揃える。
# sha256 は配布元の manifest.json が platform ごとに返す checksum を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば version を書く。
set -euo pipefail

cd "$(dirname "$0")/.."
cask=Casks/claude-code@latest.rb
base=https://downloads.claude.ai/claude-code-releases

version="$(curl -fsS "$base/latest")"
if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
  echo "unexpected version: $version" >&2
  exit 1
fi

current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$cask")"
if [[ "$current" == "$version" ]]; then
  echo "claude-code@latest is up to date ($current)"
  exit 0
fi

manifest="$(curl -fsS "$base/$version/manifest.json")"
checksum() {
  local sha
  sha="$(jq -r --arg p "$1" '.platforms[$p].checksum' <<<"$manifest")"
  if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
    echo "missing sha256 checksum for $1 in $version" >&2
    exit 1
  fi
  echo "$sha"
}
arm="$(checksum darwin-arm64)"
intel="$(checksum darwin-x64)"

sed -i.bak -E \
  -e "s/^  version \"[^\"]+\"$/  version \"$version\"/" \
  -e "s/^(  sha256 arm: +)\"[0-9a-f]{64}\"/\1\"$arm\"/" \
  -e "s/^(         intel: )\"[0-9a-f]{64}\"/\1\"$intel\"/" \
  "$cask"
rm -f "$cask.bak"

grep -q "\"$version\"" "$cask" && grep -q "\"$arm\"" "$cask" && grep -q "\"$intel\"" "$cask" || {
  echo "failed to rewrite $cask" >&2
  exit 1
}

echo "claude-code@latest: $current -> $version"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$version" >>"$GITHUB_OUTPUT"
fi
