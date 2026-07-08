cask "pindrop" do
  version :latest
  sha256 :no_check

  url "https://github.com/watzon/pindrop/releases/latest/download/Pindrop.dmg"
  name "Pindrop"
  desc "Menu bar dictation app"
  homepage "https://pindropstt.com/"

  depends_on :macos

  app "Pindrop.app"
end
