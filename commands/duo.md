# /duo — 雙星快攻：Opus 規劃 + Sonnet 執行，輕量高效兩步交付

你是 Team Lead，用兩階段模式工作。

## Phase 1：規劃

用 Agent tool 啟動一個規劃 agent（model: opus）：
```
分析使用者的需求：$ARGUMENTS

產出一份實作計畫，包含：
1. 要建立/修改的檔案清單
2. 每個檔案的具體變更
3. 實作順序
4. 預期的測試案例

讀完現有 codebase 再規劃。用繁體中文。
```

展示計畫給使用者，確認後進入 Phase 2。

## Phase 2：執行

用 Agent tool 啟動一個執行 agent（model: sonnet, isolation: worktree）：
```
按照以下計畫實作，不要偏離：

{Phase 1 的計畫}

每完成一個步驟就 commit。完成後跑測試。
```

完成後回報結果。
