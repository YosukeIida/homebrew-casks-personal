cask "omlx" do
  # Bumped by .github/workflows/bump.yml (scripts/bump-omlx.sh).
  version "0.8.4"
  sha256 "445c3d42b1ac5dbdd1d8f1eadca0ad4e35dded846026b3ca3d8537dd7ce08a0b"

  url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg"
  name "oMLX"
  desc "Menu bar app and LLM inference server for Apple Silicon"
  homepage "https://github.com/jundot/omlx"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  # The upstream tap (jundot/omlx) only has a formula that builds the Python
  # server from source on every upgrade, pulling in rust and python@3.11. This
  # cask installs the notarized DMG app instead, which bundles its own Python
  # runtime and native kernels. No auto_updates: plain `brew upgrade` keeps it
  # current, and the in-app updater is meant to be turned off. The app installs
  # its own `omlx` CLI shim at ~/.omlx/bin/omlx.
  app "oMLX.app"

  # Same reason as claude-code@latest: a quarantined app waits on a Gatekeeper
  # dialog when an agent, launchd or an SSH session starts it.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  # ~/.omlx holds the models and server settings, so zap leaves it alone.
  zap trash: "~/Library/Application Support/oMLX"
end
