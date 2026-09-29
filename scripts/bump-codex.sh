#!/usr/bin/env bash
# Casks/codex.rb を openai/codex の最新 release（prerelease を除く）に揃える。
# sha256 は GitHub が asset ごとに返す digest を使うので、ダウンロードは不要。
# 変更があれば 0、既に最新なら 0 で何もしない。GITHUB_OUTPUT があれば version を書く。
set -euo pipefail

cd "$(dirname "$0")/.."
cask=Casks/codex.rb

release="$(gh api repos/openai/codex/releases/latest)"
tag="$(jq -r .tag_name <<<"$release")"
version="${tag#rust-v}"
if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
  echo "unexpected tag: $tag" >&2
  exit 1
fi

current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$cask")"
if [[ "$current" == "$version" ]]; then
  echo "codex is up to date ($current)"
  exit 0
fi

digest() {
  local sha
  sha="$(jq -r --arg n "codex-package-$1-apple-darwin.tar.gz" \
    '.assets[] | select(.name == $n) | .digest' <<<"$release")"
  if [[ ! "$sha" =~ ^sha256:[0-9a-f]{64}$ ]]; then
    echo "missing sha256 digest for $1 in $tag" >&2
    exit 1
  fi
  echo "${sha#sha256:}"
}
arm="$(digest aarch64)"
intel="$(digest x86_64)"

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

echo "codex: $current -> $version"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$version" >>"$GITHUB_OUTPUT"
fi
