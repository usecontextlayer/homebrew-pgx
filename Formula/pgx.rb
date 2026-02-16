class Pgx < Formula
  desc "Run embedded PostgreSQL 18 locally"
  homepage "https://github.com/usecontextlayer/pgx"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-aarch64-apple-darwin.tar.xz"
      sha256 "883a03fac1a16cfbd6cb751bbb403a64f3f0ab11c2291279552f9b13e69af3e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-x86_64-apple-darwin.tar.xz"
      sha256 "db5b8ac367494b9b72fc8bb33ea9e03d42b3334050ec9bf9af67e89a0cbb9d32"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf886740bf22a674cf543eb15dc1b44efd9258969c77141fd57d561f5fdbef29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/usecontextlayer/pgx/releases/download/v0.1.0/pgx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f4580801809d192ce9a89337862453bea1a6680c2fb18721f54b6ce6a9617ceb"
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
