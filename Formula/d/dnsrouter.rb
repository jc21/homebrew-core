class Dnsrouter < Formula
  desc "Simple DNS daemon to redirect requests based on domain names"
  homepage "https://github.com/jc21/dnsrouter"
  url "https://github.com/jc21/dnsrouter/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "26dae6360454781ca4da9c2f8124c5dbb62fee882c11d8fa2c99e2f277923951"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "on"

    path = buildpath/"src/github.com/jc21/dnsrouter"
    path.install buildpath.children

    cd path do
      system "go", "build", "-v", "-o", opt_bin/"dnsrouter", "cmd/dnsrouter/main.go"
    end
  end

  service do
    run [opt_bin/"dnsrouter", "-c", "#{etc}/dnsrouter/config.json"]
    keep_alive false
    working_dir var
    log_path var/"log/dnsrouter.log"
    error_log_path var/"log/dnsrouter.log"
  end

  def post_install
    (etc/"dnsrouter").mkpath
    system opt_bin/"dnsrouter", "-c", "#{etc}/dnsrouter/config.json", "-w"
    ohai "dnsrouter is now installed!"
    ohai "You will have to modify the configuration file located at:\n  #{etc}/dnsrouter/config.json"
    ohai "To start the service run:\n  sudo brew services start dnsrouter"
  end

  test do
    system "#{sbin}/dnsrouter", "-c", "#{etc}/dnsrouter/config.json", "-w"
  end
end
