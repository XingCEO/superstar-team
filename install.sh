#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  Superstar Team — One-Click Install      ║
# ║  Opus Architect + 4 Agent Auto Pipeline  ║
# ╚══════════════════════════════════════════╝

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(cat "$SCRIPT_DIR/VERSION")
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "⭐ Superstar Team Installer v${VERSION}"
echo "════════════════════"
echo ""

# Check Claude Code
if ! command -v claude &> /dev/null; then
  echo -e "${RED}❌ Claude Code CLI not found. Install it first:${NC}"
  echo "   npm install -g @anthropic-ai/claude-code"
  exit 1
fi

echo -e "${GREEN}✓${NC} Claude Code installed"

# Check gstack (optional but strongly recommended)
# After installation, the gstack skill directory may be gstack/ or xtools/ (gstack's internal skill subdirectory)
if [ -d "$CLAUDE_DIR/skills/gstack" ] || [ -d "$CLAUDE_DIR/skills/xtools" ]; then
  echo -e "${GREEN}✓${NC} gstack installed (design/QA/delivery skills available)"
else
  echo -e "${YELLOW}⚠${NC}  gstack not installed"
  echo ""
  echo "  Superstar Team's core orchestration (agents + worktree + API contracts) works standalone."
  echo "  However, the following features require gstack:"
  echo "    - Phase 2 design pipeline (design-consultation, design-shotgun)"
  echo "    - Phase 4.5 design verification (design-review)"
  echo "    - Phase 6 quality gates (review, cso, qa, codex, health, benchmark)"
  echo "    - Phase 7 delivery (ship, document-release, canary)"
  echo ""
  echo "  Without gstack, these steps are automatically skipped without affecting the core dev workflow."
  echo ""
  echo "  Install gstack (recommended):"
  echo "    git clone https://github.com/garrytan/gstack.git ~/.claude/skills/gstack"
  echo "    cd ~/.claude/skills/gstack && ./setup"
  echo ""
  if [ -t 0 ]; then
    # Interactive terminal — ask user
    read -r -p "  Continue installing Superstar Team? (Y/n) " answer
    if [[ "$answer" =~ ^[Nn] ]]; then
      echo "Cancelled. Install gstack first, then re-run install.sh."
      exit 0
    fi
  else
    # Non-interactive (CI, pipe) — continue silently
    echo -e "  ${YELLOW}⚠${NC}  Non-interactive mode, continuing installation automatically"
  fi
fi

# Plan & model selection (interactive only)
if [ -t 0 ]; then
  echo ""
  echo "════════════════════════════════════"
  echo "  Model Configuration"
  echo "════════════════════════════════════"
  echo ""
  echo "  What are you mainly building?"
  echo ""
  echo "  1) Production apps — quality matters most           → opus"
  echo "  2) Side projects / prototypes — speed & cost        → sonnet"
  echo "  3) Simple scripts / quick fixes — fast & cheap      → haiku"
  echo ""
  read -r -p "  Choose [1/2/3] (default: 1): " model_choice
  case "$model_choice" in
    2) SELECTED_MODEL="sonnet" ;;
    3) SELECTED_MODEL="haiku" ;;
    *) SELECTED_MODEL="opus" ;;
  esac
  echo ""
  echo -e "  ${GREEN}✓${NC} Model set to: $SELECTED_MODEL"
else
  # Non-interactive — default to opus
  SELECTED_MODEL="opus"
fi

# Create directories
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/knowledge/patterns"
mkdir -p "$CLAUDE_DIR/knowledge/training"

# Save model preference (after directories exist)
echo "$SELECTED_MODEL" > "$CLAUDE_DIR/.superstar-model"

echo -e "${GREEN}✓${NC} Directories created"

# ═══════════════════════════════════
# Record repo location (used by update.sh)
# ═══════════════════════════════════

echo "$SCRIPT_DIR" > "$CLAUDE_DIR/.superstar-repo-path"

# ═══════════════════════════════════
# Agents (symlink to repo, updates via git pull)
# ═══════════════════════════════════

for agent in architect backend frontend tester security; do
  # If an old non-symlink file exists, back it up before replacing
  target="$CLAUDE_DIR/agents/$agent.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.bak"
    echo -e "  ${YELLOW}⚠${NC}  Backed up old $agent.md → $agent.md.bak"
  fi
  ln -sf "$SCRIPT_DIR/agents/$agent.md" "$target"
done

echo -e "${GREEN}✓${NC} 5 Agents installed (all Opus, symlink mode)"

# ═══════════════════════════════════
# Commands (symlink to repo, updates via git pull)
# ═══════════════════════════════════

for cmd in team duo status; do
  target="$CLAUDE_DIR/commands/$cmd.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.bak"
    echo -e "  ${YELLOW}⚠${NC}  Backed up old $cmd.md → $cmd.md.bak"
  fi
  ln -sf "$SCRIPT_DIR/commands/$cmd.md" "$target"
done

echo -e "${GREEN}✓${NC} 3 Commands installed (/team /duo /status, symlink mode)"

# ═══════════════════════════════════
# Skills (clone from GitHub)
# ═══════════════════════════════════

echo ""
echo -e "${YELLOW}Installing Skills...${NC}"

clone_skill() {
  local repo=$1
  local dir=$2
  local pin=$3  # commit hash to pin (optional)
  if [ ! -d "$CLAUDE_DIR/skills/$dir" ]; then
    git clone --depth 50 "https://github.com/$repo.git" "$CLAUDE_DIR/skills/$dir"
    if [ -n "$pin" ]; then
      (cd "$CLAUDE_DIR/skills/$dir" && git checkout "$pin" --quiet 2>/dev/null)
    fi
    echo -e "  ${GREEN}✓${NC} $repo${pin:+ @ ${pin:0:7}}"
  else
    echo -e "  ⏭️  $dir (already exists)"
  fi
}

# ═══════════════════════════════════
# Skill version pinning (last verified: 2026-04-05)
# To update: change hash and re-run install.sh (delete ~/.claude/skills/<dir> first)
# ═══════════════════════════════════

# obra — Git workflow
clone_skill "obra/superpowers" "obra-superpowers" "b7a8f76"
for s in using-git-worktrees finishing-a-development-branch verification-before-completion dispatching-parallel-agents; do
  ln -sf "$CLAUDE_DIR/skills/obra-superpowers/skills/$s" "$CLAUDE_DIR/skills/$s" 2>/dev/null
done

# PlanetScale — Database
clone_skill "planetscale/database-skills" "planetscale-db" "b156f4c"
for s in mysql postgres; do
  ln -sf "$CLAUDE_DIR/skills/planetscale-db/skills/$s" "$CLAUDE_DIR/skills/planetscale-$s" 2>/dev/null
done

# Addy Osmani — Web quality
clone_skill "addyosmani/web-quality-skills" "addy-web-quality" "fed9617"
for s in accessibility best-practices core-web-vitals performance seo web-quality-audit; do
  ln -sf "$CLAUDE_DIR/skills/addy-web-quality/skills/$s" "$CLAUDE_DIR/skills/addy-$s" 2>/dev/null
done

# Trail of Bits — Security
clone_skill "trailofbits/skills" "trailofbits-security" "d7f76b5"
for s in supply-chain-risk-auditor differential-review insecure-defaults modern-python second-opinion; do
  ln -sf "$CLAUDE_DIR/skills/trailofbits-security/plugins/$s/skills/$s" "$CLAUDE_DIR/skills/tob-$s" 2>/dev/null
done

# Compound Engineering — Learning loop
clone_skill "EveryInc/compound-engineering-plugin" "compound-engineering" "b223e39"
for s in ce-compound ce-ideate ce-plan ce-review ce-work; do
  ln -sf "$CLAUDE_DIR/skills/compound-engineering/plugins/compound-engineering/skills/$s" "$CLAUDE_DIR/skills/$s" 2>/dev/null
done

# Excalidraw — Architecture diagrams
clone_skill "coleam00/excalidraw-diagram-skill" "excalidraw-diagram" "8646fcc"

# Vercel — UI audit
clone_skill "vercel-labs/agent-skills" "vercel-skills" "73140fc"
ln -sf "$CLAUDE_DIR/skills/vercel-skills/skills/web-design-guidelines" "$CLAUDE_DIR/skills/vercel-web-design" 2>/dev/null

echo -e "${GREEN}✓${NC} Skills installed"

# ═══════════════════════════════════
# Hooks
# ═══════════════════════════════════

cat > "$CLAUDE_DIR/hooks/filter-output.sh" << 'HOOK'
#!/bin/bash
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null)
if [ -z "$cmd" ] || [ "$cmd" = "null" ]; then
  echo '{}'
  exit 0
fi
if [[ "$cmd" =~ ^(npm\ test|npx\ jest|pytest|python\ -m\ pytest|go\ test|cargo\ test|bun\ test|vitest|mocha) ]]; then
  filtered_cmd="$cmd 2>&1 | tail -50"
  jq -n --arg cmd "$filtered_cmd" '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":$cmd}}}'
elif [[ "$cmd" =~ ^(npm\ run\ build|npx\ tsc|cargo\ build|go\ build|make) ]]; then
  filtered_cmd="$cmd 2>&1 | grep -A 3 -E '(error|Error|ERROR|FAIL|failed)' | head -50"
  jq -n --arg cmd "$filtered_cmd" '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":$cmd}}}'
else
  echo '{}'
fi
HOOK
chmod +x "$CLAUDE_DIR/hooks/filter-output.sh"

# Guardrail hook — programmatic file + package enforcement
cat > "$CLAUDE_DIR/hooks/guardrail.sh" << 'HOOK'
#!/bin/bash
# PreToolUse hook: hard-block file writes beyond 20, package installs beyond 10
input=$(cat)
tool=$(echo "$input" | jq -r '.tool_name' 2>/dev/null)
# Session ID: extract from hook's stdin JSON (most reliable),
# fallback to grandparent PID if JSON doesn't have it
SESSION_ID=$(echo "$input" | jq -r '.session_id // empty' 2>/dev/null)
if [ -z "$SESSION_ID" ]; then
  SESSION_ID=$(ps -o ppid= -p "${PPID:-$$}" 2>/dev/null | tr -d ' ')
  [ -z "$SESSION_ID" ] && SESSION_ID="${PPID:-$$}"
fi

# --- File count guardrail (Write/Edit) ---
if [ "$tool" = "Write" ] || [ "$tool" = "Edit" ]; then
  COUNTER="/tmp/superstar-file-${SESSION_ID}"
  count=0
  [ -f "$COUNTER" ] && count=$(cat "$COUNTER")
  count=$((count + 1))
  echo "$count" > "$COUNTER"

  if [ "$count" -gt 20 ]; then
    jq -n '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","reason":"BLOCKED: 20-file limit reached. Stop and report to Lead."}}'
    exit 0
  elif [ "$count" -ge 16 ]; then
    jq -n --arg msg "WARNING: $count/20 files modified. Approaching hard limit." \
      '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","message":$msg}}'
    exit 0
  fi
fi

# --- Package install guardrail (Bash) ---
if [ "$tool" = "Bash" ]; then
  cmd=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null)
  if echo "$cmd" | grep -qE '^(npm install|npm i |yarn add|pnpm add|pip install|pip3 install|cargo add|bun add)'; then
    COUNTER="/tmp/superstar-pkg-${SESSION_ID}"
    count=0
    [ -f "$COUNTER" ] && count=$(cat "$COUNTER")
    count=$((count + 1))
    echo "$count" > "$COUNTER"

    if [ "$count" -gt 10 ]; then
      jq -n '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","reason":"BLOCKED: 10-package limit reached. Stop and report to Lead."}}'
      exit 0
    elif [ "$count" -ge 8 ]; then
      jq -n --arg msg "WARNING: $count/10 packages installed. Approaching hard limit." \
        '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","message":$msg}}'
      exit 0
    fi
  fi
fi

echo '{}'
HOOK
chmod +x "$CLAUDE_DIR/hooks/guardrail.sh"

echo -e "${GREEN}✓${NC} Hooks installed (output filter + guardrail)"

# ═══════════════════════════════════
# Settings (do not overwrite existing)
# ═══════════════════════════════════

# settings.json — model "opus[1m]" = Opus with 1M context window (Claude Code shorthand)
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS'
{
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "70"
  },
  "model": "opus[1m]",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/filter-output.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/guardrail.sh"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/guardrail.sh"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/guardrail.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS
  echo -e "${GREEN}✓${NC} settings.json created"
else
  echo -e "${YELLOW}⏭️${NC}  settings.json already exists, skipping (no overwrite)"
  echo -e "  ${YELLOW}⚠${NC}  Please manually verify hooks config includes guardrail.sh and filter-output.sh"
  echo -e "  ${YELLOW}⚠${NC}  Reference: settings.json example in install.sh"
fi

# ═══════════════════════════════════
# Version record
# ═══════════════════════════════════

echo "$VERSION" > "$CLAUDE_DIR/.superstar-version"

# ═══════════════════════════════════
# Done
# ═══════════════════════════════════

SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -mindepth 1 \( -type d -o -type l \) 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "════════════════════════════════════"
echo -e "  ${GREEN}⭐ Superstar Team installed v${VERSION}${NC}"
echo "════════════════════════════════════"
echo ""
echo "  🤖 Agents:   5 (all Opus)"
echo "  ⚡ Skills:   $SKILL_COUNT"
echo "  🎯 Commands: /team  /duo  /status"
echo "  🔧 Hooks:    Test output filter (saves tokens)"
echo "  🧠 Knowledge: ~/.claude/knowledge/"
echo "  🔗 Mode:     symlink (updates via git pull)"
echo ""
echo "  Getting started:"
echo "    claude                 # Launch Claude Code"
echo "    /team                  # Start Superstar Team"
echo "    /status                # Check status"
echo ""
echo "  Update:"
echo "    cd $(basename "$SCRIPT_DIR") && git pull"
echo "    # or"
echo "    ./update.sh"
echo ""
