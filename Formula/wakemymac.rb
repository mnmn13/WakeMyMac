class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v.1.0.10/WakeMyMac_.1.0.10.tar.gz"
  sha256 "1e35fae0c153aeab0e4d78d9bc9c07170f7f68e6ccaa7ba14e58bd4a9b6c712b"
  license "MIT"
  version ".1.0.10"

  def install
    bin.install "WakeMyMac_universal" => "wake"
  end
  
  def caveats
    <<~EOS
        export PATH="/usr/local/bin:$PATH"
        source ~/.zshrc
    EOS
  end

  test do
    system "#{bin}/wake", "--version"
  end
end
