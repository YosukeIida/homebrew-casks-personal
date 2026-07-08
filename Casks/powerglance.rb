cask "powerglance" do
  version "0.2.1"
  sha256 "96da1d6549de6ebcf6fd6701046b5ee5c358c0efe6a2d920de4c8854db22baeb"

  url "https://github.com/YosukeIida/PowerGlance/releases/download/v#{version}/PowerGlance-#{version}.dmg"
  name "PowerGlance"
  desc "Menu bar app showing charger, battery, and power-draw info at a glance"
  homepage "https://github.com/YosukeIida/PowerGlance"

  depends_on :macos

  app "PowerGlance.app"
end
