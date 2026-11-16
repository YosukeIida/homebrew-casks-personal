class Ratex < Formula
  desc "LaTeX math renderer in pure Rust: formulas to SVG (prebuilt CLI)"
  homepage "https://github.com/erweixin/RaTeX"
  version "0.1.16"
  url "https://github.com/erweixin/RaTeX/releases/download/v#{version}/ratex-cli-v#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "5f4545377ca6f97de36a00c34ff8699cb325a35c8662d6cd7d1da9759e30510e"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  # The upstream binaries are named render / render-svg / render-pdf, which
  # would clash with anything else on PATH; only the SVG one is installed, as
  # ratex-svg.
  def install
    bin.install "render-svg" => "ratex-svg"
  end

  test do
    svg = pipe_output("#{bin}/ratex-svg --stdout", "x^2\n")
    assert_match "<svg", svg
  end
end
