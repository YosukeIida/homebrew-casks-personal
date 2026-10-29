cask "cra" do
  version :latest
  sha256 :no_check

  url "https://github.com/VictorKildahl/cra/releases/latest/download/Cra.dmg"
  name "Cra"
  desc "Chromium browser with Arc's sidebar, Little Windows and link routing"
  homepage "https://crabrowser.app/"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Cra.app"
end
