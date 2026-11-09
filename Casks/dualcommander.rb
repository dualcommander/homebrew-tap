cask "dualcommander" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"
  ext = on_system_conditional macos: "zip", linux: "tar.xz"

  version "0.2.1"
  sha256 arm:          "4857176a01a72193339597cb77f7b66d0b43745c9ec83e75bfb6f8ced051225b",
         intel:        "6ec934205a4f9ec63a11036a464e63e79d6491542f8899928eabb5c8f65b276c",
         arm64_linux:  "99deef22dc7eabef3678a856f265fa7e77173bba4c0362b8f9d1939dee18c45c",
         x86_64_linux: "3bf5a1222091d008251e7cc07f5130eb6d0e8a3777abac6153d6242090970dc2"

  url "https://github.com/dualcommander/dualcommander/releases/download/v#{version}/dualcommander-#{os}-#{arch}.#{ext}"
  name "DualCommander"
  desc "Keyboard-friendly two-pane file manager"
  homepage "https://dualcommander.github.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    app "DualCommander.app"
  end

  on_linux do
    binary "dualcommander/usr/local/bin/dualcommander"

    caveats do
      <<~EOS
        Requires system glibc 2.38+, libGL, libX11, libwayland-client,
        and a graphical desktop session. Homebrew does not install these
        system runtime requirements for this prebuilt binary.
        Launch with: dualcommander
        No desktop launcher or icon is installed by this cask.
      EOS
    end
  end
end
