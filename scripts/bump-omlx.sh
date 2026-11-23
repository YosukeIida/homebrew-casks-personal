#!/usr/bin/env bash
# Casks/omlx.rb を jundot/omlx の最新リリースに揃える。
# sha256 は GitHub の release asset の digest を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば更新したものを "name to version" で書く。
set -euo pipefail

cd "$(dirname "$0")/.."
file=Casks/omlx.rb

release="$(gh api repos/jundot/omlx/releases/latest)"
version="$(jq -r '.tag_name | ltrimstr("v")' <<<"$release")"
if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
  echo "unexpected version for omlx: $version" >&2
  exit 1
fi
current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$file")"
if [[ "$current" == "$version" ]]; then
  echo "omlx is up to date ($current)"
  exit 0
fi

sha="$(jq -r --arg n "oMLX-$version-macos26-27.dmg" \
  '.assets[] | select(.name == $n) | .digest | ltrimstr("sha256:")' <<<"$release")"
if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
  echo "missing sha256 for oMLX-$version-macos26-27.dmg" >&2
  exit 1
fi

sed -i.bak -E "s/^  version \"[^\"]+\"$/  version \"$version\"/" "$file"
sed -i.bak -E "s/^  sha256 \"[0-9a-f]{64}\"/  sha256 \"$sha\"/" "$file"
rm -f "$file.bak"

grep -q "\"$version\"" "$file" && grep -q "\"$sha\"" "$file" || {
  echo "failed to rewrite $file" >&2
  exit 1
}
echo "omlx: $current -> $version"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=omlx to $version" >>"$GITHUB_OUTPUT"
fi
