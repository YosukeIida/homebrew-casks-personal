class HerdrCore < Formula
  desc "Terminal runtime for coding agents (hc)"
  homepage "https://herdr.dev/core/"
  # Not built from source: it vendors ghostty as a submodule (Rust + Zig), and
  # without bottles every bump would rebuild it locally.
  # Bumped by .github/workflows/bump.yml (scripts/bump-herdr.sh).
  url "https://releases.herdr.dev/core/0.1.16/herdr-core-macos-aarch64.tar.gz"
  version "0.1.16"
  sha256 "698d8f0c44f4e4b15fec174d52a39d57a014cfd71added44b53a0753b469d0fd"
  license "Apache-2.0"

  livecheck do
    url "https://releases.herdr.dev/core/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    # Homebrew quarantines the download, and macOS removes this ad-hoc signed
    # binary on its first run while the attribute is set.
    system "/usr/bin/xattr", "-d", "com.apple.quarantine", "herdr-core"
    bin.install "herdr-core"
    bin.install_symlink bin/"herdr-core" => "hc"
  end

  test do
    system bin/"hc", "--version"
  end
end
