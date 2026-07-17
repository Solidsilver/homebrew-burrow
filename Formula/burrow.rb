# Template for the Homebrew formula. The release workflow substitutes
# 0.1.2 and the four @@SHA256_*@@ placeholders, then pushes the rendered
# Formula/burrow.rb to the solidsilver/homebrew-burrow tap.
class Burrow < Formula
  desc "Distributed backup among friends, over iroh"
  homepage "https://github.com/solidsilver/burrow"
  version "0.1.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    # Apple Silicon only; Intel macOS is not published (build from source).
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "ec2566b9f823ed3c63d055518a03b31d9b4cc9a2761b21f888baeafd65360e73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c40f142512f745fe39297f4d619f516aca2cb036747f38f10d15efed79c8f122"
    end
    on_intel do
      url "https://github.com/solidsilver/burrow/releases/download/v#{version}/burrow-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3cef61f0f7c252d7892ad429ad21ab8a28f2ec771bfe813f3f6ea9c58f13c2a5"
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
