cask "ararat" do
  # Bumped by .github/workflows/bump.yml (scripts/bump-ararat.sh stable). Preview builds are the separate cask "ararat-preview".
  version "0.0.2"
  sha256 "55418efdcb546785e7fe94f139180d3aad97b10306eefe543fc18a152bce9b04"

  url "https://github.com/YosukeIida/ararat/releases/download/v#{version}/Ararat-#{version}.zip"
  name "Ararat"
  desc "Chromium browser with Arc's workflow and vertical tabs"
  homepage "https://github.com/YosukeIida/ararat"

  # No auto_updates: the release builds do not enable Sparkle yet, so
  # `brew upgrade` is the update path.
  depends_on arch: :arm64
  depends_on :macos

  app "Ararat.app"

  # The release is ad-hoc signed (no Developer ID), so Gatekeeper refuses to
  # open a quarantined copy; the release notes ask for the same xattr call.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end
end
