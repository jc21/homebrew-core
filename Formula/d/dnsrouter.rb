class Dnsrouter < Formula
  desc "Simple DNS daemon to redirect requests based on domain names"
  homepage "https://github.com/jc21/dnsrouter"
  url "https://github.com/jc21/dnsrouter/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "69f27fd7a7b782092345e8119f54222cdc456e697fa59a5ec74ece474807bdd5"
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
