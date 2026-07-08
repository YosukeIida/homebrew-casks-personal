cask "nimbus" do
  version :latest
  sha256 :no_check

  url "https://github.com/syllogismos/nimbus/releases/latest/download/Nimbus-mac-arm64.dmg"
  name "Nimbus"
  desc "Browser designed for Claude Code workflows"
  homepage "https://github.com/syllogismos/nimbus"

  depends_on :macos

  app "Nimbus.app"

  zap trash: [
    "~/Library/Application Support/Nimbus",
    "~/Library/Caches/Nimbus",
    "~/Library/Logs/Nimbus",
    "~/Library/Preferences/com.nimbus.app.plist",
    "~/Library/Saved Application State/com.nimbus.app.savedState",
  ]
end
