class Wakemymac < Formula
  desc "CLI tool to prevent Mac from sleeping, energy-efficient sleep prevention."
  homepage "https://github.com/mnmn13/WakeMyMac"
  url "https://github.com/mnmn13/WakeMyMac/releases/download/v1.0.0/WakeMyMac.tar.gz"
  sha256 "PLACEHOLDER_FOR_SHA256"
  license "MIT"

  def install
    bin.install "WakeMyMac" => "wake"
  end

  test do
    system "#{bin}/wake", "--version"
  end
end
