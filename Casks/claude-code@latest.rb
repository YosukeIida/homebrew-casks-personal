cask "claude-code@latest" do
  arch arm: "arm64", intel: "x64"

  # Bumped by .github/workflows/bump.yml (scripts/bump-claude-code.sh).
  version "2.1.312"
  sha256 arm:   "6b5ec691195e551b02c41df9f7d723f4ea61eaa03c2df90acefe3736f1aeb620",
         intel: "9534770e162cfd6e39301d9ab775affce214df032a68484085bdbab966a7f8cf"

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
