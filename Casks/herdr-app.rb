cask "herdr-app" do
  # Bumped by .github/workflows/bump.yml (scripts/bump-herdr.sh).
  version "0.1.11"
  sha256 "7c4e7318c54bbcbf175ffd6d1b4f618b59137383330aff8eb5bc10dc3feeecb9"

  url "https://releases.herdr.dev/app/#{version}/herdr-app-macos-aarch64.tar.gz"
  name "Herdr"
  desc "Desktop app for terminals and coding agents, built on herdr-core"
  homepage "https://herdr.dev/"

  livecheck do
    url "https://releases.herdr.dev/app/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  # The app updates itself in place (Settings -> Updates) and updates
  # herdr-core with it, so brew only does the first install.
  auto_updates true
  depends_on arch: :arm64
  depends_on formula: "yosukeiida/casks-personal/herdr-core"
  depends_on :macos

  # No official tap or cask exists; the official install.sh puts the bundle in
  # ~/Applications and links herdr-app into ~/.local/bin. This is the same
  # Developer ID-signed bundle from the same manifest.
  app "Herdr.app"
  binary "#{appdir}/Herdr.app/Contents/MacOS/Herdr", target: "herdr-app"

  # Same reason as claude-code@latest: a quarantined CLI waits on a Gatekeeper
  # dialog when an agent or SSH session starts it.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  zap trash: "~/.config/herdr-app"
end
