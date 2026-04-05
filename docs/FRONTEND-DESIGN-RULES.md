# 反 AI Slop 前端設計指南

> **目的**：本文件為 Claude Code 前端 Agent 的強制設計規範。遵循這些規則，確保產出的 UI 具備專業級品質，而非典型 AI 生成的廉價感。

---

## 一、AI Slop 的特徵——絕對禁止清單

### 1.1 顏色反模式

| 禁止 | 為什麼是 Slop | 正確做法 |
|------|---------------|----------|
| 紫藍漸層 `linear-gradient(135deg, #667eea, #764ba2)` | 90% AI 產出都用這組，一眼即知是 AI 生成 | 使用語意化色彩 token，從品牌色推導 |
| 深色背景 + 霓虹青/紫色點綴 `#38BDF8` `#A855F7` | SaaS demo 美學的預設組合 | 建立完整色彩系統，使用 CSS 變數 |
| 裝飾性漸層文字 `-webkit-background-clip: text` | 為了「衝擊力」濫用，實際降低可讀性 | 使用實色文字，透過排版層級製造衝擊力 |
| 到處使用毛玻璃 `backdrop-filter: blur(10px)` | 裝飾性 blur 毫無功能目的 | 僅在功能性分層場景使用（如 overlay） |

**正確的色彩系統：**
```css
:root {
  /* 語意化命名，禁止裝飾性命名 */
  --color-bg-primary: #ffffff;
  --color-bg-secondary: #f9fafb;
  --color-bg-tertiary: #f3f4f6;
  --color-text-primary: #111827;    /* 對比度 15.3:1 ✓ */
  --color-text-secondary: #4b5563;  /* 對比度 7.5:1 ✓ */
  --color-text-tertiary: #6b7280;   /* 對比度 5.0:1 ✓ */
  --color-action-primary: /* 從品牌色推導 */;
  --color-action-hover: /* 比 primary 深 10-15% */;
  --color-feedback-success: #059669;
  --color-feedback-error: #dc2626;
  --color-feedback-warning: #d97706;
  --color-border-default: #e5e7eb;
  --color-border-strong: #d1d5db;
}
```

### 1.2 字型反模式

| 禁止 | 為什麼是 Slop | 正確做法 |
|------|---------------|----------|
| 只用 Inter / Roboto / Arial | 缺乏個性，是 AI 的預設選擇 | 選擇有品牌特色的字型 |
| 超過 2 個字型家族 | 視覺混亂 | 最多 2 個：一個標題、一個內文 |
| 使用 font-weight < 400 | 小字號下無法閱讀 | 最輕用 400（Regular），強調用 600-700 |
| 純黑色文字 `#000000` | 對比過強，視覺刺眼 | 使用深灰 `#111827` 或 `#1a1a2e` |

**推薦字型組合（按風格）：**
- **專業 SaaS**：Geist Sans（Vercel）+ system-ui fallback
- **開發者工具**：JetBrains Mono + Inter
- **溫暖友善**：Bricolage Grotesque + system-ui
- **權威感**：Playfair Display（標題）+ Source Sans 3（內文）
- **極簡現代**：DM Sans + DM Mono

### 1.3 排版反模式

| 禁止 | 為什麼是 Slop | 正確做法 |
|------|---------------|----------|
| 所有卡片 padding/radius 一樣 | 均勻 = 無層級 = AI 味 | 根據元素重要性變化間距 |
| 卡片套卡片套卡片 | AI 不懂層級，用容器堆疊 | 扁平化，僅語意需要時使用卡片 |
| 到處都是陰影 | 每個元件用不同 shadow 配方 | 限定 3 層 elevation token |
| 所有元素間距均等 | 違反親近性原則 | 相關元素靠近，無關元素拉遠 |

### 1.4 內容反模式

| 禁止 | 為什麼是 Slop | 正確做法 |
|------|---------------|----------|
| 「Build the future of work」 | AI 平均化的陳腔濫調 | 寫具體的產品價值（如 Stripe：「Financial infrastructure for the internet」） |
| 「Your all-in-one platform」 | 模糊、套用所有產品 | 具體說明功能，用創辦人口吻 |
| 「best-in-class」「cutting-edge」 | 空洞修飾詞 | 刪掉，用數據或具體描述取代 |
| stock photo 風格的 AI 插圖 | 過度光滑、過度對稱、塑膠質感 | 使用產品截圖、真實照片、自訂插圖 |

### 1.5 Dashboard 專屬反模式

| 禁止 | 為什麼是 Slop |
|------|---------------|
| Hero Metric Layout（大數字 + 小標籤 + 漸層線） | 90% AI dashboard 都這樣 |
| 所有 KPI 卡片同尺寸 | 無視資料重要性差異 |
| 統一的 fade-in 滾動動畫 | 無目的的裝飾性動畫 |

---

## 二、間距系統——4px 基線網格

### 2.1 間距刻度（Spacing Scale）

基於 4px 基線，使用以下固定刻度。**禁止使用刻度外的任意值。**

```
--space-0:   0px
--space-0.5: 2px    /* 極微調：icon 內距 */
--space-1:   4px    /* icon 與文字間距 */
--space-1.5: 6px
--space-2:   8px    /* 元件內部元素間距 */
--space-3:  12px    /* 緊湊的內部 padding */
--space-4:  16px    /* 預設卡片 padding、列表項間距 */
--space-5:  20px
--space-6:  24px    /* 區塊間距（mobile） */
--space-8:  32px    /* 區段間距 */
--space-10: 40px
--space-12: 48px    /* 大區段分隔（desktop） */
--space-16: 64px    /* 頁面級區段間距 */
--space-20: 80px
--space-24: 96px    /* 超大留白（hero section） */
```

### 2.2 間距使用規則

| 場景 | 間距 | Tailwind class |
|------|------|----------------|
| Icon 與相鄰文字 | 4px | `gap-1` |
| 同群組內元素 | 8px | `gap-2` |
| 表單欄位之間 | 12-16px | `gap-3` 或 `gap-4` |
| 卡片內 padding | 16-24px | `p-4` 或 `p-6` |
| 卡片之間 | 16-24px | `gap-4` 或 `gap-6` |
| Section 之間（mobile） | 32-48px | `py-8` 或 `py-12` |
| Section 之間（desktop） | 48-96px | `py-12` 或 `py-24` |
| 頁面頂部/底部 | 64-96px | `py-16` 或 `py-24` |

### 2.3 親近性法則（Gestalt Proximity）

**核心規則：外間距（margin）必須 ≥ 內間距（padding）。**

```
❌ 錯誤：卡片 padding 24px，卡片之間 gap 16px
✓ 正確：卡片 padding 16px，卡片之間 gap 24px

❌ 錯誤：所有間距均為 16px
✓ 正確：相關元素 8px、同層級 16px、不同區段 32px+
```

**原則：寧可先放太多白空間，再收縮。從寬鬆開始設計。**

---

## 三、排版系統——模組化字級

### 3.1 字級刻度（Type Scale）

建議使用 Major Third (1.25) 或類似比例：

```
--text-xs:    12px  (0.75rem)   /* 標註、版權 */
--text-sm:    14px  (0.875rem)  /* 輔助文字、表單標籤 */
--text-base:  16px  (1rem)      /* 內文基準——禁止低於此值做主內文 */
--text-lg:    18px  (1.125rem)  /* 強調內文、lead paragraph */
--text-xl:    20px  (1.25rem)   /* 小標題 (h4) */
--text-2xl:   24px  (1.5rem)    /* 次標題 (h3) */
--text-3xl:   30px  (1.875rem)  /* 標題 (h2) */
--text-4xl:   36px  (2.25rem)   /* 大標題 (h1) */
--text-5xl:   48px  (3rem)      /* Display text */
--text-6xl:   60px  (3.75rem)   /* Hero headline */
```

### 3.2 行高規則

| 用途 | 行高 | 說明 |
|------|------|------|
| 標題（Display/H1/H2） | 1.1 - 1.2 | 大字號用緊行高 |
| 次標題（H3/H4） | 1.25 - 1.3 | 中等行高 |
| 內文 | 1.5 - 1.6 | 最佳閱讀行高 |
| 長文閱讀 | 1.6 - 1.75 | 寬鬆舒適 |
| UI 標籤/按鈕 | 1.0 - 1.25 | 緊湊行高 |

### 3.3 行寬規則

- **最大行寬**：65-75 字元（`max-w-prose` = 65ch）
- **最佳行寬**：45-75 字元
- **標題最大寬度**：20-35 字元（強制換行以製造韻律）

### 3.4 字重使用

| 用途 | 字重 | 備註 |
|------|------|------|
| 內文 | 400（Regular） | 預設 |
| 強調文字 | 500（Medium） | 細微強調 |
| 標題 | 600（SemiBold） | 主要標題字重 |
| 視覺重點 | 700（Bold） | 僅用於最重要元素 |
| 禁止使用 | < 400 | 小字號下無法閱讀 |

### 3.5 層級建立法則

建立視覺層級時，**至少同時改變兩個變數**（大小 / 字重 / 顏色）：

```
❌ 只改大小：16px Regular → 20px Regular（差異不明顯）
✓ 改大小 + 字重：16px Regular #4b5563 → 20px SemiBold #111827
✓ 改字重 + 顏色：16px Regular #6b7280 → 16px Bold #111827
```

---

## 四、對比度與無障礙——硬性門檻

### 4.1 WCAG AA 最低標準（強制）

| 元素 | 最低對比度 | 說明 |
|------|-----------|------|
| 一般文字（< 24px） | **4.5:1** | 無例外 |
| 大文字（≥ 24px 或 ≥ 18.66px bold） | **3:1** | |
| UI 元件 & 圖形 | **3:1** | 按鈕、圖標、邊框 |
| 焦點指示器 | **3:1** | focus ring 必須可見 |

### 4.2 推薦對比度（追求品質）

- 主要內文：**≥ 7:1**（WCAG AAA）
- 次要內文：**≥ 4.5:1**
- 輔助文字（caption）：**≥ 4.5:1**——不得以「裝飾」為由降低

### 4.3 色彩背景上的文字

**禁止在彩色背景上使用灰色文字。** 正確做法：
1. 降低白色文字的透明度（讓背景色透出）
2. 手動挑選同色相、調整飽和度與明度的文字色

---

## 五、陰影與層級（Elevation）

### 5.1 陰影 Token 系統（限定 3-5 層）

```css
:root {
  --shadow-xs:  0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-sm:  0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
  --shadow-md:  0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
  --shadow-lg:  0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
  --shadow-xl:  0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
}
```

### 5.2 使用規則

| Elevation 層級 | 用途 | Token |
|---------------|------|-------|
| 0（平面） | 頁面內容、卡片（用邊框區分） | 無 shadow |
| 1（微浮） | 按鈕、輸入框 | `--shadow-xs` 或 `--shadow-sm` |
| 2（浮起） | 下拉選單、popup | `--shadow-md` |
| 3（高浮） | Modal、toast | `--shadow-lg` |
| 4（最高） | 全螢幕 overlay | `--shadow-xl` |

**規則：陰影應有垂直偏移（模擬頂部光源），禁止四周均勻擴散。**

---

## 六、圓角系統（Border Radius）

### 6.1 圓角 Token

```css
:root {
  --radius-none: 0px;
  --radius-sm:   4px;    /* 小元件：tag、badge */
  --radius-md:   6px;    /* 按鈕、輸入框 */
  --radius-lg:   8px;    /* 卡片 */
  --radius-xl:  12px;    /* 大卡片、dialog */
  --radius-2xl: 16px;    /* 大型容器 */
  --radius-full: 9999px; /* 圓形：avatar、pill */
}
```

### 6.2 嵌套圓角規則

**內層圓角 = 外層圓角 - padding**

```
外層卡片：radius 12px，padding 8px
→ 內層元素：radius 4px（12 - 8 = 4）

外層卡片：radius 16px，padding 16px
→ 內層元素：radius 0px 或 使用最小值 4px
```

---

## 七、佈局與容器

### 7.1 最大寬度

| 用途 | 最大寬度 | Tailwind |
|------|---------|----------|
| 閱讀內容 | 65ch (≈ 580px) | `max-w-prose` |
| 表單 | 480-560px | `max-w-lg` ~ `max-w-xl` |
| 內容區域 | 768px | `max-w-3xl` |
| 主佈局 | 1024-1152px | `max-w-5xl` ~ `max-w-6xl` |
| 全寬 Dashboard | 1280-1440px | `max-w-7xl` 或自訂 |
| 絕對最大 | 1536px | `max-w-screen-2xl` |

### 7.2 Grid 系統

- **12 欄網格**為標準
- Gutter：desktop 24-32px，tablet 16-24px，mobile 16px
- 頁面邊距：desktop 32-64px，tablet 24-32px，mobile 16-20px

### 7.3 響應式斷點

```
Mobile:  < 640px   (sm)
Tablet:  640-1023px (md)
Desktop: 1024-1279px (lg)
Wide:    ≥ 1280px  (xl)
```

---

## 八、互動狀態——完整性檢查

### 8.1 每個互動元件必須具備以下狀態

| 狀態 | 必要性 | 說明 |
|------|--------|------|
| Default | 必要 | 基礎樣式 |
| Hover | 必要 | 滑鼠懸停反饋 |
| Focus | 必要 | 鍵盤導航可見，`outline: 2px solid`，`outline-offset: 2px` |
| Active/Pressed | 必要 | 按下反饋 |
| Disabled | 必要 | `opacity: 0.5-0.6`，`cursor: not-allowed` |
| Loading | 視情況 | 非同步操作時 |
| Error | 視情況 | 表單驗證 |
| Empty | 視情況 | 無資料時 |

### 8.2 按鈕層級

```
主要（Primary）：   實色背景 + 白字，高對比
次要（Secondary）：  outline 或低對比背景
第三級（Tertiary）：  純文字連結樣式，無背景無邊框
危險（Destructive）：根據重要性決定樣式，不是「紅色 = 危險」
```

**規則：不是每個按鈕都需要背景色。根據動作層級決定視覺權重。**

---

## 九、動畫與過渡

### 9.1 時間規範

```css
:root {
  --duration-fast:   100ms;  /* hover 狀態變化 */
  --duration-normal: 200ms;  /* 一般過渡 */
  --duration-slow:   300ms;  /* 展開/收合、modal 進出 */
  --duration-slower: 500ms;  /* 頁面級過渡 */

  --ease-default: cubic-bezier(0.25, 0.1, 0.25, 1.0);  /* ease-out 感 */
  --ease-in-out:  cubic-bezier(0.42, 0, 0.58, 1);
  --ease-spring:  cubic-bezier(0.34, 1.56, 0.64, 1);    /* 彈跳效果 */
}
```

### 9.2 動畫三原則

1. **每個動畫必須解決一個 UX 問題**——傳達狀態變化、引導注意力、或強化品牌個性
2. **禁止純裝飾性動畫**——如無目的的 fade-in 滾動效果
3. **奢華品牌 = 平滑緩慢，活潑品牌 = 敏捷彈跳**——easing 和 duration 要匹配品牌調性

### 9.3 Hover 效果

```css
/* 按鈕 hover：微上移 + 陰影加深 */
button:hover {
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
  transition: all var(--duration-normal) var(--ease-default);
}

/* 卡片 hover：陰影加深，禁止放大（scale 是 AI slop） */
.card:hover {
  box-shadow: var(--shadow-lg);
  transition: box-shadow var(--duration-normal) var(--ease-default);
}
```

---

## 十、Tailwind CSS 設計系統配置

### 10.1 Token 化配置

```js
// tailwind.config.js — 所有值集中定義
export default {
  theme: {
    extend: {
      colors: {
        // 語意化色彩，從 CSS 變數讀取
        brand: 'hsl(var(--brand))',
        'brand-foreground': 'hsl(var(--brand-foreground))',
      },
      borderRadius: {
        sm: 'var(--radius-sm)',
        md: 'var(--radius-md)',
        lg: 'var(--radius-lg)',
        xl: 'var(--radius-xl)',
      },
      boxShadow: {
        xs: 'var(--shadow-xs)',
        sm: 'var(--shadow-sm)',
        md: 'var(--shadow-md)',
        lg: 'var(--shadow-lg)',
        xl: 'var(--shadow-xl)',
      },
    },
  },
}
```

### 10.2 元件架構（shadcn/ui 模式）

```
components/
├── ui/          # 原始 shadcn 元件（不修改）
├── primitives/  # 輕度客製化的元件（加入品牌 token）
└── blocks/      # 產品級組合（pricing card、auth form 等）
```

### 10.3 包裝元件模式

```tsx
// 禁止直接使用 shadcn Button，使用包裝元件
export function AppButton(props: ButtonProps) {
  return (
    <Button
      className="font-medium tracking-tight"
      {...props}
    />
  );
}
```

---

## 十一、用邊框替代方案創造分隔

**Refactoring UI 核心法則：使用更少的邊框。**

替代方案（優先順序）：
1. **增加間距**——最乾淨的分隔方式
2. **不同背景色**——相鄰區塊用 `bg-white` vs `bg-gray-50`
3. **微妙陰影**——`shadow-sm` 取代 `border-b`
4. **邊框（最後手段）**——僅在以上都不適合時使用

---

## 十二、品質門檻檢查清單

每個頁面交付前必須通過：

### Token 覆蓋率
- [ ] 10 個隨機元件中 ≥ 8 個使用定義的間距 token
- [ ] 10 個隨機元件中 ≥ 8 個使用定義的圓角 token
- [ ] 全頁面最多 3 種 shadow 配方

### 對比度
- [ ] 所有一般文字 ≥ 4.5:1 對比度
- [ ] 所有大文字 ≥ 3:1 對比度
- [ ] UI 元件 ≥ 3:1 對比度

### 互動完整性
- [ ] 所有按鈕具備 hover / focus / active / disabled 狀態
- [ ] 所有表單元件具備 focus / error / disabled 狀態
- [ ] 所有連結具備 hover / focus 狀態
- [ ] focus 指示器使用 `focus-visible`（非 `focus`）

### 排版
- [ ] 內文 ≥ 16px
- [ ] 行高：標題 1.1-1.2，內文 1.5-1.6
- [ ] 閱讀行寬 ≤ 75 字元
- [ ] 字重 ≥ 400

### 響應式
- [ ] Mobile (375px)、Tablet (768px)、Desktop (1280px) 皆正常
- [ ] 觸控目標 ≥ 44x44px

### 反 Slop
- [ ] 無紫藍漸層
- [ ] 無裝飾性毛玻璃
- [ ] 無均勻間距（有明確的層級差異）
- [ ] 無 stock photo 風格的 AI 插圖
- [ ] 無空洞行銷用語
- [ ] 字型非純 Inter/Roboto/Arial（除非品牌要求）

---

## 十三、2025-2026 高端設計趨勢參考

以下為當前頂級網站的設計方向，可作為風格參考：

| 趨勢 | 說明 | 適用場景 |
|------|------|----------|
| 暗色模式 + 金/銀點綴 | 暗背景讓金屬色更顯眼 | 高端品牌、專業工具 |
| 極簡留白 | 大量白空間 = 高級感 | 所有場景 |
| 柔和大地色系 | 膚色、木質、土壤色調 | 溫暖品牌、生活風格 |
| 復古紋理 | 顆粒感背景、單色漸層 | 品牌故事頁面 |
| Kinetic 動態字型 | 字型隨互動變化 | Hero section |
| 打破網格 | 不對稱佈局創造動感 | 創意/設計產業 |

---

## 十四、快速參考速查表

```
間距刻度：4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96
字級刻度：12 / 14 / 16 / 18 / 20 / 24 / 30 / 36 / 48 / 60
字重範圍：400 / 500 / 600 / 700（禁止 < 400）
行高規則：標題 1.1-1.2 / 次標題 1.25-1.3 / 內文 1.5-1.6
閱讀寬度：max-w-prose (65ch)
內容寬度：max-w-5xl ~ max-w-6xl (1024-1152px)
圓角刻度：0 / 4 / 6 / 8 / 12 / 16 / 9999
陰影層級：xs / sm / md / lg / xl（最多 3 層在同頁面）
動畫時間：100ms(fast) / 200ms(normal) / 300ms(slow)
對比度：文字 ≥ 4.5:1 / 大文字 ≥ 3:1 / UI ≥ 3:1
觸控目標：≥ 44x44px
最小字號：12px（標註） / 16px（內文）
```
