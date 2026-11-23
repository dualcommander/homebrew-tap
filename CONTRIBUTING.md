# Maintaining the tap

## Publish

Create the public GitHub repository `dualcommander/homebrew-tap` and push this
directory as its root. No fork of Homebrew/homebrew-cask is needed.

## Initial setup: GitHub App and release automation

Requires organization permission to create/install GitHub Apps, admin access to
both repositories, and [GitHub CLI](https://cli.github.com/). No personal access
token is needed for CI. App registration, installation approval, and private-key
generation use the browser; `gh` has no built-in App registration command. A
[manifest flow](https://docs.github.com/en/apps/creating-github-apps/setting-up-a-github-app/creating-a-github-app-from-a-manifest)
still needs browser approval and a redirect handshake, so use the steps below.

### 1. Create and install the App

1. Open <https://github.com/organizations/dualcommander/settings/apps/new>.
   Choose a unique App name, such as `dualcommander`, and set
   Homepage URL to `https://github.com/dualcommander/homebrew-tap`.
2. Leave callback and setup URLs empty. Do not request user authorization during
   installation or enable device flow. Under Webhook, clear **Active**; no
   webhook server or event subscriptions are needed.
3. Under Repository permissions, set **Actions**, **Contents**, and
   **Pull requests** to **Read and write**. Metadata read is automatic. Leave
   other permissions unset. Select **Only on this account**, then **Create
   GitHub App**.
4. Record **App ID** from General settings, not Client ID or installation ID.
   Under Private keys, click **Generate a private key** and save the PEM file
   outside any repository.
5. Select **Install App**, choose `dualcommander`, select **Only select
   repositories**, and choose **homebrew-tap** only. Click **Install** (or have
   an organization owner approve the request). The App does not need installation
   on the source repository. Do not grant it branch-protection bypass.

### 2. Configure environment credentials in GitHub Settings

Repeat these steps for **both** `dualcommander/dualcommander` and
`dualcommander/homebrew-tap`, using an account with repository admin access:

1. Open the repository's **Settings > Environments > New environment**. Enter
   `homebrew` exactly, then click **Configure environment**. If it exists,
   select it instead. Each repository needs its own environment; environments
   with the same name are not shared across repositories.
2. Under **Deployment branches and tags**, choose **Selected branches and tags**:
   - In `dualcommander/dualcommander`, add a **Tag** rule for `v*` only.
   - In `dualcommander/homebrew-tap`, add a **Branch** rule for `main` only.
   Do not add other ref rules. Where available, disable administrator bypass
   of environment protection rules. Required reviewers are optional: enabling
   them pauses each deployment until approval, including cross-repo updates.
3. Under **Environment secrets**, click **Add secret**. Set **Name** to
   `APP_ID` and **Secret** to the numeric **App ID** recorded in step 1
   (not Client ID or installation ID). Click **Add secret**.
4. Under **Environment secrets**, click **Add secret**. Set **Name** to
   `APP_PRIVATE_KEY`. Open the downloaded PEM file in a local text
   editor and paste its entire contents into **Secret**, including the
   `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----` lines
   (or the corresponding BEGIN/END lines present in your file), preserving
   line breaks. Click **Add secret**. Do not paste the filename or base64-encode
   the key.
5. Confirm both names appear under **Environment secrets**. GitHub does not
   display saved secret values; use **Edit** to replace either value if needed.
   Remove any old `APP_ID` entry under **Environment variables**.

Both privileged jobs declare `environment: homebrew`; PR check jobs do not.
Configure these environment rules before running workflows: YAML references
alone can create an unprotected environment, not its protection rules. Confirm
your GitHub plan supports the required environment secrets and protection rules.

If credentials were previously stored under **Settings > Secrets and variables
> Actions**, delete the repository-level `APP_ID` and `APP_PRIVATE_KEY` copies
after adding the environment entries. Also remove access to any organization-level
copies for these repositories. Otherwise jobs outside the environment can still
access those broader credentials. Never commit or print the PEM key, paste it
into command-line arguments, or expose it to PR jobs. Store a secure backup; revoke and replace
the key in App settings if compromised. No stored installation token is needed.

### 3. Enable checks and auto-merge

1. Merge this tap's `update-release.yml` and `check.yml` workflows onto `main`,
   and merge the source repository's Homebrew dispatch job before tagging.
   Confirm Actions is enabled and organization policy permits the referenced
   actions. Let **Check cask** run successfully on `main`.
2. Open <https://github.com/dualcommander/homebrew-tap/settings/branches> and
   protect `main`: require PRs, require **Cask checks**, require branches to be
   up to date, and allow no automation bypass. Required reviews still need
   human approval; merge queues are not supported. Preserve any stronger
   existing rules. Without required checks, auto-merge can merge immediately.
3. Enable squash merging and auto-merge:

   ```sh
   gh repo edit dualcommander/homebrew-tap --enable-squash-merge --enable-auto-merge
   ```

### 4. Verify activation

In each repository, open **Settings > Environments > homebrew**.
Confirm both `APP_ID` and `APP_PRIVATE_KEY` under **Environment secrets**,
and the deployment ref rules from step 2. Secret values
remain hidden. Confirm no repository/organization credential copies remain
accessible outside the environment.

After publishing a new stable release, source CI dispatches the tap automatically.
For a manual run, replace `v0.5.0` below with an existing published stable tag
newer than the cask version. This creates a real PR and enables auto-merge:

```sh
gh workflow run update-release.yml --repo dualcommander/homebrew-tap --ref main -f tag=v0.5.0
gh run list --repo dualcommander/homebrew-tap --workflow update-release.yml --limit 5
gh pr list --repo dualcommander/homebrew-tap --head automation/homebrew-release
```

Inspect the run and PR: author should be the App bot, all four hashes should
change, and **Cask checks** must pass before merge. Already-current or older
tags skip PR creation, so they do not exercise App authentication. A manual tap
run does not test source dispatch; verify that job on the next stable release.
For authentication errors, check App ID, complete PEM contents, approved
installation, selected repository, and all three App permissions. App permission
changes may require installation-owner approval.

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
Both Linux binaries require glibc 2.38+ and system libGL,
libX11, and libwayland-client. Installing Homebrew's glibc does not automatically
retarget these upstream ELF binaries to Homebrew's runtime.

## Update a release

### Automated PRs

Complete [initial setup](#initial-setup-github-app-and-release-automation) once.

`actions/create-github-app-token@v2` receives the private key and generates
short-lived installation tokens, scoped to `homebrew-tap`: source dispatch asks
only for **Actions: write**; this workflow asks for **Contents: write** and
**Pull requests: write**. Tokens are revoked at job completion. PRs are created
by the App bot and trigger normal PR checks, unlike PRs created with
`GITHUB_TOKEN`. Never expose the private key or installation tokens to PR jobs.
The private key grants the App's full installed permissions; per-job token
scopes do not reduce the key's authority. Keep the App installation tap-only.
Environment restrictions control which jobs receive the key, not the App's
authority once received. Both environments hold the same App credential;
separate Apps are needed for separate credential authority.

Source release CI dispatches **Update release** after stable release assets are
published. Manual recovery: run that workflow on `main`, with `tag` such as
`v0.5.0`. The updater runs directly in the workflow using Bash and the Ubuntu
runner's `gh`, `jq`, and coreutils; no local updater or Python setup is needed.
Release metadata and downloads use the built-in `GITHUB_TOKEN` via `GH_TOKEN`,
not anonymous requests. The source repository must be public; this token cannot
read another private repository. No additional secret or App installation is
needed for public release reads. Authenticated requests still have rate limits.

The updater downloads all four assets, hashes them, checks size and GitHub's
digest when available, and changes only version and hashes. Drafts, prereleases,
missing assets, and malformed tags fail before writing. Already-current or older
versions are skipped. Downloads are not executed. Published assets must remain
immutable. Runtime requirements and signing warnings still need manual review.

`peter-evans/create-pull-request@v7` receives the App installation token and
creates or updates `automation/homebrew-release`; the following GitHub CLI step
requests squash auto-merge with that token. This third-party action is trusted
with repository write access. GitHub merges only
once branch protection permits it; without required checks, auto-merge can merge
immediately. **Cask checks** audits the edited cask on macOS; it does not launch
the app or validate Linux runtime compatibility. A newer release can supersede
an unmerged update PR. Merged automation branches are cleaned on a later run.

### Manual updates

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

Do not replace published release assets in place to add signing: that changes their
hashes. Publish a new version, validate it, then update this tap and its warning.

No `zap` stanza is provided; uninstalling the app leaves user settings intact.
