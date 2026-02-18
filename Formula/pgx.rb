class Pgx < Formula
  desc "Run embedded PostgreSQL 18 locally"
  homepage "https://github.com/usecontextlayer/pgx"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.2.0/pgx-aarch64-apple-darwin.tar.xz"
      sha256 "58a964b517f1b0f3bf2782b523c506ffb5ac89926243ba3f241e2a0259abc913"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.2.0/pgx-x86_64-apple-darwin.tar.xz"
      sha256 "e53c7f02ad45bfadcef1fee57aceedea2157fe5861e532688e1f58dea1b484f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.2.0/pgx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5529ae81760a53acec3829471e63f7737c58012a5b021a76b16c3d2515df0cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.2.0/pgx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "65b025bb14584a328909cd10015f55c63bbff303d3f075eed09987198283bc4c"
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
