cask "claude-science" do
  version :latest
  sha256 :no_check

  on_arm do
    url "https://downloads.claude.ai/claude-science/latest/mac-arm64.dmg",
        verified: "downloads.claude.ai/claude-science/"
  end
  on_intel do
    url "https://downloads.claude.ai/claude-science/latest/mac-x64.dmg",
        verified: "downloads.claude.ai/claude-science/"
  end

  name "Claude Science"
  desc "Anthropic's native desktop app for scientific research workflows"
  homepage "https://claude.com/product/claude-science"

  # Rolling dev-build distribution (URL is a fixed "/latest/" alias, no versioned
  # path); the DMG's own bundle version is a build timestamp, not a release tag.
  auto_updates false
  depends_on macos: :ventura

  app "Claude Science.app"
end
