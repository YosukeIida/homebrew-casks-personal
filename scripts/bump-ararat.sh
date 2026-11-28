#!/usr/bin/env bash
# Casks/ararat.rb（stable）または Casks/ararat-preview.rb（preview）を YosukeIida/ararat の最新リリースに揃える。
# 引数: stable | preview。stable は releases/latest（prerelease を返さない）、
# preview は一覧（作成日の新しい順）のうち最初の prerelease を使う。
# sha256 は GitHub の release asset の digest を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば更新したものを "name to version" で書く。
set -euo pipefail

cd "$(dirname "$0")/.."
channel="${1:?usage: bump-ararat.sh stable|preview}"
case "$channel" in
  stable)
    name=ararat file=Casks/ararat.rb zip_prefix=Ararat
    version_re='^[0-9]+(\.[0-9]+)+$'
    release="$(gh api repos/YosukeIida/ararat/releases/latest)"
    ;;
  preview)
    name=ararat-preview file=Casks/ararat-preview.rb zip_prefix=Ararat-Preview
    version_re='^[0-9]+(\.[0-9]+)+-preview\.[0-9]+$'
    release="$(gh api 'repos/YosukeIida/ararat/releases?per_page=30' --jq '[.[] | select(.prerelease)][0]')"
    ;;
  *)
    echo "unknown channel: $channel" >&2
    exit 1
    ;;
esac

version="$(jq -r '.tag_name | ltrimstr("v")' <<<"$release")"
if [[ ! "$version" =~ $version_re ]]; then
  echo "unexpected version for $name: $version" >&2
  exit 1
fi
current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$file")"
if [[ "$current" == "$version" ]]; then
  echo "$name is up to date ($current)"
  exit 0
fi

sha="$(jq -r --arg n "$zip_prefix-$version.zip" \
  '.assets[] | select(.name == $n) | .digest | ltrimstr("sha256:")' <<<"$release")"
if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
  echo "missing sha256 for $zip_prefix-$version.zip" >&2
  exit 1
fi

sed -i.bak -E "s/^  version \"[^\"]+\"$/  version \"$version\"/" "$file"
sed -i.bak -E "s/^  sha256 \"[0-9a-f]{64}\"/  sha256 \"$sha\"/" "$file"
rm -f "$file.bak"

grep -q "\"$version\"" "$file" && grep -q "\"$sha\"" "$file" || {
  echo "failed to rewrite $file" >&2
  exit 1
}
echo "$name: $current -> $version"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$name to $version" >>"$GITHUB_OUTPUT"
fi
