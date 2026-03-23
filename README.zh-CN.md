# Seedance 2 Video Gen Skill — OpenClaw 技能包

<p align="center">
  <strong>AI 视频生成等能力 — 一条命令安装，秒级开始创作。</strong>
</p>

<p align="center">
  <a href="#seedance-视频生成">Seedance 2.0</a> •
  <a href="#安装">安装</a> •
  <a href="#获取-api-key">API Key</a> •
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

## 这是什么？

一套基于 [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 的 [OpenClaw](https://github.com/openclaw/openclaw) 技能包。安装一个技能，你的 AI 代理就获得新能力 — 生成视频、处理媒体等。

当前可用：

| 技能 | 描述 | 模型 |
|------|------|------|
| **Seedance 视频生成** | 文生视频、图生视频，自动配音 | Seedance 1.5 Pro → 2.0（字节跳动） |

📚 **完整指南**：[awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — 提示词、使用案例、功能展示

🚀 **[申请 Seedance 2.0 API 抢先体验 →](https://seedance2api.app/)**

**说明**：当前使用 Seedance 1.5 Pro。Seedance 2.0 上线后，无需任何迁移操作，直接可用。

更多技能即将推出。

---

## 安装

### 快速安装（推荐）

```bash
openclaw skills add https://github.com/EvoLinkAI/evolink-skills
```

完事。技能已可供代理使用。

### 手动安装

```bash
git clone https://github.com/EvoLinkAI/evolink-skills.git
cd evolink-skills
openclaw skills add .
```

---

## 获取 API Key

1. 在 [evolink.ai](https://evolink.ai/signup?utm_source=github[evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw)utm_medium=readme[evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw)utm_campaign=seedance2-video-gen-skill-for-openclaw) 注册
2. 进入 Dashboard → API Keys
3. 创建新 Key
4. 设置环境变量：

```bash
export EVOLINK_API_KEY=your_key_here
```

或者直接告诉你的 OpenClaw 代理：*"设置我的 EvoLink API key 为 ..."* — 它会搞定。

---

## Seedance 视频生成

通过与 OpenClaw 代理自然对话来生成 AI 视频。

### 能力

- **文生视频** — 描述场景，生成视频
- **图生视频** — 提供参考图引导输出
- **自动配音** — 同步语音、音效、背景音乐
- **多分辨率** — 480p、720p、1080p
- **灵活时长** — 4–12 秒
- **多比例** — 16:9、9:16、1:1、4:3、3:4、21:9

### 使用示例

直接和代理说话：

> "生成一个 5 秒的猫弹钢琴视频"

> "创建一个海上日落的电影级画面，1080p，16:9"

> "用这张图作为参考，生成一个 8 秒的动画视频"

代理会引导你补充缺失信息并处理生成。

### 系统要求

- 系统已安装 `curl` 和 `jq`
- 已设置 `EVOLINK_API_KEY` 环境变量

### 脚本参考

技能包含 `scripts/seedance-gen.sh` 供命令行直接使用：

```bash
# 文生视频
./scripts/seedance-gen.sh "宁静的山间黎明景色" --duration 5 --quality 720p

# 带参考图
./scripts/seedance-gen.sh "轻柔的海浪" --image "https://example.com/beach.jpg" --duration 8 --quality 1080p

# 竖版（社交媒体）
./scripts/seedance-gen.sh "舞动的粒子" --aspect-ratio 9:16 --duration 4 --quality 720p

# 无音频
./scripts/seedance-gen.sh "抽象艺术动画" --duration 6 --quality 720p --no-audio
```

### API 参数

完整 API 文档见 [references/api-params.md](references/api-params.md)。

---

## 文件结构

```
.
├── README.md                    # English
├── README.zh-CN.md              # 本文件
├── SKILL.md                     # OpenClaw 技能定义
├── _meta.json                   # 技能元数据
├── references/
│   └── api-params.md            # 完整 API 参数文档
└── scripts/
    └── seedance-gen.sh          # 视频生成脚本
```

---

## 常见问题

| 问题 | 解决方案 |
|------|---------|
| `jq: command not found` | 安装 jq：`apt install jq` / `brew install jq` |
| `401 Unauthorized` | 检查 `EVOLINK_API_KEY`，在 [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 确认 |
| `402 Payment Required` | 在 [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 充值 |
| 内容被拦截 | 真实人脸受限 — 修改提示词 |
| 生成超时 | 视频生成需 30–180 秒，先试低分辨率 |

---

## 更多技能

更多 EvoLink 技能正在开发中。关注更新或 [提出需求](https://github.com/EvoLinkAI/evolink-skills/issues)。

---

## 从 ClawHub 下载

你也可以直接从 ClawHub 安装此技能：

👉 **[在 ClawHub 下载 →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## 许可证

MIT

---

<p align="center">
  由 <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> 提供支持 — 统一 AI API 网关
</p>
