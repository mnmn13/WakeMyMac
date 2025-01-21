class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.12/WakeMyMac_1.0.12.tar.gz"
  sha256 "32b60b365784e4ba585a10c273ed03146fd8b88b999b4d491bb13d4b40441dad"
  license "MIT"
  version "1.0.12"

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
