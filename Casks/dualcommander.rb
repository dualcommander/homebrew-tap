cask "dualcommander" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"
  ext = on_system_conditional macos: "zip", linux: "tar.xz"

  version "0.2.2"
  sha256 arm:          "9bbe7ee9d382ac060417af67f1ae6e7b2a6adb9694568db18ba0f345a33f0a73",
         intel:        "aea2757fa0e15e5dd22e36a23f12151cbc5fa211729a5249a251eda7caa2813e",
         arm64_linux:  "96cd55b9a42791817c89d1e35c6c1edab52e31636bbb358cbc7fedcf93fb7b48",
         x86_64_linux: "1fc2c673e7b0f752a96592ef1c4699a66677836fa65eeaf8fd25829279aa225b"

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
