class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.5/WakeMyMac_1.0.5.tar.gz"
  sha256 "531fa16e4abaee9d2d516333b198d969d9159bed477caf8aa52206e2bf79463f"
  license "MIT"
  version "1.0.5"

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
