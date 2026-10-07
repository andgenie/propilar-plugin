# Propilar Agent Plugin

[Propilar](https://propilar.com) の不動産投資分析を、Claude Code・Codex・Antigravity CLI から使うためのプラグインです。

- **MCP サーバ**: `https://mcp.propilar.com/mcp`（収支・CF・DSCR・IRR の計算、ストレステスト、感度分析、シナリオ比較、物件の保存）
- **スキル**: `propilar-property-analysis`（入力の集め方、ツールの使い分け、判定の読み方と限界の伝え方）

初回にブラウザで Propilar にログインします（API キーは不要）。無料プランは分析が月30回まで、Standard 以上は無制限です。分析結果は入力に基づく参考情報で、投資助言ではありません。

## インストール

### Claude Code

```
/plugin marketplace add andgenie/propilar-agent-plugin
/plugin install propilar@propilar
```

インストール後、`/mcp` から `propilar` にログインします。シェルからは `claude plugin marketplace add andgenie/propilar-agent-plugin` → `claude plugin install propilar@propilar`。

### Codex

```
codex plugin marketplace add andgenie/propilar-agent-plugin
codex plugin add propilar@propilar
codex mcp login propilar
```

Codex CLI の `/plugins` からもインストールできます。

### Antigravity CLI

```
git clone https://github.com/andgenie/propilar-agent-plugin
agy plugin install ./propilar-agent-plugin
```

ログインは Settings → Customizations → Authenticate から行います。

### ChatGPT

ChatGPT のプラグインディレクトリへの掲載を準備中です。

### スキルだけ使う

```
npx skills add andgenie/propilar-agent-plugin
```

MCP サーバは別途設定が必要です（例: Claude Code なら `claude mcp add --transport http propilar https://mcp.propilar.com/mcp`）。

## 使い方の例

- 「4,000万円・家賃月30万円・借入3,600万円（金利2%・30年）の木造アパートを分析して」
- 「この物件、金利が1%上がったら収支はどうなる？」
- 「自己資金を1割・2割・3割入れた場合を比べて」
- 「自己資金と金利の組み合わせで、手残りがどう変わるか表で見せて」

## 構成

| ファイル | 使うクライアント |
|---------|----------------|
| `plugin.json` | Codex / ChatGPT（[Agent Plugins](https://agent-plugins.org) 1.0.0）、Antigravity |
| `mcp.json` | Codex、Claude Code（`.claude-plugin/plugin.json` から参照） |
| `mcp_config.json` | Antigravity（`serverUrl` 形式） |
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` | Claude Code |
| `.agents/plugins/marketplace.json` | Codex |
| `skills/propilar-property-analysis/` | 全クライアント共通（[Agent Skills](https://agentskills.io)） |

バージョンを上げるときは `plugin.json` と `.claude-plugin/plugin.json` の `version` を揃えてください。

## サポート

- お問い合わせ: https://propilar.com/contact
- プライバシーポリシー: https://propilar.com/privacy
- 利用規約: https://propilar.com/terms

---

## English

Propilar analyzes Japanese rental-property investments: cash flow, yields, DSCR, IRR, stress tests, sensitivity matrices and scenario comparisons, ending in a judgement (good / needs review / high risk). This repo packages the Propilar MCP server (`https://mcp.propilar.com/mcp`, OAuth sign-in, no API key) and an Agent Skill for Claude Code, Codex and Antigravity CLI. Free accounts get 30 analyses per month. Results are informational, not investment advice.

- Claude Code: `/plugin marketplace add andgenie/propilar-agent-plugin` then `/plugin install propilar@propilar`
- Codex: `codex plugin marketplace add andgenie/propilar-agent-plugin` then `codex plugin add propilar@propilar`
- Antigravity CLI: clone the repo, then `agy plugin install ./propilar-agent-plugin`

## License

MIT
