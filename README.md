# homebrew-mado

Homebrew Cask tap for [mado](https://github.com/hummer98/mado) — a CLI-first Markdown viewer for macOS.

## Install

```bash
brew install --cask hummer98/mado/mado
```

This will install:
- `mado.app` into `/Applications` (or your configured `appdir`)
- `mado` CLI shim into `$(brew --prefix)/bin`

## Usage

```bash
mado                 # open welcome window
mado README.md       # open a file (relative path resolved against cwd)
mado /abs/path.md    # open a file by absolute path
```

## Uninstall

```bash
brew uninstall --cask mado
brew untap hummer98/mado
```

## Requirements

- macOS on Apple Silicon (arm64)
- Homebrew

## Notes

mado is currently unsigned. If macOS Gatekeeper blocks the first launch:

```bash
xattr -dr com.apple.quarantine /Applications/mado.app
```

## License

MIT
