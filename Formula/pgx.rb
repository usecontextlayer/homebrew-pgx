class Pgx < Formula
  desc "Run embedded PostgreSQL 18 locally"
  homepage "https://github.com/usecontextlayer/pgx"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.3.0/pgx-aarch64-apple-darwin.tar.xz"
      sha256 "90a0d127552249f05760998596214f7f56d696f569f835279df982463d98a6a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.3.0/pgx-x86_64-apple-darwin.tar.xz"
      sha256 "38e0a63160aa0182a07c229aa3e5c3c0cd8e45ed0c1cfd052998bedf0558c36d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.3.0/pgx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7302386c98100046e8ccfb1848060a921f194c558a1c0dacfed99347fa8b820"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.3.0/pgx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14e924a99e8918dee63fed2f84bd776fd98f82a0cc60804c16aa84fe3d9ee74d"
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
