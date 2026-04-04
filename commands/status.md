# /status — 超星團隊狀態總覽

一次列出所有東西在哪、有多少、怎麼用。也會檢查有沒有新版。

## 執行以下檢查並回報：

```bash
# 版本
echo "=== 版本 ==="
LOCAL_VER="未知"
if [ -f ~/.claude/.superstar-version ]; then
  LOCAL_VER=$(cat ~/.claude/.superstar-version)
fi
echo "本地版本：$LOCAL_VER"

REPO_PATH=""
if [ -f ~/.claude/.superstar-repo-path ]; then
  REPO_PATH=$(cat ~/.claude/.superstar-repo-path)
fi

REMOTE_VER="無法檢查"
UPDATE_AVAILABLE="false"
if [ -n "$REPO_PATH" ] && [ -d "$REPO_PATH/.git" ]; then
  cd "$REPO_PATH"
  git fetch origin main --quiet 2>/dev/null
  REMOTE_VER=$(git show origin/main:VERSION 2>/dev/null || echo "無法取得")
  if [ "$REMOTE_VER" != "$LOCAL_VER" ] && [ "$REMOTE_VER" != "無法取得" ]; then
    UPDATE_AVAILABLE="true"
    echo "最新版本：$REMOTE_VER ← 有更新！"
  else
    echo "最新版本：$REMOTE_VER（已是最新）"
  fi
  cd - > /dev/null
else
  echo "最新版本：$REMOTE_VER（找不到 repo）"
fi

# 安裝模式
echo ""
echo "=== 安裝模式 ==="
if [ -L ~/.claude/agents/architect.md ]; then
  echo "模式：symlink（git pull 自動更新）"
else
  echo "模式：複製（需跑 update.sh 更新）"
fi

# 知識庫
echo ""
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
  [ -f "$f" ] || continue
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
📂 超星團隊狀態 vX.X.X

🔄 更新狀態
   本地：vX.X.X
   最新：vX.X.X
   [如果有更新，顯示：⚠️ 有新版！跑 `cd {repo路徑} && ./update.sh` 更新]
   [如果已最新，顯示：✅ 已是最新版本]
   模式：symlink / 複製

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
