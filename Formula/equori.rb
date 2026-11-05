# Rendered by scripts/render-formula.sh on each release (ADR 022, R5); edit the template, not the tap.
class Equori < Formula
  desc "Self-hosted personal finance manager"
  homepage "https://github.com/andrelopes-code/equori"
  version "0.1.0-beta.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.2/equori_0.1.0-beta.2_darwin_arm64.tar.gz"
      sha256 "d0c898557b633405d264721a58f8697bfe04b165e6755c53088d4fc5bc81a8c1"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.2/equori_0.1.0-beta.2_darwin_amd64.tar.gz"
      sha256 "74f8094a9f75222840703871e4e7431acd478d50e554c10e57886310b27bd32a"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.2/equori_0.1.0-beta.2_linux_arm64.tar.gz"
      sha256 "d237a7e14e8649b7ad13f834fa6ee755184679c002a63a92323427047f8344d7"
    end
    on_intel do
      url "https://github.com/andrelopes-code/equori/releases/download/v0.1.0-beta.2/equori_0.1.0-beta.2_linux_amd64.tar.gz"
      sha256 "4f5044c0c6907aeb52b7e89cbc65c91bbb38e8d4458fd0d0b02ce6c28e745270"
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
