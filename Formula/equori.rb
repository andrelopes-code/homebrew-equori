# Rendered by scripts/render-formula.sh on each release (ADR 022, R5); edit the template, not the tap.
class Equori < Formula
  desc "Self-hosted personal finance manager"
  homepage "https://github.com/andrelopes-code/equori"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.3/equori_0.1.3_darwin_arm64.tar.gz"
      sha256 "c101cffe096a23b716686066422d2ae53902a0eab8dd8d6d1c91aa2f3acf8395"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.3/equori_0.1.3_darwin_amd64.tar.gz"
      sha256 "91ade6c7634a01a20e7fa476aeb6006133a0d3fe9d452d0e3da3a5678df6528e"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.3/equori_0.1.3_linux_arm64.tar.gz"
      sha256 "21ce84b21ace6cb89d104909623f536cb48dae783503a98a1e04c9cacb36187c"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.3/equori_0.1.3_linux_amd64.tar.gz"
      sha256 "b570fad321893f588a2cdef72a18bdebe587947a9a3a7deadd502ba0add62c22"
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
