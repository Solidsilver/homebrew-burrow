# Template for the Homebrew formula. The release workflow substitutes
# 0.2.3 and the three @@SHA256_*@@ placeholders, then pushes the
# rendered Formula/burrow.rb to the solidsilver/homebrew-burrow tap.
class Burrow < Formula
  desc "Distributed backup among friends, over iroh"
  homepage "https://github.com/solidsilver/burrow"
  version "0.2.3"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    # Apple Silicon only; Intel macOS is not published (build from source).
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "7515db708024c3d90268c09768a9f12e18e110393bbcce35153baa972ab93440"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "701827c37ef601e23e9382403c5e3fd9a2ea74629fac0cdd20fe4fbd5302db18"
    end
    on_intel do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "755744711eceb5bab312ea07b77da8c8767e22c1fd401075b2581dd9e407f451"
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
