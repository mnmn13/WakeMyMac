class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.4/WakeMyMac_1.0.4.tar.gz"
  sha256 "bd22635ec24fd5aa6dd6b4277e83eeabc32f45b72b4afb6f774071162fc9d8b4"
  license "MIT"
  version "1.0.4"

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
