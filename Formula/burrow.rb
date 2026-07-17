# Template for the Homebrew formula. The release workflow substitutes
# 0.2.0 and the four @@SHA256_*@@ placeholders, then pushes the rendered
# Formula/burrow.rb to the solidsilver/homebrew-burrow tap.
class Burrow < Formula
  desc "Distributed backup among friends, over iroh"
  homepage "https://github.com/solidsilver/burrow"
  version "0.2.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    # Apple Silicon only; Intel macOS is not published (build from source).
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "2522f47a57baa06a333b194e6bea22ee733028f3c62fe6fe1eea9baf7a50778c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "228388710027d26dc1473fb97a8ae268b519e47ec65d3a146deb9f5b505bb0d3"
    end
    on_intel do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f526ab476ae48cfd3cccdd331b8193a46e33478461fd8f9d41a895fde2edad55"
    end
  end

  def install
    bin.install "burrow"
    doc.install "README.md", "LICENSE-MIT", "LICENSE-APACHE", "config.example.toml"
  end

  service do
    run [opt_bin/"burrow", "daemon", "run"]
    keep_alive true
    log_path var/"log/burrow.log"
    error_log_path var/"log/burrow.log"
    working_dir var
  end

  def caveats
    <<~EOS
      Before starting the service for the first time, initialise burrow:

        burrow init

      This prints a 24-word recovery phrase — store it somewhere safe and OFF
      this machine. Then start the background daemon with:

        brew services start burrow

      Config lives in ~/.config/burrow, data in ~/.local/share/burrow.
    EOS
  end

  test do
    assert_match "burrow", shell_output("#{bin}/burrow --help")
  end
end
