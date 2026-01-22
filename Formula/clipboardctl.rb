class Clipboardctl < Formula
  desc "AI Smart Clipboard Manager CLI"
  homepage "https://github.com/Wondr-design/clipboard"
  version "0.1.0"
  license "MIT"

  on_macos do
    url "https://github.com/Wondr-design/clipboard/releases/download/v0.1.0/clipboardctl-v0.1.0-darwin-universal.tar.gz"
    sha256 "PLACEHOLDER_SHA256"
  end

  depends_on :macos
  depends_on "uv"

  def install
    bin.install "clipboardctl"
    bin.install "clipboard-daemon"
    
    # Install Python AI worker
    libexec.install Dir["python-ai/*"]
  end

  def post_install
    # Create config directory
    (var/"clipboard-manager").mkpath
    
    # Set up Python environment with uv for AI worker
    ohai "Setting up Python AI worker with uv..."
    system "uv", "sync", "--project", "#{libexec}"
  end

  service do
    run [opt_bin/"clipboard-daemon"]
    keep_alive true
    log_path var/"log/clipboard-daemon.log"
    error_log_path var/"log/clipboard-daemon.log"
    working_dir var/"clipboard-manager"
    environment_variables CLIPBOARD_PYTHON_WORKER_PATH: "#{opt_libexec}"
  end

  def caveats
    <<~EOS
      To start the clipboard daemon service:
        brew services start clipboardctl

      Or run manually:
        clipboardctl daemon start

      The clipboard history is stored in:
        ~/Library/Application Support/ClipboardManager/

      Configuration file:
        ~/.config/clipboard-manager/config.yaml

      For AI features on Apple Silicon, ensure you have:
        - Python 3.11+
        - MLX and MLX-LM (will be installed automatically)
    EOS
  end

  test do
    assert_match "clipboardctl", shell_output("#{bin}/clipboardctl --help")
    assert_match version.to_s, shell_output("#{bin}/clipboardctl --version")
  end
end
