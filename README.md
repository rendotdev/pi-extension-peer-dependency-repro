# Pi extension peer-dependency reproduction

This repository demonstrates a mismatch between Pi's package documentation and its managed npm installation.

Pi 0.80.10 documents `typebox` as a core package that extensions should declare as a `peerDependency`, not bundle. This package follows that guidance. Its extension imports `typebox` to define a minimal tool schema.

Pi's managed npm installer deliberately passes `--legacy-peer-deps`, so npm does not install the peer dependency. Because Pi's own `typebox` module is outside the package's module root, importing the extension fails with `ERR_MODULE_NOT_FOUND`.

## Reproduce

Requirements: Node 22 and npm.

```bash
git clone https://github.com/rendotdev/pi-extension-peer-dependency-repro.git
cd pi-extension-peer-dependency-repro
./scripts/reproduce.sh
```

Expected output includes:

```text
Cannot find package 'typebox'
```

The script packs this package, installs it using the same dependency flags Pi uses for managed npm packages, then imports its extension.

## Expected behavior

A Pi package that follows the documented `peerDependencies` guidance for `typebox` should load successfully, or the documentation should require distributed npm packages to declare `typebox` in `dependencies`.

## Workaround

Declare `typebox` as a direct production dependency. [LGTM v0.1.29](https://github.com/rendotdev/lgtm/releases/tag/v0.1.29) uses that workaround.

## Related Pi behavior

The relevant 0.80.10 code is [`getManagedInstallArgs()`](https://github.com/earendil-works/pi/blob/v0.80.10/packages/coding-agent/src/core/package-manager.ts), which appends `--legacy-peer-deps` for npm managed installs.
