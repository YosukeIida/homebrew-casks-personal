cask "zed-dev-ratex" do
  version "1.10.0-latex.3"
  sha256 :no_check

  url "https://github.com/YosukeIida/zed/releases/download/v#{version}/Zed-Dev-RaTeX-unofficial-#{version}-aarch64.dmg"
  name "Zed Dev RaTeX (unofficial)"
  desc "Personal Zed fork (dev channel) with inline LaTeX/RaTeX math rendering"
  homepage "https://github.com/YosukeIida/zed"

  # Detect new fork releases (tags matching v<base>-latex[.N]) so `brew livecheck`
  # (or a scheduled check) can flag when this cask's pinned version is stale.
  livecheck do
    url "https://github.com/YosukeIida/zed/releases"
    strategy :github_latest
    regex(/^v?(\d+(?:\.\d+)*-latex(?:\.\d+)?)$/i)
  end

  # This fork's own release cadence, not upstream Zed's. Zed's built-in updater
  # points at zed.dev and must stay off so it never tries to overwrite this build.
  auto_updates false
  depends_on :macos

  app "Zed Dev RaTeX(unofficial).app"
end
