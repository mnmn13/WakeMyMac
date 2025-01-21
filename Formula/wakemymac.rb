class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.0/WakeMyMac_1.0.0.tar.gz"
  sha256 "3160db3e312ed849fc49c45a141828b23138982687e5d09c5b44066b1301d9e0"
  license "MIT"
  version "1.0.0"

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
