# Seedance 2 Video Gen Skill for OpenClaw

<p align="center">
  <strong>Seedance 2.0 AI video generation for OpenClaw, Claude Code, OpenCode, and Cursor — install in one command.</strong>
</p>

<p align="center">
  <a href="#seedance-video-generation">Seedance 2.0</a> •
  <a href="#installation">Install</a> •
  <a href="#getting-an-api-key">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>Languages:</strong>
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">简体中文</a>
</p>

---

## What is This?

An [OpenClaw](https://github.com/openclaw/openclaw) / [Claude Code](https://github.com/anthropics/claude-code) / [OpenCode](https://github.com/opencode-ai/opencode) skill powered by [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw). Install the skill and your AI agent gains Seedance 2.0 video generation with three core workflows:

| Skill | Description | Model |
|-------|-------------|-------|
| **Seedance 2 Video Gen** | Text-to-video, image-to-video, reference-to-video, auto audio | Seedance 2.0 (ByteDance) |

### What It Can Do

- **Text-to-video** — describe a scene and generate a video
- **Image-to-video** — animate from 1–2 reference images
- **Reference-to-video** — combine images, video clips, and audio for remix, editing, or extension
- **Auto audio** — generate voice, sound effects, and background music
- **Flexible output** — 4–15 seconds, 480p/720p, multiple aspect ratios

📚 Full guide: [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide)

---

## Installation

### Quick Install (OpenClaw)

```bash
openclaw skills add https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw
```

### Install via npm (Recommended)

```bash
npx evolink-seedance
```

Or non-interactive (for AI agents / CI):

```bash
npx evolink-seedance -y
```

Install to a specific directory:

```bash
npx evolink-seedance -y --path ~/.claude/skills
```

### Manual Install

```bash
git clone https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw.git
cd seedance2-video-gen-skill-for-openclaw
openclaw skills add .
```

---

## Getting an API Key

1. Sign up at [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw)
2. Go to Dashboard → API Keys
3. Create a new key
4. Set it in your environment:

```bash
export EVOLINK_API_KEY=your_key_here
```

---

## Seedance Video Generation

Generate AI videos through natural conversation with your agent.

### Example Prompts

> "Generate a 5-second cinematic video of a cat playing piano"

> "Animate this product image into a short ad, 720p, 16:9"

> "Use this image and this clip as references, then extend the scene with ambient music"

### Direct Script Usage

```bash
# Text-to-video
./scripts/seedance-gen.sh "A serene sunset over ocean waves" --duration 5 --quality 720p

# Image-to-video
./scripts/seedance-gen.sh "The camera slowly pushes in" --image "https://example.com/scene.jpg" --duration 6 --quality 720p

# Reference-to-video
./scripts/seedance-gen.sh "Replace the product with image 1" --image "https://example.com/product.jpg" --video "https://example.com/original.mp4" --duration 5 --quality 720p
```

### Requirements

- `curl` and `jq` installed on your system
- `EVOLINK_API_KEY` environment variable set

### File Structure

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

## Troubleshooting

| Issue | What to check |
|------|---------------|
| `401 Unauthorized` | Verify `EVOLINK_API_KEY` in your shell |
| `402 Payment Required` | Add credits in the EvoLink dashboard |
| No output file | Check the returned video URL and task status |
| Bad install path | Re-run with `--path <skills-dir>` |

---

<p align="center">
  Powered by <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — Unified AI API Gateway
</p>
