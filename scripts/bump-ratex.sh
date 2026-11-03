#!/usr/bin/env bash
# Formula/ratex.rb を erweixin/RaTeX の最新 release に揃える。
# sha256 は GitHub が asset ごとに返す digest を使うので、ダウンロードは不要。
# 既に最新なら何もしない。GITHUB_OUTPUT があれば version を書く。
set -euo pipefail

cd "$(dirname "$0")/.."
formula=Formula/ratex.rb

release="$(gh api repos/erweixin/RaTeX/releases/latest)"
tag="$(jq -r .tag_name <<<"$release")"
version="${tag#v}"
if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
  echo "unexpected tag: $tag" >&2
  exit 1
fi

current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$formula")"
if [[ "$current" == "$version" ]]; then
  echo "ratex is up to date ($current)"
  exit 0
fi

sha="$(jq -r --arg n "ratex-cli-$tag-aarch64-apple-darwin.tar.gz" \
  '.assets[] | select(.name == $n) | .digest' <<<"$release")"
if [[ ! "$sha" =~ ^sha256:[0-9a-f]{64}$ ]]; then
  echo "missing sha256 digest in $tag" >&2
  exit 1
fi
sha="${sha#sha256:}"

sed -i.bak -E \
  -e "s/^  version \"[^\"]+\"$/  version \"$version\"/" \
  -e "s/^  sha256 \"[0-9a-f]{64}\"$/  sha256 \"$sha\"/" \
  "$formula"
rm -f "$formula.bak"

grep -q "\"$version\"" "$formula" && grep -q "\"$sha\"" "$formula" || {
  echo "failed to rewrite $formula" >&2
  exit 1
}

echo "ratex: $current -> $version"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$version" >>"$GITHUB_OUTPUT"
fi
