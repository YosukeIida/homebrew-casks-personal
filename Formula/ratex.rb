class Ratex < Formula
  desc "LaTeX math renderer in pure Rust: formulas to SVG (prebuilt CLI)"
  homepage "https://github.com/erweixin/RaTeX"
  version "0.1.15"
  url "https://github.com/erweixin/RaTeX/releases/download/v#{version}/ratex-cli-v#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "2fe21963fab59b459288c4ee5cfc97961ce69ed52f6af669a9658da3f6ca2f9a"
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
