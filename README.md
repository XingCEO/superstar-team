<div align="center">

# ⭐ SUPERSTAR TEAM

### 一個指令。五個 Opus。全自動交付。

**你裝過最猛的 Claude Code 設定。**

`/team` → 說你想做什麼 → 五個 AI 工程師同時幫你寫。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Opus_4.6-blueviolet)](https://claude.ai)
[![Agents](https://img.shields.io/badge/Agents-5_×_Opus-ff6600)](/)
[![Skills](https://img.shields.io/badge/Skills-24_自動觸發-00cc66)](/)

</div>

---

## 這是什麼

你打 `/team`，用你自己的話說想做什麼。Opus 架構師幫你選技術棧、設計架構。你看一眼說 OK，後端和前端就在各自獨立的 git worktree 裡同時寫 code。寫完自動合併、跑測試、掃安全漏洞、做 QA、檢查設計、開 PR、更新文件、把學到的東西存起來。

**你回答 1-2 個問題，團隊做剩下的。**

---

## 安裝

```bash
git clone https://github.com/XingCEO/superstar-team.git
cd superstar-team
./install.sh
```

一行裝好。

---

## 使用

```bash
claude                              # 開啟 Claude Code
/team                               # 啟動團隊
/team 做一個讓人評價小吃的 app        # 或直接說
/status                             # 看你有什麼
```

### `/team` 的完整流程

```
你：「/team 做一個讓人評價小吃的 app」
團隊：「給誰用的？先出 MVP 還是一步到位？」
你：「公開產品，先 MVP」

        ╔═══════════════════════════╗
        ║   🏗️  架構師 (Opus)       ║
        ║   選技術棧・設計架構       ║
        ╚═══════════╤═══════════════╝
                    │ 你說 OK
        ┌───────────┴───────────┐
        ▼                       ▼
╔═══════════════╗       ╔═══════════════╗
║  🔧 後端 Opus  ║       ║  🎨 前端 Opus  ║
║  Worktree A   ║       ║  Worktree B   ║
║  API・DB・邏輯 ║       ║  UI・路由・狀態 ║
╚═══════╤═══════╝       ╚═══════╤═══════╝
        └───────────┬───────────┘
                    ▼
        ╔═══════════════════════════╗
        ║     🔀 自動合併 Worktree   ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║     🧪 測試工程師 (Opus)   ║
        ║     Unit・Integration     ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║     🔒 安全審查員 (Opus)   ║
        ║     漏洞掃描・依賴審計     ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║     ⚡ 品質閘門（全自動）   ║
        ║                           ║
        ║  /review   程式碼審查      ║
        ║  /cso      安全掃描       ║
        ║  /qa       QA 測試        ║
        ║  /design   設計審查       ║
        ║  /health   健康檢查       ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║  🚀 /ship 建 PR           ║
        ║  📄 /document 更新文件     ║
        ╚═══════════╤═══════════════╝
                    ▼
        ╔═══════════════════════════╗
        ║  🧠 知識收割               ║
        ║  架構決策・解法模式・JSONL  ║
        ╚═══════════════════════════╝
```

---

## 包含什麼

### 5 個 Agent（全 Opus）

| Agent | 角色 | 做什麼 |
|-------|------|--------|
| **架構師** | 系統設計 | 選技術棧、設計架構、定義 API 契約、分配檔案所有權 |
| **後端** | 實作 | API 路由、資料庫 schema、業務邏輯、middleware |
| **前端** | 實作 | UI 元件、路由、狀態管理、API 串接 |
| **測試** | 品質 | Unit test、integration test、edge case、覆蓋率報告 |
| **安全** | 審計 | Injection 掃描、認證審查、secrets 偵測、依賴審計 |

### 24 個自動觸發 Skills

你不用呼叫它們。說到相關的事它們就會介入。

| 來源 | Stars | 技能 |
|------|-------|------|
| [obra/superpowers](https://github.com/obra/superpowers) | 134K | Git worktree 管理、完成前驗證、平行代理派工 |
| [PlanetScale](https://github.com/planetscale/database-skills) | 387 | MySQL / PostgreSQL schema 設計、查詢優化 |
| [Addy Osmani](https://github.com/addyosmani/web-quality-skills) | 1.5K | 效能優化（50+ 模式）、Core Web Vitals、WCAG 2.2 無障礙、SEO |
| [Trail of Bits](https://github.com/trailofbits/skills) | 4.3K | 供應鏈審計、CodeQL、不安全預設偵測、多模型交叉驗證 |
| [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin) | 12.8K | 學習迴圈 — 讓每次開發的經驗自動累積 |
| [Excalidraw](https://github.com/coleam00/excalidraw-diagram-skill) | 1.8K | 自然語言生成架構圖 |
| [Vercel](https://github.com/vercel-labs/agent-skills) | 24.4K | 100+ UI 審計規則：無障礙、國際化、觸控、深色模式 |

### 7 Phase 流水線

| Phase | 做什麼 | 自動？ |
|-------|--------|--------|
| 1. 聽你說 | 你描述想做什麼 | 你說 |
| 1.5 讀知識庫 | 讀過去的決策，避免重複踩坑 | ✅ |
| 2. 架構設計 | Opus 架構師出完整規格 + 技術棧推薦 | ✅（你確認）|
| 3. 平行開發 | 後端 + 前端在獨立 worktree 同時寫 | ✅ |
| 4. 整合 | 合併 worktree、處理衝突 | ✅ |
| 5. 品質閘門 | 程式碼審查 → 安全 → QA → 設計 → 健康 | ✅ |
| 6. 交付 | 建 PR、更新文件 | ✅ |
| 7. 知識收割 | 存架構決策、解法模式、訓練資料 | ✅ |

### 防護機制

| 護欄 | 防什麼 |
|------|--------|
| 三振出局 | 同一個錯 3 次 → agent 強制停止回報 |
| 檔案上限 | 改超過 10 個檔案 → 先回報 |
| 套件上限 | 裝超過 5 個套件 → 先回報 |
| 禁止刪檔 | 不能刪現有檔案，除非架構文件要求 |
| 漸進啟動 | Lead 每步檢查才開下一個 |
| 自動壓縮 | Phase 之間自動 compact context |
| 輸出過濾 | 測試 / 建置輸出自動裁切，省 token |

### 知識累積

每次完工自動存：

| 存什麼 | 格式 | 位置 |
|--------|------|------|
| 架構決策紀錄 | Markdown | `~/.claude/knowledge/` |
| 解法模式 | Markdown | `~/.claude/knowledge/patterns/` |
| 訓練資料 | JSONL | `~/.claude/knowledge/training/` |

JSONL 格式（未來 fine-tune 用）：
```json
{"instruction": "...", "input": "...", "output": "...", "tags": [], "quality": "high"}
```

---

## 指令

| 指令 | 用途 |
|------|------|
| `/team` | 啟動完整團隊流水線 |
| `/duo` | 輕量雙人模式：Opus 規劃 + Opus 執行 |
| `/status` | 查看所有已安裝的資產和知識庫狀態 |

---

## 需求

- **Claude Code CLI** — `npm install -g @anthropic-ai/claude-code`
- **Claude Max 方案**（建議 — 5 個 Opus 同時跑很吃 token）
- **git**
- **jq**（hook 用）

---

## 常見問題

**花多少錢？**
每次 `/team` 大約是單一 session 的 5 倍 token。中型功能大概 $5-15。Max 方案 $200/月，密集用大約撐 2-3 天全團隊作業。

**可以用 Sonnet 省錢嗎？**
可以。改 `~/.claude/agents/*.md` 裡的 `model: opus` 成 `model: sonnet`，省約 40%，推理品質會降一些。

**有現成 code 也能用嗎？**
能。架構師會先讀你的 codebase 再設計，不會砍掉重練。

**Agent 卡住怎麼辦？**
三振出局機制會接管。同一件事失敗 3 次，agent 自動停止回報。不會無限迴圈燒錢。

**知識存在哪？**
`~/.claude/knowledge/`。全在你的電腦上，不會外傳。下次打 `/team` 自動讀取。

---

<div align="center">

**給要出貨的人用的。**

</div>
