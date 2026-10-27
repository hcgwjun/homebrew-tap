class Vtop < Formula
  desc "Terminal monitor for vLLM: server metrics, GPU/CPU hardware and per-request traces on one screen (macOS and Linux)"
  homepage "https://github.com/hcgwjun/vtop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hcgwjun/vtop/releases/download/v0.1.0/vtop-aarch64-apple-darwin.tar.xz"
      sha256 "fb18a65a6ff83488914994704da36f909f064493c0eff2f99aacba13cf0e2e82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hcgwjun/vtop/releases/download/v0.1.0/vtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a3d20ea0d90d69a7d4f51fa4273c47afa9d68f024bc1d9e744b9c814da262d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hcgwjun/vtop/releases/download/v0.1.0/vtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2a829445e7287b1f61f2e7a52e6707edcdeef4f2ed9849e0dcf02e46b24794cb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vtop"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vtop"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vtop"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
