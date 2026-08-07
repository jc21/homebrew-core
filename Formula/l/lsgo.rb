class Lsgo < Formula
  desc "A modern, colourful ls replacement, written in Go with zero external dependencies"
  homepage "https://github.com/jc21/lsgo"
  url "https://github.com/jc21/lsgo/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "6e2e39d996d005ac3009e34c77a4093319875bb528da4cf488e1167def94c39f"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build",
      "-v",
      "-ldflags", "-X main.Version=v#{version}",
      "-o", bin/"lsgo",
      "main.go"
  end

  test do
    system bin/"lsgo", "-lag"
  end
end
