<div align="center">

# ⭐ SUPERSTAR TEAM

### 一個指令，五個 Opus，全自動交付

**給 Claude Code 用的全棧 AI 開發團隊。**

打 `/team`，說你想做什麼，五個 Opus agent 同時幫你寫。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Opus_4.6-blueviolet)](https://claude.ai)
[![Agents](https://img.shields.io/badge/Agents-5_×_Opus-ff6600)](/)
[![Skills](https://img.shields.io/badge/Skills-24-00cc66)](/)

</div>

---

## 這是什麼

一套 Claude Code 的設定檔，裝完之後你打 `/team`，它會：

1. 問你想做什麼（用白話講就好，不用懂技術）
2. 自動選技術棧、設計架構，讓你確認
3. 開兩個 Opus agent 在獨立的 git worktree 裡同時寫前後端
4. 寫完自動跑測試、安全掃描、程式碼審查、QA
5. 開 PR、更新文件
6. 把這次學到的東西存起來，下次不用重來

你只要說想做什麼、看一眼架構說 OK，剩下全自動。

---

## 安裝

```bash
git clone https://github.com/XingCEO/superstar-team.git
cd superstar-team
./install.sh
```

---

## 怎麼用

```bash
claude                              # 打開 Claude Code
/team                               # 啟動團隊
/team 做一個讓人評價小吃的 app        # 或是直接講
/status                             # 看裝了什麼、有沒有新版
```

## 更新

安裝後 agents 和 commands 會 symlink 回這個 repo，所以：

```bash
cd superstar-team && git pull       # 大部分情況這樣就夠了
```

如果你是舊版安裝的（v1.0.x，用複製模式），跑一次升級：

```bash
cd superstar-team && ./update.sh    # 自動升級為 symlink 模式 + 更新 skills
```

`/status` 會自動告訴你有沒有新版。

---

## 流程

```
你：「做一個讓人評價小吃的 app」

        ╔═══════════════════════════╗
        ║   🏗️  架構師 (Opus)       ║
        ║   選技術棧，設計架構       ║
        ╚═══════════╤═══════════════╝
                    │ 你確認
        ┌───────────┴───────────┐
        ▼                       ▼
╔═══════════════╗       ╔═══════════════╗
║  🔧 後端 Opus  ║       ║  🎨 前端 Opus  ║
║  Worktree A   ║       ║  Worktree B   ║
╚═══════╤═══════╝       ╚═══════╤═══════╝
        └───────────┬───────────┘
                    ▼
        ╔═══════════════════════════╗
        ║       🔀 自動合併         ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║       🧪 測試 (Opus)      ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║       🔒 安全審查 (Opus)   ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║       ⚡ 品質閘門         ║
        ║  審查 → 安全 → QA → 設計  ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║    🚀 開 PR，更新文件      ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║    🧠 存下這次的經驗       ║
        ╚═══════════════════════════╝
```

---

## 裝了什麼

### 5 個 Agent

全部跑 Opus，各自有明確的職責範圍和檔案邊界，不會互相踩。

| Agent | 做什麼 |
|-------|--------|
| 架構師 | 選技術棧、畫架構、定 API、分工 |
| 後端 | API、資料庫、業務邏輯 |
| 前端 | UI、路由、狀態管理 |
| 測試 | Unit test、integration test、覆蓋率 |
| 安全 | 漏洞掃描、認證審查、依賴審計 |

### 24 個 Skill

不用手動呼叫，聊天提到相關的事就會自動載入。涵蓋資料庫優化、Web 效能、無障礙、SEO、Git 工作流、安全審計、架構圖生成等。完整清單見 [install.sh](install.sh)。

### 3 個指令

| 指令 | 用途 |
|------|------|
| `/team` | 啟動完整團隊 |
| `/duo` | 輕量版，一個規劃一個執行 |
| `/status` | 看裝了什麼、知識庫有多少 |

---

## 防護機制

| 機制 | 說明 |
|------|------|
| 三振出局 | 同一個錯連續 3 次，agent 停下來回報，不會無限重試 |
| 檔案上限 | 一次改超過 20 個檔案要先回報 |
| 套件上限 | 一次裝超過 10 個套件要先回報 |
| 禁止刪檔 | 除非架構文件明確要求 |
| 漸進啟動 | 每個階段做完 Lead 檢查過才開下一個 |
| 自動壓縮 | 階段之間自動壓縮 context，省 token |
| 輸出過濾 | 測試和建置的輸出自動裁切 |

---

## 知識累積

每次跑完 `/team` 會自動把這次的架構決策、踩過的坑、解法模式存到 `~/.claude/knowledge/`。下次開工會自動讀，不用重新探索。

另外會存一份 JSONL 格式的訓練資料，以後可以拿去 fine-tune 自己的模型。

---

## 要求

- [Claude Code CLI](https://claude.ai)
- Claude Max 方案（建議，五個 Opus 同時跑很吃額度）
- git、jq

---

## 多少錢

每次 `/team` 大約是平常用 Claude Code 的 5 倍 token。中型功能大概 $5-15 美金。想省的話可以把 agent 的 model 從 `opus` 改成 `sonnet`，省約 40%。

---

## 常見問題

**有現成的專案也能用嗎？**
可以。架構師會先讀你的 code 再設計，不會砍掉重練。

**Agent 卡住怎麼辦？**
三振出局會接管，不會無限燒錢。

**知識存在哪？**
`~/.claude/knowledge/`，全在你電腦上。

---

<div align="center">

**給要出貨的人用的。**

</div>
