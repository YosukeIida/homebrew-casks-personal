class BacklogMd < Formula
  desc "Markdown-native Task Manager & Kanban visualizer for any Git repository (nodeless native binary)"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md-darwin-arm64/-/backlog.md-darwin-arm64-1.48.0.tgz"
  sha256 "ff1ce768a60b458df37dcbec37c54b2a3304aa3e09b2be4c1b64304dcc28386f"
  license "MIT"

  # Upstream ships this as an npm package with a Node.js dispatcher shim
  # (scripts/cli.cjs) that just execs a precompiled per-platform binary
  # from an optionalDependency package. This formula skips the shim and
  # installs that binary directly, so no Node.js dependency is pulled in.
  # Homebrew's own "backlog-md" formula (homebrew-core) requires Node;
  # this one is a drop-in nodeless replacement for darwin-arm64 only.

  def install
    bin.install "backlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")
  end
end
