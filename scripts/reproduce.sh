#!/usr/bin/env bash
set -euo pipefail

root="$(mktemp -d)"
trap 'rm -rf "$root"' EXIT

npm pack --silent --pack-destination "$root" >/dev/null
npm install \
  --prefix "$root/install-root" \
  --ignore-scripts \
  --legacy-peer-deps \
  "$root"/*.tgz >/dev/null

extension="$root/install-root/node_modules/pi-extension-peer-dependency-repro/extensions/index.js"
if output="$(node --input-type=module -e 'import(process.argv[1])' "$extension" 2>&1)"; then
  echo "Expected TypeBox resolution to fail, but the extension imported successfully." >&2
  exit 1
fi

if ! grep -q "Cannot find package 'typebox'" <<<"$output"; then
  printf '%s\n' "$output" >&2
  exit 1
fi

printf '%s\n' "Reproduced: Pi-managed npm installs omit the TypeBox peer dependency."
printf '%s\n' "$output" | grep -A1 -B1 "Cannot find package 'typebox'"
