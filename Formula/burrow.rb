# Template for the Homebrew formula. The release workflow substitutes
# 0.2.1 and the four @@SHA256_*@@ placeholders, then pushes the rendered
# Formula/burrow.rb to the solidsilver/homebrew-burrow tap.
class Burrow < Formula
  desc "Distributed backup among friends, over iroh"
  homepage "https://github.com/solidsilver/burrow"
  version "0.2.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    # Apple Silicon only; Intel macOS is not published (build from source).
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "f922c1fa6b8c98b37ec1d33abfdeddec314f89045c212246af752619df98f130"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba82ae0e3dfb702d9df3a41bc7555b42bfa58085dd9ace4fd6f54293a30c554c"
    end
    on_intel do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c38012a1b7193b9eb67fdde85b2bfe88645879fb0cc2fdb15bec022ca48ed5fd"
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
