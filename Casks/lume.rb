cask "lume" do
  version "0.6.0"
  sha256 "4d25c7c36ebd3fdf0e2f97f9e7a2c4ff2d0538ba9eb2d536f6dbb542d9d504a7"

  url "https://github.com/trycua/cua/releases/download/lume-v#{version}/lume-#{version}-darwin-arm64.tar.gz",
      verified: "github.com/trycua/cua/"
  name "Lume"
  desc "CLI and local API server for macOS and Linux VMs on Apple Silicon"
  homepage "https://cua.ai/docs/lume"

  livecheck do
    url "https://github.com/trycua/cua/releases"
    regex(/^lume[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on :macos

  # The official tap (trycua/lume) is stuck at 0.1.13, and the install script
  # also sets up an auto-updater and a daemon LaunchAgent. This cask installs
  # only the notarized app bundle. It is a cask, not a formula, so the bundle's
  # signature (including the restricted com.apple.vm.networking entitlement
  # backed by embedded.provisionprofile) stays untouched. Lume finds its bundle
  # through the symlink, so the CLI is the bundle's executable itself.
  app "lume.app"
  binary "#{appdir}/lume.app/Contents/MacOS/lume"

  # Same reason as claude-code@latest: a quarantined CLI waits on a Gatekeeper
  # dialog when an agent or SSH session starts it.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  zap trash: "~/.lume"
end
