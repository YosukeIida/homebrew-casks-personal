cask "ararat-preview" do
  # Bumped by .github/workflows/bump.yml (scripts/bump-ararat.sh preview). Separate app and data from the stable cask "ararat"; both can be installed.
  version "0.0.2-preview.5"
  sha256 "3cd60c21629510ae4eb75c272bdb6ac84e4c3a2b9f5ef2dd8adda04b0bd3a2ac"

  url "https://github.com/YosukeIida/ararat/releases/download/v#{version}/Ararat-Preview-#{version}.zip"
  name "Ararat Preview"
  desc "Chromium browser with Arc's workflow and vertical tabs"
  homepage "https://github.com/YosukeIida/ararat"

  # No auto_updates: the release builds do not enable Sparkle yet, so
  # `brew upgrade` is the update path.
  depends_on arch: :arm64
  depends_on :macos

  app "Ararat Preview.app"

  # The release is ad-hoc signed (no Developer ID), so Gatekeeper refuses to
  # open a quarantined copy; the release notes ask for the same xattr call.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end
end
