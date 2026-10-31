cask "claude-code@latest" do
  arch arm: "arm64", intel: "x64"

  # Bumped by .github/workflows/bump.yml (scripts/bump-claude-code.sh).
  version "2.1.316"
  sha256 arm:   "64c327e92b2c5e0f78c0a980c5a518121e1f0d140ca771ca5dd4488d1a2dcb3f",
         intel: "203d22fbafdab9f6b0cda962ec573e32ab970894c63b1dfb0409378f28b9c344"

  url "https://downloads.claude.ai/claude-code-releases/#{version}/darwin-#{arch}/claude"
  name "Claude Code"
  desc "Terminal-based AI coding assistant"
  homepage "https://claude.com/product/claude-code"

  livecheck do
    url "https://downloads.claude.ai/claude-code-releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  conflicts_with cask: "claude-code"
  depends_on :macos

  binary "claude"

  # Same payload as the official homebrew/cask `claude-code@latest`, plus this
  # one step.
  #
  # Homebrew quarantines the download, so the first launch of `claude` after
  # every upgrade shows Gatekeeper's "downloaded from the Internet" dialog and
  # waits for a click in the GUI (it hangs over SSH, or when an agent runner
  # starts `claude`). Clearing the flag at install time removes the dialog for
  # every launch path; nothing re-adds it until the next upgrade, which runs
  # this step again.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  zap trash: [
        "~/.cache/claude",
        "~/.claude.json*",
        "~/.config/claude",
        "~/.local/bin/claude",
        "~/.local/share/claude",
        "~/.local/state/claude",
        "~/Library/Caches/claude-cli-nodejs",
      ],
      rmdir: "~/.claude"
end
