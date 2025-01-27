class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.1.0/WakeMyMac_1.1.0.tar.gz"
  sha256 "42bb5eb565d78356c847b1d38e613398a42ae845da3f341b06f1188b94bb6d0d"
  license "Apache-2.0"
  version "1.1.0"

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
