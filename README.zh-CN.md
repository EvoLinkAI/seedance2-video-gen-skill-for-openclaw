# GPT Image 2 图像生成技能

<p align="center">
  <strong>GPT Image 2 AI 图像生成 — 一条命令安装，秒级上手。</strong>
</p>

<p align="center">
  <a href="#gpt-image-2-图像生成">GPT Image 2</a> •
  <a href="#安装">安装</a> •
  <a href="#获取-api-key">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>Languages:</strong>
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">简体中文</a>
</p>

---

> **AI Agent?** 跳过 README — 直接看 [**llms-install.md**](llms-install.md)，里面有专为 Agent 设计的安装步骤。

---

## 这是什么？

一个适用于 [OpenClaw](https://github.com/openclaw/openclaw) / [Claude Code](https://github.com/anthropics/claude-code) / [OpenCode](https://github.com/opencode-ai/opencode) 的 AI 技能插件，由 [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen) 驱动。安装后，你的 AI Agent 即可使用 GPT Image 2 模型进行图像生成和编辑。

| 技能 | 描述 | 模型 |
|------|------|------|
| **GPT Image 2 Gen** | 文生图、图像编辑、批量生成 | GPT Image 2 (OpenAI) |

---

## 安装

### 快速安装（OpenClaw）

```bash
openclaw skills add https://github.com/EvoLinkAI/gpt-image-2-gen-skill-for-openclaw
```

### 通过 npm 安装（推荐）

```bash
npx evolink-gpt-image
```

非交互模式（适用于 AI Agent / CI）：

```bash
npx evolink-gpt-image -y
```

安装到指定目录：

```bash
npx evolink-gpt-image -y --path ~/.claude/skills
```

### 手动安装

```bash
git clone https://github.com/EvoLinkAI/gpt-image-2-gen-skill-for-openclaw.git
cd gpt-image-2-gen-skill-for-openclaw
openclaw skills add .
```

### Agent 自动安装（复制粘贴给你的 Agent）

将以下提示词发送给你的 AI Agent，它会自动完成安装：

#### Claude Code

```
安装 GPT Image 2 图像生成技能，运行以下命令：

npx evolink-gpt-image@latest -y --path ~/.claude/skills

安装完成后设置 API Key：

export EVOLINK_API_KEY=你的key

然后读取 ~/.claude/skills/gpt-image-2-gen/SKILL.md 了解使用方法。
```

#### OpenCode

```
安装 GPT Image 2 图像生成技能，运行以下命令：

npx evolink-gpt-image@latest -y --path ~/.opencode/skills

安装完成后设置 API Key：

export EVOLINK_API_KEY=你的key

然后读取 ~/.opencode/skills/gpt-image-2-gen/SKILL.md 了解使用方法。
```

#### OpenClaw

```
安装 GPT Image 2 图像生成技能，运行以下命令：

npx evolink-gpt-image@latest -y

安装器会自动检测 OpenClaw 技能目录。安装完成后设置 API Key：

export EVOLINK_API_KEY=你的key
```

#### 一行命令（任意 Agent）

```bash
EVOLINK_API_KEY=你的key npx evolink-gpt-image@latest -y --path ~/.claude/skills
```

将 `~/.claude/skills` 替换为你的 Agent 的技能目录（如 `~/.opencode/skills`）。

---

## 获取 API Key

1. 注册 [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen-skill-for-openclaw)
2. 进入控制台 -> API Keys
3. 创建新密钥
4. 设置环境变量：

```bash
export EVOLINK_API_KEY=your_key_here
```

---

## GPT Image 2 图像生成

通过自然语言对话生成和编辑 AI 图像。

### 功能

- **文生图** — 描述你想要的，生成图像
- **图像编辑** — 提供参考图片（1-16张），描述编辑内容
- **批量生成** — 单次请求最多生成 10 张图像
- **多种尺寸** — 15 种比例预设 + 自定义像素尺寸
- **分辨率等级** — 1K (~1百万像素)、2K (~4百万像素)、4K (~830万像素)
- **质量等级** — low (快速)、medium (平衡)、high (最佳)
- **超长提示词** — 单次最多 32,000 字符

### 使用示例

直接和你的 AI Agent 对话：

> "生成一张海面日落的图片"

> "创建一个极简 Logo，1024x1024，高质量"

> "编辑这张图片 — 在人物旁边加一只猫"

> "生成 4 张像素风格机器人的变体，4K 分辨率"

### 系统要求

- 系统已安装 `curl` 和 `jq`
- 已设置 `EVOLINK_API_KEY` 环境变量

### 命令行脚本

```bash
# 文生图（基础）
./scripts/gpt-image-gen.sh "海面上绚丽多彩的美丽日落"

# 高质量 4K 宽屏
./scripts/gpt-image-gen.sh "黄昏时分未来都市天际线" --size 16:9 --resolution 4K --quality high

# 自定义像素尺寸
./scripts/gpt-image-gen.sh "极简主义 Logo 设计" --size 1024x1024

# 图像编辑
./scripts/gpt-image-gen.sh "在她旁边加一只可爱的小猫" --image "https://example.com/photo.png"

# 批量生成
./scripts/gpt-image-gen.sh "像素风格的可爱机器人" --count 4 --quality high
```

---

## 兼容性

| Agent | 安装方式 |
|-------|----------|
| **OpenClaw** | `openclaw skills add <repo>` 或 `npx evolink-gpt-image` |
| **Claude Code** | `npx evolink-gpt-image -y --path ~/.claude/skills` |
| **OpenCode** | `npx evolink-gpt-image -y --path ~/.opencode/skills` |
| **Cursor** | `npx evolink-gpt-image -y --path <你的技能目录>` |

---

## 许可证

MIT

---

<p align="center">
  Powered by <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — 统一 AI API 网关
</p>
