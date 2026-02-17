class Pgx < Formula
  desc "Run embedded PostgreSQL 18 locally"
  homepage "https://github.com/usecontextlayer/pgx"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-aarch64-apple-darwin.tar.xz"
      sha256 "2ba551325bf3ad9db74e1f58768bec7f1364e3f9fd41f9fd08e188760eb1a8bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-x86_64-apple-darwin.tar.xz"
      sha256 "ad0b4d7513fc8c07640d38b96d5c97eaab04cb6a0cf6fd7333e1485ed75bddd5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d84dfb685081ca35f3aa6553e1d365be64e744583909e0e24ed4fff889bdbfe0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a9f981a44180e7ed13df92f67caa8f02813c08c031e1a4714789fcad48d6a7f"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "pgx" if OS.mac? && Hardware::CPU.arm?
    bin.install "pgx" if OS.mac? && Hardware::CPU.intel?
    bin.install "pgx" if OS.linux? && Hardware::CPU.arm?
    bin.install "pgx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
