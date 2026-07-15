# homebrew-tap

Homebrew tap **and** release host for the [Macrohill](https://macrohill.com) CLI.
This repo holds the formula, the installer script, and the compiled binaries
(published as GitHub Releases by the private `prod` repo's CI).

## Install

**macOS / Linux (any) — curl:**

```sh
curl -fsSL https://raw.githubusercontent.com/pUrGe12/homebrew-tap/main/install.sh | sh
```

**Homebrew:**

```sh
brew install pUrGe12/tap/macrohill
```

Pin a version or install location with the installer:

```sh
MACROHILL_VERSION=0.1.0 MACROHILL_BIN_DIR="$HOME/.local/bin" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/pUrGe12/homebrew-tap/main/install.sh)"
```

Then:

```sh
macrohill login
macrohill run config.yaml
```

## Notes

- Supported platforms: macOS (arm64, x86_64) and Linux (x86_64, arm64).
- `Formula/macrohill.rb` is **generated on release** (do not hand-edit); it pins
  each binary's SHA-256 from the release's `SHASUMS256.txt`.
- A `.deb` is attached to each release too — `sudo dpkg -i macrohill_<ver>_<arch>.deb`.
