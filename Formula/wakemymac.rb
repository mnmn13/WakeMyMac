class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.9/WakeMyMac_1.0.9.tar.gz"
  sha256 "82f83adab80c2087337dadd044674f8fcc259b89f2c1f5ac41a314c62ee2937a"
  license "MIT"
  version "1.0.9"

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
