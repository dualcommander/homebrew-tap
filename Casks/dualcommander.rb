cask "dualcommander" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"
  ext = on_system_conditional macos: "zip", linux: "tar.xz"

  version "0.4.1"
  sha256 arm:          "58ebeaee288d231134b3627ecf6d21515d5b599a4a487ba2619d67a3a7086787",
         intel:        "f1bd018934a19779b58197a2fb32a81055ac9bf18d0b9c12cabc5a52d11a3015",
         arm64_linux:  "e573d25db63e6f90bff90eeba4c24247851acd4882332e12d15d7dbcd062b35d",
         x86_64_linux: "d161ba4fde39c032dfe97beddd76acf3d0f2d2a25c2a607ed957875215722705"

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

  url "https://github.com/dualcommander/dualcommander/releases/download/v#{version}/dualcommander-#{os}-#{arch}.#{ext}"
  name "DualCommander"
  desc "Keyboard-friendly two-pane file manager"
  homepage "https://dualcommander.github.io/"

  livecheck do
    url :url
    strategy :github_latest
  end
end
