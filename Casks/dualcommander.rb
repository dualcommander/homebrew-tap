cask "dualcommander" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"
  ext = on_system_conditional macos: "zip", linux: "tar.xz"

  version "0.3.0"
  sha256 arm:          "e4cec14ce00aabc38c9a22888147ff6674e43e2ca90254521ebb28d4a346cf76",
         intel:        "2b6a19b8d68b70910179be82b28c69bd585f1648473fc007ed51cb7b6620f718",
         arm64_linux:  "04aa150b9356b493fcbcff1a95ae5da74f37f5b3957b867592408a4078493dce",
         x86_64_linux: "a82b2856854ea6e9d6e4c502e43a089cecd7f035642766419a58eadbf585b3f1"

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
