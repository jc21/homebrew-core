class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.4.1.tar.gz"
  sha256 "cf4ff79357a3e6ef4ea9c8b9e8fb46cf6400701ef0064e1b4ba00a1c4846ceac"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a51e17f553aa9d493bf806489fa506c178fed38b18b45a94cd6cbb8a50ed042"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9717191935a921a937474cc785728238efe4cbea9d590d97927f4f9c990d5e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "61a163991b33aa679931917fb1952aa9d6c3b3bf57c5637c24be89da513cb49f"
    sha256 cellar: :any_skip_relocation, ventura:       "08bdbf866a823ba2d27db510eaaf191d0c2a87a69687b86c5efa96e546f43d51"
    sha256                               x86_64_linux:  "a157d806c66671dec34bd0dc3dd7ae5fe193e59a527579db79ba7d3fe1824770"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
