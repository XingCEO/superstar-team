# /status — Superstar Team Status Overview

Lists everything: where it is, how much there is, and how to use it. Also checks for new versions.

## Run the following checks and report:

```bash
# Version
echo "=== Version ==="
LOCAL_VER="unknown"
if [ -f ~/.claude/.superstar-version ]; then
  LOCAL_VER=$(cat ~/.claude/.superstar-version)
fi
echo "Local version: $LOCAL_VER"

REPO_PATH=""
if [ -f ~/.claude/.superstar-repo-path ]; then
  REPO_PATH=$(cat ~/.claude/.superstar-repo-path)
fi

REMOTE_VER="unable to check"
UPDATE_AVAILABLE="false"
if [ -n "$REPO_PATH" ] && [ -d "$REPO_PATH/.git" ]; then
  cd "$REPO_PATH"
  git fetch origin main --quiet 2>/dev/null
  REMOTE_VER=$(git show origin/main:VERSION 2>/dev/null || echo "unable to fetch")
  if [ "$REMOTE_VER" != "$LOCAL_VER" ] && [ "$REMOTE_VER" != "unable to fetch" ]; then
    UPDATE_AVAILABLE="true"
    echo "Latest version: $REMOTE_VER ← update available!"
  else
    echo "Latest version: $REMOTE_VER (up to date)"
  fi
  cd - > /dev/null
else
  echo "Latest version: $REMOTE_VER (repo not found)"
fi

# Install mode
echo ""
echo "=== Install Mode ==="
if [ -L ~/.claude/agents/architect.md ]; then
  echo "Mode: symlink (auto-updates via git pull)"
else
  echo "Mode: copy (run update.sh to update)"
fi

# Knowledge base
echo ""
echo "=== Knowledge Base ==="
echo "Location: ~/.claude/knowledge/"
ls ~/.claude/knowledge/*.md 2>/dev/null | wc -l | xargs echo "Knowledge docs:"
ls ~/.claude/knowledge/patterns/*.md 2>/dev/null | wc -l | xargs echo "Solution patterns:"
cat ~/.claude/knowledge/training/*.jsonl 2>/dev/null | wc -l | xargs echo "Training entries:"
ls ~/.claude/knowledge/archive/*.md 2>/dev/null | wc -l | xargs echo "Archived:"

# Agents
echo ""
echo "=== Agents ==="
echo "Location: ~/.claude/agents/"
for f in ~/.claude/agents/*.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f" .md)
  model=$(grep -m1 'model:' "$f" 2>/dev/null | awk '{print $2}')
  echo "  $name ($model)"
done

# Skills
echo ""
echo "=== Skills ==="
echo "Location: ~/.claude/skills/"
find ~/.claude/skills -maxdepth 1 -mindepth 1 \( -type d -o -type l \) 2>/dev/null | wc -l | xargs echo "Count:"

# Commands
echo ""
echo "=== Commands ==="
echo "Location: ~/.claude/commands/"
ls ~/.claude/commands/*.md 2>/dev/null | xargs -I{} basename {} .md | sed 's/^/\//'
```

## Report using the following format:

```
📂 Superstar Team Status vX.X.X

🔄 Update Status
   Local:  vX.X.X
   Latest: vX.X.X
   [If update available: ⚠️ New version available! Run `cd {repo_path} && ./update.sh` to update]
   [If up to date: ✅ Already on latest version]
   Mode: symlink / copy

🧠 Knowledge Base (~/.claude/knowledge/)
   Knowledge docs:     XX
   Solution patterns:  XX
   Training entries:   XX
   Archived:           XX

🤖 Agents (~/.claude/agents/)
   [List all agent names and models]

⚡ Skills (~/.claude/skills/)
   XX installed

🎯 Available Commands
   /team    — Launch the team for development
   /duo     — Lightweight duo mode
   /status  — This command
```
