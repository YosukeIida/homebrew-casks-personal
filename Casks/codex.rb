cask "codex" do
  arch arm: "aarch64", intel: "x86_64"

  # Bumped by .github/workflows/bump.yml (scripts/bump-codex.sh).
  version "0.168.0"
  sha256 arm:   "2795694bb5b89234e3da0dd0c2c9e7a71764521080caed17bf12c1e0458058ca",
         intel: "67993fcb3051a1261c68751e1171f9c5a01662dfa42268cc58ea39cd175981a5"

  url "https://github.com/openai/codex/releases/download/rust-v#{version}/codex-package-#{arch}-apple-darwin.tar.gz"
  name "Codex"
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"

  livecheck do
    url :url
    regex(/^rust[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on :macos

  binary "bin/codex"
  generate_completions_from_executable "bin/codex", "completion"

  # Same payload as the official homebrew/cask `codex`, plus this one step.
  #
  # Homebrew quarantines the download and copies the flag onto every extracted
  # file (cask/download.rb, Quarantine.propagate). The official cask then runs
  # `bin/codex completion` to generate shell completions, so the first exec of
  # the new binary happens inside `brew upgrade` and Gatekeeper's "downloaded
  # from the Internet" dialog blocks the upgrade until someone clicks it in the
  # GUI. There is no user-side opt-out: `--no-quarantine` is gone in Homebrew 7,
  # and the cached download is re-quarantined on every reuse.
  #
  # Preflight steps run after extraction but before `binary` and
  # `generate_completions_from_executable` (cask/artifact/abstract_artifact.rb),
  # so clearing the flag here removes the dialog both from the upgrade and from
  # the first launch. It also covers the bundled `codex-path/rg`.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  zap rmdir: "~/.codex"
end
