<div align="center">

# ⭐ SUPERSTAR TEAM

### One command. Five Opus agents. Zero bullshit.

**The most overpowered Claude Code setup you'll ever install.**

`/team` → describe your idea → watch 5 AI agents build it in parallel.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Opus_4.6-blueviolet)](https://claude.ai)
[![Agents](https://img.shields.io/badge/Agents-5_×_Opus-ff6600)](/)
[![Skills](https://img.shields.io/badge/Skills-24_auto--triggered-00cc66)](/)

</div>

---

## What is this

You type `/team`. You describe what you want in plain language. An Opus-powered architect designs the system. Then a backend engineer and frontend engineer start coding **simultaneously** in isolated git worktrees. When they're done, a test engineer writes full coverage. A security auditor scans for vulnerabilities. Code review, QA testing, design review, and health checks run automatically. A PR gets created. Documentation updates. Knowledge gets harvested for future sessions.

**You answer 1-2 questions. The team does the rest.**

---

## Install

```bash
git clone https://github.com/YOUR_USERNAME/superstar-team.git
cd superstar-team
./install.sh
```

That's it. One script installs everything.

---

## Usage

```bash
claude                    # Open Claude Code
/team                     # Launch the team
/team make me a SaaS      # Or just say what you want
/status                   # See what you've got
```

### What happens when you type `/team`

```
You: "/team I want an app that lets people rate burritos"

Team Lead: "Who is this for? MVP or production?"
You: "Public app, MVP first"

                    ┌─────────────────────┐
                    │  🏗️ Architect (Opus) │
                    │  Picks tech stack    │
                    │  Designs architecture│
                    └─────────┬───────────┘
                              │ You say OK
                    ┌─────────┴───────────┐
              ┌─────┴─────┐         ┌─────┴─────┐
              │ 🔧 Backend│         │ 🎨 Frontend│
              │   (Opus)  │         │   (Opus)   │
              │ Worktree A│         │ Worktree B │
              └─────┬─────┘         └─────┬─────┘
                    └─────────┬───────────┘
                              │ Auto-merge
                    ┌─────────┴───────────┐
                    │   🧪 Tester (Opus)  │
                    └─────────┬───────────┘
                    ┌─────────┴───────────┐
                    │   🔒 Security (Opus)│
                    └─────────┬───────────┘
                    ┌─────────┴───────────┐
                    │  ⚡ Quality Gates    │
                    │  /review → /cso     │
                    │  /qa → /design      │
                    │  /health            │
                    └─────────┬───────────┘
                    ┌─────────┴───────────┐
                    │  🚀 Ship & Document │
                    └─────────┬───────────┘
                    ┌─────────┴───────────┐
                    │  🧠 Knowledge Saved │
                    └─────────────────────┘
```

---

## What's inside

### 5 Agents (all Opus)

| Agent | Role | What it does |
|-------|------|-------------|
| **Architect** | System design | Picks tech stack, designs architecture, defines API contracts, assigns file ownership |
| **Backend** | Implementation | API routes, database schema, business logic, middleware |
| **Frontend** | Implementation | UI components, routing, state management, API integration |
| **Tester** | Quality | Unit tests, integration tests, edge cases, coverage reports |
| **Security** | Audit | Injection scanning, auth review, secrets detection, dependency audit |

### 24 Auto-triggered Skills

You don't call these. They activate when relevant.

| Source | Stars | Skills |
|--------|-------|--------|
| [obra/superpowers](https://github.com/obra/superpowers) | 134K | Git worktree management, branch completion, pre-completion verification, parallel agent dispatch |
| [PlanetScale](https://github.com/planetscale/database-skills) | 387 | MySQL/PostgreSQL schema design, query optimization, EXPLAIN ANALYZE |
| [Addy Osmani](https://github.com/addyosmani/web-quality-skills) | 1.5K | Performance (50+ patterns), Core Web Vitals, WCAG 2.2 accessibility, SEO, best practices |
| [Trail of Bits](https://github.com/trailofbits/skills) | 4.3K | Supply chain audit, differential review, insecure defaults, multi-model cross-validation |
| [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin) | 12.8K | Learning loops — compound knowledge across sessions |
| [Excalidraw](https://github.com/coleam00/excalidraw-diagram-skill) | 1.8K | Architecture diagrams from natural language |
| [Vercel](https://github.com/vercel-labs/agent-skills) | 24.4K | 100+ UI audit rules: a11y, i18n, touch, dark mode, animation |

### 7-Phase Pipeline

| Phase | What | Automatic? |
|-------|------|-----------|
| 1. Listen | You describe what you want | You talk |
| 1.5. Knowledge | Reads past decisions to avoid repeat mistakes | ✅ |
| 2. Architecture | Opus architect designs everything, recommends tech stack | ✅ (you confirm) |
| 3. Build | Backend + Frontend in parallel worktrees | ✅ |
| 4. Integrate | Merge worktrees, resolve conflicts | ✅ |
| 5. Quality | Code review → Security → QA → Design → Health | ✅ |
| 6. Ship | Create PR, update docs | ✅ |
| 7. Harvest | Save decisions, patterns, training data | ✅ |

### Built-in Guardrails

| Protection | What it prevents |
|-----------|-----------------|
| Three strikes | Same error 3 times → agent stops, reports back |
| File limit | Modifying 10+ files → must report first |
| Package limit | Installing 5+ packages → must report first |
| No delete | Cannot delete existing files unless explicitly required |
| Progressive launch | Lead checks each phase before starting the next |
| Auto-compact | Context compression between phases |
| Output filtering | Test/build output trimmed to save tokens |

### Knowledge Accumulation

Every session automatically saves:
- **Architecture decisions** → `~/.claude/knowledge/YYYY-MM-DD-{topic}.md`
- **Solution patterns** → `~/.claude/knowledge/patterns/{problem}.md`
- **Training data** → `~/.claude/knowledge/training/{topic}.jsonl`

Training data format (for future fine-tuning):
```json
{"instruction": "...", "input": "...", "output": "...", "tags": [], "quality": "high|medium|low"}
```

---

## Commands

| Command | What |
|---------|------|
| `/team` | Launch the full team pipeline |
| `/duo` | Lightweight 2-agent mode: Opus plans, Opus executes |
| `/status` | Show all installed assets and knowledge stats |

---

## Requirements

- **Claude Code CLI** (`npm install -g @anthropic-ai/claude-code`)
- **Claude Max plan** (recommended — 5 Opus agents burn tokens)
- **git**
- **jq** (for hooks)

---

## FAQ

**How much does it cost?**
Each `/team` run uses ~5x the tokens of a single session. A medium feature costs roughly $5-15 in API credits. Max plan ($200/mo) handles 2-3 days of intensive full-team work.

**Can I use Sonnet instead of Opus?**
Yes. Edit `~/.claude/agents/*.md` and change `model: opus` to `model: sonnet`. Saves ~40% but reduces reasoning quality.

**Does it work with existing codebases?**
Yes. The architect reads your codebase first and designs around it. It won't nuke your existing code.

**What if an agent gets stuck?**
Three-strike rule kicks in. After 3 failed attempts at the same thing, the agent stops and reports back to the Lead. No infinite loops.

**Where does the knowledge go?**
`~/.claude/knowledge/`. It stays on your machine, travels with your Claude config, and gets read automatically on the next `/team` run.

---

<div align="center">

**Built for people who ship.**

</div>
