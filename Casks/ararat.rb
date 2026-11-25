cask "ararat" do
  # Bumped by .github/workflows/bump.yml (scripts/bump-ararat.sh), preview releases included.
  version "0.0.2-preview.4"
  sha256 "d6378c06ed5ec04e3549bdeb3af3a568364f054b52facb7134cde87623f99bfa"

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
