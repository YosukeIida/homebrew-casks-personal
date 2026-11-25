#!/usr/bin/env bash
# Casks/ararat.rb を YosukeIida/ararat の最新リリース（preview を含む）に揃える。
# releases/latest は prerelease を返さないので、一覧の先頭（作成日の新しい順）を使う。
# sha256 は GitHub の release asset の digest を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば更新したものを "name to version" で書く。
set -euo pipefail

cd "$(dirname "$0")/.."
file=Casks/ararat.rb

release="$(gh api 'repos/YosukeIida/ararat/releases?per_page=1' --jq '.[0]')"
version="$(jq -r '.tag_name | ltrimstr("v")' <<<"$release")"
if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+(-preview\.[0-9]+)?$ ]]; then
  echo "unexpected version for ararat: $version" >&2
  exit 1
fi
current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$file")"
if [[ "$current" == "$version" ]]; then
  echo "ararat is up to date ($current)"
  exit 0
fi

sha="$(jq -r --arg n "Ararat-$version.zip" \
  '.assets[] | select(.name == $n) | .digest | ltrimstr("sha256:")' <<<"$release")"
if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
  echo "missing sha256 for Ararat-$version.zip" >&2
  exit 1
fi

sed -i.bak -E "s/^  version \"[^\"]+\"$/  version \"$version\"/" "$file"
sed -i.bak -E "s/^  sha256 \"[0-9a-f]{64}\"/  sha256 \"$sha\"/" "$file"
rm -f "$file.bak"

grep -q "\"$version\"" "$file" && grep -q "\"$sha\"" "$file" || {
  echo "failed to rewrite $file" >&2
  exit 1
}
echo "ararat: $current -> $version"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=ararat to $version" >>"$GITHUB_OUTPUT"
fi
