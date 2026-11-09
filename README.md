# DualCommander Homebrew tap

Custom cask for [DualCommander](https://dualcommander.github.io/),
for Apple Silicon and Intel Macs, plus ARM64 and x86_64 Linux. Publish this repository as
`dualcommander/homebrew-tap` before using the install command.

## Install

Requires [Homebrew](https://brew.sh/).

**macOS downloads have no app code-signature bundle. Gatekeeper may
block first launch. Review macOS security warnings before opening; this tap does
not disable quarantine or bypass Gatekeeper.**

```sh
brew install --cask dualcommander/tap/dualcommander
```

Review any Homebrew trust prompt before accepting. The fully qualified cask name
limits trust to this cask rather than every package in the tap.

Linux requires system glibc 2.38+, libGL, libX11,
libwayland-client, and a graphical desktop session. Homebrew does not supply
these system requirements for the prebuilt binary. Launch with `dualcommander`;
this cask installs no desktop launcher or icon. Native Linux packages remain on
[GitHub Releases](https://github.com/dualcommander/dualcommander/releases).

[Maintaining and validating this tap](CONTRIBUTING.md)
