# Seedance 2 Video Gen Skill for OpenClaw

<p align="center">
  <strong>适用于 OpenClaw、Claude Code、OpenCode、Cursor 的 Seedance 2.0 AI 视频生成技能包 —— 一条命令安装。</strong>
</p>

<p align="center">
  <a href="#seedance-视频生成">Seedance 2.0</a> •
  <a href="#安装">安装</a> •
  <a href="#获取-api-key">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>语言:</strong>
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">简体中文</a>
</p>

---

## 这是什么？

这是一个基于 [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw) 的 [OpenClaw](https://github.com/openclaw/openclaw) / [Claude Code](https://github.com/anthropics/claude-code) / [OpenCode](https://github.com/opencode-ai/opencode) 技能包。安装后，你的 AI Agent 就可以直接调用 Seedance 2.0 生成视频，支持三种核心工作流：

| 技能 | 描述 | 模型 |
|------|------|------|
| **Seedance 2 Video Gen** | 文生视频、图生视频、参考生视频、自动音频 | Seedance 2.0（字节跳动） |

### 能做什么

- **文生视频**：描述场景直接生成视频
- **图生视频**：基于 1–2 张参考图做动画
- **参考生视频**：组合图片、视频、音频做重混、编辑或延长
- **自动音频**：自动生成配音、音效、背景音乐
- **灵活输出**：支持 4–15 秒、480p/720p、多种比例

📚 完整指南： [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide)

---

## 安装

### 快速安装（OpenClaw）

```bash
openclaw skills add https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw
```

### 通过 npm 安装（推荐）

```bash
npx evolink-seedance
```

或使用非交互模式（适合 AI Agent / CI）：

```bash
npx evolink-seedance -y
```

安装到指定目录：

```bash
npx evolink-seedance -y --path ~/.claude/skills
```

### 手动安装

```bash
git clone https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw.git
cd seedance2-video-gen-skill-for-openclaw
openclaw skills add .
```

---

## 获取 API Key

1. 在 [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw) 注册
2. 进入 Dashboard → API Keys
3. 创建一个新的 Key
4. 设置环境变量：

```bash
export EVOLINK_API_KEY=your_key_here
```

---

## Seedance 视频生成

你可以直接通过和 Agent 对话来生成 AI 视频。

### 示例提示词

> “生成一个 5 秒的猫弹钢琴电影感视频”

> “把这张产品图做成一个 720p、16:9 的短广告视频”

> “用这张图和这个视频片段作参考，把场景延长，并加上环境音乐”

### 直接脚本调用

```bash
# 文生视频
./scripts/seedance-gen.sh "A serene sunset over ocean waves" --duration 5 --quality 720p

# 图生视频
./scripts/seedance-gen.sh "The camera slowly pushes in" --image "https://example.com/scene.jpg" --duration 6 --quality 720p

# 参考生视频
./scripts/seedance-gen.sh "Replace the product with image 1" --image "https://example.com/product.jpg" --video "https://example.com/original.mp4" --duration 5 --quality 720p
```

### 环境要求

- 系统已安装 `curl` 和 `jq`
- 已设置 `EVOLINK_API_KEY`

### 文件结构

```text
.
├── README.md
├── README.zh-CN.md
├── SKILL.md
├── _meta.json
├── bin/
│   └── cli.js
├── references/
│   └── api-params.md
└── scripts/
    └── seedance-gen.sh
```

---

## 故障排查

| 问题 | 检查项 |
|------|--------|
| `401 Unauthorized` | 检查 shell 里的 `EVOLINK_API_KEY` |
| `402 Payment Required` | 去 EvoLink 控制台充值 |
| 没有输出文件 | 检查返回的视频 URL 和任务状态 |
| 安装路径不对 | 用 `--path <skills-dir>` 重新安装 |

---

<p align="center">
  Powered by <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — 统一 AI API 网关
</p>
