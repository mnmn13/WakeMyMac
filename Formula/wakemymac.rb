class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.1/WakeMyMac_1.0.1.tar.gz"
  sha256 "644683030efb21611cdb5d16ca75254bd47477fad7424bde71a7cae6c6fcc4a1"
  license "MIT"

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
