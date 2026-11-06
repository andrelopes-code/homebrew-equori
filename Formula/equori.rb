# Rendered by scripts/render-formula.sh on each release (ADR 022, R5); edit the template, not the tap.
class Equori < Formula
  desc "Self-hosted personal finance manager"
  homepage "https://github.com/andrelopes-code/equori"
  version "0.1.0-beta.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.4/equori_0.1.0-beta.4_darwin_arm64.tar.gz"
      sha256 "b55b69b1eeb5c75b003b7bd9880ab01044959a9f51102535c4daf35e4f133856"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.4/equori_0.1.0-beta.4_darwin_amd64.tar.gz"
      sha256 "bf61f6d26e50371391148fb3b040f4ee15470743d09e25a99e2f7a1097c7d901"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.4/equori_0.1.0-beta.4_linux_arm64.tar.gz"
      sha256 "895c4be1edd4415a03fd780eeaf511096817cfdd49bde98a755e1459e590dcec"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.4/equori_0.1.0-beta.4_linux_amd64.tar.gz"
      sha256 "d5d9ee33e7a52c14ad39b9c19b2017739c72a1465a955749ee577cbce2628873"
    end
  end

  depends_on "postgresql@18"

  def install
    libexec.install "equori"
    (bin/"equori").write_env_script libexec/"equori", EQUORI_POSTGRES_BIN: Formula["postgresql@18"].opt_bin
  end

  service do
    run [opt_bin/"equori", "serve"]
    environment_variables EQUORI_HTTP_ADDR: "127.0.0.1:8080"
    keep_alive true
    log_path var/"log/equori.log"
    error_log_path var/"log/equori.log"
  end

  def caveats
    <<~EOS
      Start equori in the background:
        brew services start equori
      Create the first user:
        equori user create --email you@example.com --language <code> --region <country> --admin
      Then open http://127.0.0.1:8080

      Data, backups, secret.key and settings (equori.env) live in
        ~/Library/Application Support/equori   on macOS
        ~/.local/share/equori                  on Linux
      Back up secret.key apart from the backups: equori secrets key prints it.
    EOS
  end

  test do
    assert_match "postgresql >= 18", shell_output("#{bin}/equori version")
  end
end
