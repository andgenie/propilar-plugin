// Keeps the per-client manifests in sync: same plugin name, version and MCP URL everywhere.
import { readFileSync } from "node:fs";

const read = (path) => JSON.parse(readFileSync(path, "utf-8"));
const portable = read("plugin.json");
const claude = read(".claude-plugin/plugin.json");
const mcp = read("mcp.json").mcpServers.propilar;
const antigravity = read("mcp_config.json").mcpServers.propilar;

const errors = [];
if (portable.name !== claude.name) errors.push(`name: plugin.json=${portable.name} .claude-plugin=${claude.name}`);
if (portable.version !== claude.version) errors.push(`version: plugin.json=${portable.version} .claude-plugin=${claude.version}`);
if (mcp.url !== antigravity.serverUrl) errors.push(`MCP URL: mcp.json=${mcp.url} mcp_config.json=${antigravity.serverUrl}`);

const ui = portable.extensions?.["com.openai"]?.interface ?? {};
if ((ui.displayName ?? "").length > 30) errors.push("interface.displayName exceeds 30 characters");
if ((ui.shortDescription ?? "").length > 30) errors.push("interface.shortDescription exceeds 30 characters");
for (const prompt of ui.defaultPrompt ?? []) {
  if (prompt.length > 128) errors.push(`defaultPrompt exceeds 128 characters: ${prompt}`);
}

if (errors.length) {
  console.error(errors.join("\n"));
  process.exit(1);
}
console.log("manifests are consistent");
