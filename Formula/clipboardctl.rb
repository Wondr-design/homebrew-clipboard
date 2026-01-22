class Clipboardctl < Formula
  desc "AI Smart Clipboard Manager CLI"
  homepage "https://github.com/Wondr-design/smart-clipboard"
  version "0.1.0"
  license "MIT"

  on_macos do
    url "https://github.com/Wondr-design/smart-clipboard/releases/download/v0.1.0/clipboardctl-v0.1.0-darwin-universal.tar.gz"
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  end

  depends_on :macos

  def install
    bin.install "clipboardctl"
    bin.install "clipboard-daemon"
  end

  service do
    run [opt_bin/"clipboard-daemon"]
    keep_alive true
    log_path var/"log/clipboard-daemon.log"
    error_log_path var/"log/clipboard-daemon.log"
  end

  def caveats
    <<~EOS
      To start the clipboard daemon service:
        brew services start clipboardctl

      Or run manually:
        clipboardctl daemon start

      Configuration file:
        ~/.config/clipboard-manager/config.yaml
    EOS
  end

  test do
    assert_match "clipboardctl", shell_output("#{bin}/clipboardctl --help")
  end
end
