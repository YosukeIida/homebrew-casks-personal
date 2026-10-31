cask "herdr-core" do
  arch arm: "aarch64", intel: "x86_64"

  # Bumped by .github/workflows/bump.yml (scripts/bump-herdr.sh).
  version "0.1.15"
  sha256 arm:   "47eba8367e0626a1efced8795fcb03d5434b2541c5a84d78c50cc02c8fb49fc8",
         intel: "55acac7e0ba75c829028655cd7e7964d138b10a03946fd73628508a2821b1118"

  url "https://releases.herdr.dev/core/#{version}/herdr-core-macos-#{arch}.tar.gz"
  name "herdr-core"
  desc "Terminal runtime for coding agents (hc)"
  homepage "https://herdr.dev/core/"

  livecheck do
    url "https://releases.herdr.dev/core/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  # `hc update` (and the Herdr app) swap the binary in place without ending
  # running terminals; brew upgrading it would not be that planned swap.
  auto_updates true
  depends_on :macos

  binary "herdr-core"
  binary "herdr-core", target: "hc"

  # The binary is ad-hoc signed, so a quarantined copy is refused by
  # Gatekeeper outright, not just behind a dialog.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  zap trash: "~/.config/herdr-core"
end
