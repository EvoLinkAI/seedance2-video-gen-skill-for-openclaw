🌐 [English](README.md) | [Español](README.es.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Türkçe](README.tr.md) | [Русский](README.ru.md) | [Português](README.pt.md) | [简体中文](README.zh-CN.md) | **繁體中文**


# Seedance 2 Video Gen Skill for OpenClaw

<p align="center">
  <strong>AI 影片生成等 — 一鍵安裝、秒速開始創作。</strong>
</p>

<p align="center">
  <a href="#seedance-影片生成">Seedance 2.0</a> •
  <a href="#安裝">安裝</a> •
  <a href="#取得-api-key">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>🌐 Languages：</strong>
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">简体中文</a> |
  <a href="README.zh-TW.md">繁體中文</a> |
  <a href="README.es.md">Español</a> |
  <a href="README.ja.md">日本語</a> |
  <a href="README.ko.md">한국어</a> |
  <a href="README.tr.md">Türkçe</a> |
  <a href="README.fr.md">Français</a> |
  <a href="README.de.md">Deutsch</a>
</p>

---

## 這是什麼？

一套基於 [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 的 [OpenClaw](https://github.com/openclaw/openclaw) 技能包。安裝一個技能，你的 AI 代理就獲得新能力 — 生成影片、處理媒體等。

當前可用：

| 技能 | 描述 | 模型 |
|------|------|------|
| **Seedance Video Gen** | 文生影片、圖生影片、參考生影片，自動配音 | Seedance 2.0（字節跳動） |

📚 **完整指南**：[awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — 提示詞、使用案例、功能展示

更多技能即將推出。

---

## 安裝

### 快速安裝（推薦）

```bash
openclaw skills add https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw
```

搞定。技能已可供代理使用。

### 通過 npm 安裝

```bash
npx evolink-seedance
```

或使用非交互模式（適用於 AI 代理 / CI）：

```bash
npx evolink-seedance -y
```

### 手動安裝

```bash
git clone https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw.git
cd seedance2-video-gen-skill-for-openclaw
openclaw skills add .
```

---

## 取得 API Key

1. 在 [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw) 註冊
2. 進入 Dashboard → API Keys
3. 創建新 Key
4. 設置環境變量：

```bash
export EVOLINK_API_KEY=your_key_here
```

或者直接告訴你的 OpenClaw 代理：*「設置我的 EvoLink API key 為 ...」* — 它會搞定。

---

## Seedance 影片生成

透過與 OpenClaw 代理自然對話來生成 AI 影片。

### 能力

- **文生影片** — 描述場景，生成影片（支援聯網搜尋）
- **圖生影片** — 1 張圖：首幀動畫；2 張圖：首尾幀插值
- **參考生影片** — 組合圖片、影片片段和音訊，創建、編輯或延長影片
- **自動配音** — 同步語音、音效、背景音樂
- **多解析度** — 480p、720p
- **靈活時長** — 4–15 秒
- **多比例** — 16:9、9:16、1:1、4:3、3:4、21:9、adaptive

### 使用示例

直接和代理說話：

> 「生成一個 5 秒的貓彈鋼琴影片」

> 「創建一個海上日落的電影級畫面，720p，16:9」

> 「用這張圖作為參考，生成一個 8 秒的動畫影片」

> 「編輯這個影片片段 — 把裡面的物品替換成我的產品圖」

代理會引導你補充缺失信息並處理生成。

### 系統要求

- 系統已安裝 `curl` 和 `jq`
- 已設置 `EVOLINK_API_KEY` 環境變量

### 腳本參考

技能包含 `scripts/seedance-gen.sh` 供命令行直接使用：

```bash
# 文生影片
./scripts/seedance-gen.sh "寧靜的山間黎明景色" --duration 5 --quality 720p

# 圖生影片（首幀動畫）
./scripts/seedance-gen.sh "輕柔的海浪" --image "https://example.com/beach.jpg" --duration 8 --quality 720p

# 參考生影片（用圖片編輯影片片段）
./scripts/seedance-gen.sh "將物品替換為圖片1中的產品" --image "https://example.com/product.jpg" --video "https://example.com/clip.mp4" --duration 5 --quality 720p

# 豎版（社交媒體）
./scripts/seedance-gen.sh "舞動的粒子" --aspect-ratio 9:16 --duration 4 --quality 720p

# 無音訊
./scripts/seedance-gen.sh "抽象藝術動畫" --duration 6 --quality 720p --no-audio
```

### API 參數

完整 API 文檔見 [references/api-params.md](references/api-params.md)。

---

## 文件結構

```
.
├── README.md                    # 本文件
├── SKILL.md                     # OpenClaw 技能定義
├── _meta.json                   # 技能元數據
├── references/
│   └── api-params.md            # 完整 API 參數文檔
└── scripts/
    └── seedance-gen.sh          # 影片生成腳本
```

---

## 常見問題

| 問題 | 解決方案 |
|------|---------|
| `jq: command not found` | 安裝 jq：`apt install jq` / `brew install jq` |
| `401 Unauthorized` | 檢查 `EVOLINK_API_KEY`，在 [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 確認 |
| `402 Payment Required` | 在 [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 充值 |
| 內容被攔截 | 真實人臉受限 — 修改提示詞 |
| 影片檔案過大 | 參考影片每個不超過 50MB，總時長不超過 15 秒 |
| 生成超時 | 影片生成需 30–180 秒，先試低分辨率 |

---

## 更多技能

更多 EvoLink 技能正在開發中。關注更新或 [提出需求](https://github.com/EvoLinkAI/evolink-skills/issues)。

---

## 從 ClawHub 下載

你也可以直接從 ClawHub 安裝此技能：

👉 **[在 ClawHub 下載 →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## 授權條款

MIT

---

<p align="center">
  由 <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> 提供支持 — 統一 AI API 閘道
</p>
