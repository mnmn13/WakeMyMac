class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.6/WakeMyMac_1.0.6.tar.gz"
  sha256 "79bc02122e7ea38cec5fe54ce81b7703cc83a663fe47c0905fad64312f2c9a8c"
  license "MIT"
  version "1.0.6"

  def install
    bin.install "WakeMyMac" => "wake"
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
