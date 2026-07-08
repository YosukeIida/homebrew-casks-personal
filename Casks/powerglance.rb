cask "powerglance" do
  version "0.2.0"
  sha256 :no_check

  url "https://github.com/YosukeIida/PowerGlance/releases/download/v#{version}/PowerGlance-#{version}.dmg"
  name "PowerGlance"
  desc "Menu bar app showing charger, battery, and power-draw info at a glance"
  homepage "https://github.com/YosukeIida/PowerGlance"

  depends_on :macos

  app "PowerGlance.app"
end
