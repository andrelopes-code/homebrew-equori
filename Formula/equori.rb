# Rendered by scripts/render-formula.sh on each release (ADR 022, R5); edit the template, not the tap.
class Equori < Formula
  desc "Self-hosted personal finance manager"
  homepage "https://github.com/andrelopes-code/equori"
  version "0.1.0-beta.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.1/equori_0.1.0-beta.1_darwin_arm64.tar.gz"
      sha256 "5b6fd5f21e4bd56ab9564f40408a98c00b84439d4c50c8f82f4c24499299b6f3"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.1/equori_0.1.0-beta.1_darwin_amd64.tar.gz"
      sha256 "badcbf02c0f0166ec862be3125605bb2b09be9298c796e0187839a66ddad092b"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.1/equori_0.1.0-beta.1_linux_arm64.tar.gz"
      sha256 "851f16f3d62d7b318434a652be8112f735e45e602eee1abd06ace561e2753648"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.1/equori_0.1.0-beta.1_linux_amd64.tar.gz"
      sha256 "96d701427ed2ed4f4417d7bd3638ae01679424bd3e2343f6a924702878c13132"
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
