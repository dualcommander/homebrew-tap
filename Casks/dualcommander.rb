cask "dualcommander" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"
  ext = on_system_conditional macos: "zip", linux: "tar.xz"

  version "0.4.0"
  sha256 arm:          "318d598f76ebf9117010bc57de83a0f7393c0c77ebef299c4791c57b151449e8",
         intel:        "edaf0a10c6b1e3d255680340a17c2f67c14a797109a04a942f1d7d0ec70abd30",
         arm64_linux:  "05ba14b77008d027556f0d30e90a6c7bd1e5c9bd04a6317e7fa2f95c252a1b05",
         x86_64_linux: "6db0ecdd57cd39d0795b5abff684df0069ed35a3066dc4fd22ff99a5019936df"

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
