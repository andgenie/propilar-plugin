#!/usr/bin/env bash
# Builds the ZIP uploaded to the OpenAI Plugin directory (ChatGPT / Codex).
# Contents: plugin.json (Agent Plugins manifest with extensions.com.openai), mcp.json, assets/, skills/.
#
# The OpenAI portal requires the manifest `name` to match the existing plugin entry
# (created by the first submission in 2026-04), so the name is rewritten in the ZIP only.
# The repository keeps `propilar` so Claude Code / Codex / Antigravity install IDs stay `propilar@propilar`.
set -euo pipefail

OPENAI_PLUGIN_NAME="${OPENAI_PLUGIN_NAME:-app-69de2852bc808191922703b14cd1ad94}"

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
