# Rendered by scripts/render-formula.sh on each release (ADR 022, R5); edit the template, not the tap.
class Equori < Formula
  desc "Self-hosted personal finance manager"
  homepage "https://github.com/andrelopes-code/equori"
  version "0.1.0-beta.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.3/equori_0.1.0-beta.3_darwin_arm64.tar.gz"
      sha256 "69ddd82b741ec13f37efed659e46f11955ecac0186fd1e61620866ecf6f8e470"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.3/equori_0.1.0-beta.3_darwin_amd64.tar.gz"
      sha256 "f2b845df1e3db1da1e84de266d8e418a3ebfccd68be7b41ff851983cf2a123fc"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.3/equori_0.1.0-beta.3_linux_arm64.tar.gz"
      sha256 "8e60b1a26e1ed1c905127619c7a3314384bcb91050a0737bc66a837ad9792f5c"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.3/equori_0.1.0-beta.3_linux_amd64.tar.gz"
      sha256 "80a7de0dd06850fcd9f986cdb02f613ff94875d285ae31f9ddc386924db6cc9c"
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
