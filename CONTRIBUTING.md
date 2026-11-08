# Maintaining the tap

## Publish

Create the public GitHub repository `dualcommander/homebrew-tap` and push this
directory as its root. No fork of Homebrew/homebrew-cask is needed.

## Validate on macOS and Linux

Requires Homebrew and Make. After publishing, install the tap and run checks from
this repository:

```sh
brew tap dualcommander/tap
make check
brew audit --new --cask dualcommander/tap/dualcommander
brew install --cask dualcommander/tap/dualcommander
```

`make check` checks local cask style and audits the installed tap. When editing a
separate clone, copy `Casks/dualcommander.rb` into
`$(brew --repository dualcommander/tap)/Casks/dualcommander.rb` before auditing so
Homebrew checks the edited version. `--new` may report official-repository policy
issues such as signing or notability; a custom tap does not establish Gatekeeper
approval. Check first launch manually on Apple Silicon and Intel Macs, and on
ARM64 and x86_64 Linux desktops. On Linux, run `dualcommander` after installation
and confirm both panes and file operations work.

The Linux artifact only links the executable into Homebrew's bin directory;
it does not run the archive's Makefile or install its desktop entry and icon.
For version 0.2.0, both Linux binaries require glibc 2.38+ and system libGL,
libX11, and libwayland-client. Installing Homebrew's glibc does not automatically
retarget these upstream ELF binaries to Homebrew's runtime.

## Update a release

Download both macOS ZIP assets and both Linux tar.xz assets from the new
[release](https://github.com/dualcommander/dualcommander/releases) and compute their
SHA-256 hashes with `shasum -a 256` (or `sha256sum` on Linux). Update `version`
and all four `sha256` values in `Casks/dualcommander.rb`. Keep the app bundle and
Linux executable paths aligned with archive contents. Inspect Linux dependencies
with `readelf -d` and `readelf --version-info`; update runtime requirements in
the cask caveats and README when they change.

Run the validation commands above before pushing. `brew livecheck --cask
dualcommander/tap/dualcommander` reports newer releases; it does not edit the cask.
The cask installs its declared version until a maintainer updates it.

For a signed release, validate the extracted app on macOS:

```sh
codesign --verify --deep --strict --verbose=2 DualCommander.app
spctl --assess --type execute --verbose=2 DualCommander.app
```

Do not replace version 0.2.0 assets in place to add signing: that changes their
hashes. Publish a new version, validate it, then update this tap and its warning.

No release automation or credentials are configured. No `zap` stanza is provided;
uninstalling the app leaves user settings intact.
