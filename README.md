# Seedance 2 Video Gen Skill for OpenClaw

<p align="center">
  <strong>AI video generation and more — install in one command, start creating in seconds.</strong>
</p>

<p align="center">
  <a href="#seedance-video-generation">Seedance 2.0</a> •
  <a href="#installation">Install</a> •
  <a href="#getting-an-api-key">API Key</a> •
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

## What is This?

A collection of [OpenClaw](https://github.com/openclaw/openclaw) skills powered by [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen). Install a skill and your AI agent gains new capabilities — generate videos, process media, and more.

Currently available:

| Skill | Description | Model |
|-------|-------------|-------|
| **Seedance Video Gen** | Text-to-video, image-to-video, reference-to-video with auto audio | Seedance 2.0 (ByteDance) |

📚 **Complete Guide**: [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — Prompts, use cases, and capabilities showcase

🔌 **API Guide**: [Seedance-2.0-API](https://github.com/EvoLinkAI/Seedance-2.0-API) — pricing, models, endpoint docs, and integration examples

More skills coming soon.

---

## Installation

### Quick Install (Recommended)

```bash
openclaw skills add https://github.com/EvoLinkAI/evolink-skills
```

That's it. The skill is now available to your agent.

### Manual Install

```bash
git clone https://github.com/EvoLinkAI/evolink-skills.git
cd evolink-skills
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

Or tell your OpenClaw agent: *"Set my EvoLink API key to ..."* — it will handle the rest.

---

## Seedance Video Generation

Generate AI videos through natural conversation with your OpenClaw agent.

### What It Can Do

- **Text-to-video** — Describe a scene, get a video (with optional web search)
- **Image-to-video** — 1 image: animate from first frame; 2 images: first + last frame interpolation
- **Reference-to-video** — Combine images, video clips, and audio to create, edit, or extend video
- **Auto audio** — Synchronized voice, sound effects, and background music
- **Multiple resolutions** — 480p, 720p
- **Flexible duration** — 4–15 seconds
- **Aspect ratios** — 16:9, 9:16, 1:1, 4:3, 3:4, 21:9, adaptive

### Usage Examples

Just talk to your agent:

> "Generate a 5-second video of a cat playing piano"

> "Create a cinematic sunset over the ocean, 720p, 16:9"

> "Use this image as reference and animate it into a 8-second video"

> "Edit this video clip — replace the item with my product image"

The agent will guide you through any missing details and handle the generation.

### Requirements

- `curl` and `jq` installed on your system
- `EVOLINK_API_KEY` environment variable set

### Script Reference

The skill includes `scripts/seedance-gen.sh` for direct command-line use:

```bash
# Text-to-video
./scripts/seedance-gen.sh "A serene mountain landscape at dawn" --duration 5 --quality 720p

# Image-to-video (animate from first frame)
./scripts/seedance-gen.sh "Gentle ocean waves" --image "https://example.com/beach.jpg" --duration 8 --quality 720p

# Reference-to-video (edit a video clip with an image)
./scripts/seedance-gen.sh "Replace the item with the product from image 1" --image "https://example.com/product.jpg" --video "https://example.com/clip.mp4" --duration 5 --quality 720p

# Vertical format for social media
./scripts/seedance-gen.sh "Dancing particles" --aspect-ratio 9:16 --duration 4 --quality 720p

# Without audio
./scripts/seedance-gen.sh "Abstract art animation" --duration 6 --quality 720p --no-audio
```

### API Parameters

See [references/api-params.md](references/api-params.md) for complete API documentation.

---

## File Structure

```
.
├── README.md                    # This file
├── SKILL.md                     # OpenClaw skill definition
├── _meta.json                   # Skill metadata
├── references/
│   └── api-params.md            # Complete API parameter reference
└── scripts/
    └── seedance-gen.sh          # Video generation script
```

---

## Troubleshooting

| Issue | Solution |
|-------|---------|
| `jq: command not found` | Install jq: `apt install jq` / `brew install jq` |
| `401 Unauthorized` | Check your `EVOLINK_API_KEY` at [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) |
| `402 Payment Required` | Add credits at [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) |
| `Content blocked` | Realistic human faces are restricted — modify your prompt |
| Video file too large | Reference videos must be ≤50MB each, total duration ≤15s |
| Generation timeout | Videos can take 30–180s depending on settings. Try lower quality first. |

---

## More Skills

We're adding more EvoLink-powered skills. Stay tuned or [request a skill](https://github.com/EvoLinkAI/evolink-skills/issues).

---

## Download from ClawHub

You can also install this skill directly from ClawHub:

👉 **[Download on ClawHub →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## License

MIT

---

<p align="center">
  Powered by <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — Unified AI API Gateway
</p>

