# /status — Superstar Team Status Overview

Check the following and report a clean summary. Use Read, Glob, Bash tools as needed — do not ask the user.

## What to check

1. **Version** — Read `~/.claude/.superstar-version` (if exists)
2. **Install mode** — Check if `~/.claude/agents/architect.md` is a symlink or a regular file
3. **Agents** — List all `.md` files in `~/.claude/agents/`, show name and `model:` field from frontmatter
4. **Skills** — Count directories and symlinks in `~/.claude/skills/` (depth 1)
5. **Commands** — List all `.md` files in `~/.claude/commands/`, show as `/name`
6. **Knowledge base** — Count `.md` files in `~/.claude/knowledge/`, `patterns/`, `archive/`, and lines in `training/*.jsonl`

## Report format

```
Superstar Team Status vX.X.X

Update Status
   Local:  vX.X.X
   Mode: symlink / copy

Knowledge Base (~/.claude/knowledge/)
   Knowledge docs:     XX
   Solution patterns:  XX
   Training entries:   XX
   Archived:           XX

Agents (~/.claude/agents/)
   [name (model)] per line

Skills (~/.claude/skills/)
   XX installed

Available Commands
   /team    — Launch the team
   /duo     — Lightweight duo mode
   /status  — This command
```
