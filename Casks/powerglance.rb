cask "powerglance" do
  version "0.2.2"
  sha256 "b213b3d458ccba40659282986dddd2d54341f8eb1700b7969aaf2778a7fc8259"

  url "https://github.com/YosukeIida/PowerGlance/releases/download/v#{version}/PowerGlance-#{version}.dmg"
  name "PowerGlance"
  desc "Menu bar app showing charger, battery, and power-draw info at a glance"
  homepage "https://github.com/YosukeIida/PowerGlance"

  depends_on :macos

  app "PowerGlance.app"
end
