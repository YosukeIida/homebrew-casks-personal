cask "zed-dev-ratex" do
  # Bump both fields with (no download needed — GitHub reports the asset digest):
  #   gh api repos/YosukeIida/zed/releases/latest \
  #     --jq '.tag_name, (.assets[] | select(.name | endswith(".dmg")) | .digest)'
  version "1.14.0-latex.5"
  sha256 "1fcd74aa71a70a1d68450119d82b763d1ac0bbe640bd5c5a2a519c6fa3b0b15a"

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

  # This build is signed ad-hoc (no Apple Developer certificate), so Gatekeeper
  # rejects it and the quarantine flag Homebrew sets would block launch after
  # every weekly update. Clear it for this app only.
  #
  # Not done via `--no-quarantine`: Homebrew 6 offers no way to skip quarantine at
  # install time at all. The CLI flag is gone, and HOMEBREW_CASK_OPTS does not work
  # either — EnvConfig.cask_opts_quarantine? (env_config.rb:983) has no callers, and
  # cmd/install.rb:372,420 never passes `quarantine:` to Cask::Installer, so the
  # hardcoded default of true (installer.rb:42) always wins. `brew bundle` also skips
  # per-cask args on its upgrade path (bundle/cask.rb:76), so a per-cask arg would not
  # survive updates anyway. Verified against Homebrew 6.0.12.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Zed Dev RaTeX(unofficial).app"]
  end
end
