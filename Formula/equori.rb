# Rendered by scripts/render-formula.sh on each release (ADR 022, R5); edit the template, not the tap.
class Equori < Formula
  desc "Self-hosted personal finance manager"
  homepage "https://github.com/andrelopes-code/equori"
  version "0.1.0-beta.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.6/equori_0.1.0-beta.6_darwin_arm64.tar.gz"
      sha256 "7f5dc364f279ee3bfd4f3c0c375d381f2050f70f7e5de70a0568ff7755e0357e"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.6/equori_0.1.0-beta.6_darwin_amd64.tar.gz"
      sha256 "289828d1a7ae5ebf6d2d6d2c9a632307b00fb41cb758b780074182b58917c332"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.6/equori_0.1.0-beta.6_linux_arm64.tar.gz"
      sha256 "1ea14b08e60b2860454cacfe23822b941502ca3ff05deec2c622c24dbe140cde"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.6/equori_0.1.0-beta.6_linux_amd64.tar.gz"
      sha256 "16894b6834f90a0263b493e0ce87f6ff3aa57bd9ec478e9b6c991f7eddca0e09"
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
