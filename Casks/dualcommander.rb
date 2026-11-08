cask "dualcommander" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"
  ext = on_system_conditional macos: "zip", linux: "tar.xz"

  version "0.2.0"
  sha256 arm:          "b256c9b9b5ba8a9e5a3ab1c3a47e88e70dab1c58b15b5107e09f0ca7f64b3d49",
         intel:        "19d1060f2357f6dfaa7eeaad134d9a42682fdf8c0a730caba14930278dbdbb20",
         arm64_linux:  "ed2216070915e80b34fa65b5a21984e9644a8fd5a92a3e340728944a30bcfa95",
         x86_64_linux: "61ecd484699841ab6908d81b7a079e67ed0f0c4d96f4f4169d4fee9929dd8ce7"

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
