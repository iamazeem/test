class Zsv < Formula
  desc "zsv+lib: world's fastest (simd) CSV parser, with an extensible CLI"
  homepage 'https://github.com/liquidaty/zsv'
  head 'https://github.com/liquidaty/zsv.git', branch: 'main'
  license 'MIT'

  if OS.mac?
    if Hardware::CPU.intel?
      url 'https://github.com/liquidaty/zsv/releases/download/v0.4.2-alpha/zsv-0.4.2-alpha-amd64-macosx-gcc.zip'
      sha256 'a7f459253da3afeca163b80b8fcf0a1351bd275947ae50028c1c6b585dc1ac02'
    elsif Hardware::CPU.arm?
      url 'https://github.com/liquidaty/zsv/releases/download/v0.4.2-alpha/zsv-0.4.2-alpha-arm64-macosx-gcc.zip'
      sha256 '86886853e555366efa39279dab5ae0069faa01a7e3d45bba0201678e6dad6ce4'
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url 'https://github.com/liquidaty/zsv/releases/download/v0.4.2-alpha/zsv-0.4.2-alpha-amd64-linux-gcc.zip'
      sha256 'df4786e55665f95daf583cca5931ecb21e2ad614e838ddc0e83724769df94240'
    end
  end

  def install
    bin.install 'bin/zsv'
  end

  test do
    assert_match /zsv version/, shell_output("#{bin}/zsv version", 2)
  end
end
