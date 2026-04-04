# /status — 超星團隊狀態總覽

一次列出所有東西在哪、有多少、怎麼用。

## 執行以下檢查並回報：

```bash
# 知識庫
echo "=== 知識庫 ==="
echo "位置：~/.claude/knowledge/"
ls ~/.claude/knowledge/*.md 2>/dev/null | wc -l | xargs echo "知識文件："
ls ~/.claude/knowledge/patterns/*.md 2>/dev/null | wc -l | xargs echo "解法模式："
cat ~/.claude/knowledge/training/*.jsonl 2>/dev/null | wc -l | xargs echo "訓練資料（條）："
ls ~/.claude/knowledge/archive/*.md 2>/dev/null | wc -l | xargs echo "已歸檔："

# Agents
echo ""
echo "=== Agents ==="
echo "位置：~/.claude/agents/"
for f in ~/.claude/agents/*.md; do
  name=$(basename "$f" .md)
  model=$(grep -m1 'model:' "$f" 2>/dev/null | awk '{print $2}')
  echo "  $name ($model)"
done

# Skills
echo ""
echo "=== Skills ==="
echo "位置：~/.claude/skills/"
find ~/.claude/skills -maxdepth 1 -mindepth 1 \( -type d -o -type l \) 2>/dev/null | wc -l | xargs echo "數量："

# Commands
echo ""
echo "=== Commands ==="
echo "位置：~/.claude/commands/"
ls ~/.claude/commands/*.md 2>/dev/null | xargs -I{} basename {} .md | sed 's/^/\//'
```

## 用以下格式回報：

```
📂 超星團隊狀態

🧠 知識庫（~/.claude/knowledge/）
   知識文件：XX 份
   解法模式：XX 份
   訓練資料：XX 條
   已歸檔：XX 份

🤖 Agents（~/.claude/agents/）
   [列出所有 agent 名稱和 model]

⚡ Skills（~/.claude/skills/）
   XX 個已安裝

🎯 可用指令
   /team    — 開團隊做東西
   /duo     — 輕量雙人模式
   /status  — 就是這個
```
