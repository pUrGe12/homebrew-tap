# homebrew-tap

Homebrew tap for [Macrohill](https://macrohill.com) tools.

## Install the CLI

```sh
brew install pUrGe12/tap/macrohill
```

(Equivalently: `brew tap pUrGe12/tap && brew install macrohill`.)

Then:

```sh
macrohill login
macrohill run config.yaml
```

## Notes

- `Formula/macrohill.rb` is **generated on release** by
  `packages/cli/scripts/update-formula.mjs` in the `prod` repo — don't edit it by
  hand; it points at the binaries attached to each GitHub release and pins their
  SHA-256.
- Supported platforms: macOS (arm64, x86_64) and Linux (x86_64, arm64).
