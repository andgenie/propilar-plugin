#!/usr/bin/env bash
# Builds the ZIP uploaded to the OpenAI Plugin directory (ChatGPT / Codex).
# Contents: plugin.json (Agent Plugins manifest with extensions.com.openai), mcp.json, assets/, skills/.
set -euo pipefail

cd "$(dirname "$0")/.."
node scripts/check-consistency.mjs

version=$(node -p 'require("./plugin.json").version')
out="dist/propilar-plugin-${version}.zip"
mkdir -p dist
rm -f "$out"
zip -qr -X "$out" plugin.json mcp.json assets skills -x '*.DS_Store'
echo "Wrote $out"
unzip -l "$out"
