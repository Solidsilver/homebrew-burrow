# Template for the Homebrew formula. The release workflow substitutes
# 0.2.2 and the three @@SHA256_*@@ placeholders, then pushes the
# rendered Formula/burrow.rb to the solidsilver/homebrew-burrow tap.
class Burrow < Formula
  desc "Distributed backup among friends, over iroh"
  homepage "https://github.com/solidsilver/burrow"
  version "0.2.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    # Apple Silicon only; Intel macOS is not published (build from source).
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "aa67e03adc603a9c62a22ee1d84055537ed03612be630bea19246d7d272cc65b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d237147d270b546bbd73753b228069382101854915c8a9ad02fb0dfc87ee1bd"
    end
    on_intel do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4feb99bd9bfaafdee2e88bf793924c1ff59f0c7309eff794ea4a914fa81288d1"
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
