#!/usr/bin/env bash
# Builds the ZIP uploaded to the OpenAI Plugin directory (ChatGPT / Codex).
# Contents: plugin.json (Agent Plugins manifest with extensions.com.openai), mcp.json, assets/, skills/.
#
# The OpenAI portal requires the manifest `name` to match the plugin entry being updated.
# The entry created on 2026-10-07 uses `propilar` (same as the repository). The 2026-04 entry
# (`app-69de2852bc808191922703b14cd1ad94`, an unpublished MCP app) cannot take plugin ZIPs.
# Override with OPENAI_PLUGIN_NAME only if a different entry ever needs updating.
set -euo pipefail

OPENAI_PLUGIN_NAME="${OPENAI_PLUGIN_NAME:-propilar}"

cd "$(dirname "$0")/.."
node scripts/check-consistency.mjs

version=$(node -p 'require("./plugin.json").version')
out="$PWD/dist/propilar-plugin-${version}.zip"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

cp -R mcp.json assets skills "$stage/"
node -e '
  const fs = require("fs");
  const manifest = JSON.parse(fs.readFileSync("plugin.json", "utf-8"));
  manifest.name = process.argv[1];
  fs.writeFileSync(process.argv[2], JSON.stringify(manifest, null, 2) + "\n");
' "$OPENAI_PLUGIN_NAME" "$stage/plugin.json"

mkdir -p dist
rm -f "$out"
(cd "$stage" && zip -qr -X "$out" plugin.json mcp.json assets skills -x '*.DS_Store')
echo "Wrote $out (name: $OPENAI_PLUGIN_NAME)"
unzip -l "$out" | tail -3
