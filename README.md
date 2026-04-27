# GPT Image 2 Gen Skill for OpenClaw

<p align="center">
  <strong>AI image generation with GPT Image 2 — install in one command, start creating in seconds.</strong>
</p>

<p align="center">
  <a href="#gpt-image-2-generation">GPT Image 2</a> •
  <a href="#installation">Install</a> •
  <a href="#getting-an-api-key">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>Languages:</strong>
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">简体中文</a>
</p>

---

> **AI Agent?** Skip the README — go straight to [**llms-install.md**](llms-install.md) for step-by-step installation instructions designed for you.

---

## What is This?

An [OpenClaw](https://github.com/openclaw/openclaw) / [Claude Code](https://github.com/anthropics/claude-code) / [OpenCode](https://github.com/opencode-ai/opencode) skill powered by [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen). Install the skill and your AI agent gains the ability to generate and edit images using GPT Image 2.

| Skill | Description | Model |
|-------|-------------|-------|
| **GPT Image 2 Gen** | Text-to-image, image editing, batch generation | GPT Image 2 (OpenAI) |

---

## Installation

### Quick Install (OpenClaw)

```bash
openclaw skills add https://github.com/EvoLinkAI/gpt-image-2-gen-skill-for-openclaw
```

### Install via npm (Recommended)

```bash
npx evolink-gpt-image
```

Or non-interactive (for AI agents / CI):

```bash
npx evolink-gpt-image -y
```

Install to a specific directory:

```bash
npx evolink-gpt-image -y --path ~/.claude/skills
```

### Manual Install

```bash
git clone https://github.com/EvoLinkAI/gpt-image-2-gen-skill-for-openclaw.git
cd gpt-image-2-gen-skill-for-openclaw
openclaw skills add .
```

### Agent Auto-Install (Copy & Paste to Your Agent)

Tell your AI agent the following prompt, and it will install the skill automatically:

#### Claude Code

```
Install the GPT Image 2 generation skill by running:

npx evolink-gpt-image@latest -y --path ~/.claude/skills

After installation, set the API key:

export EVOLINK_API_KEY=your_key_here

Then read the skill file at ~/.claude/skills/gpt-image-2-gen/SKILL.md to learn how to use it.
```

#### OpenCode

```
Install the GPT Image 2 generation skill by running:

npx evolink-gpt-image@latest -y --path ~/.opencode/skills

After installation, set the API key:

export EVOLINK_API_KEY=your_key_here

Then read the skill file at ~/.opencode/skills/gpt-image-2-gen/SKILL.md to learn how to use it.
```

#### OpenClaw

```
Install the GPT Image 2 generation skill by running:

npx evolink-gpt-image@latest -y

The installer will auto-detect your OpenClaw skills directory. After installation, set the API key:

export EVOLINK_API_KEY=your_key_here
```

#### One-Liner (Any Agent)

For agents that support shell commands, this single command installs and verifies in one step:

```bash
EVOLINK_API_KEY=your_key_here npx evolink-gpt-image@latest -y --path ~/.claude/skills
```

Replace `~/.claude/skills` with `~/.opencode/skills` or your agent's skill directory.

---

## Getting an API Key

1. Sign up at [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen-skill-for-openclaw)
2. Go to Dashboard -> API Keys
3. Create a new key
4. Set it in your environment:

```bash
export EVOLINK_API_KEY=your_key_here
```

Or tell your AI agent: *"Set my EvoLink API key to ..."* — it will handle the rest.

---

## GPT Image 2 Generation

Generate and edit AI images through natural conversation with your AI agent.

### What It Can Do

- **Text-to-image** — Describe what you want, get an image
- **Image editing** — Provide reference images (1-16) and describe edits
- **Batch generation** — Generate up to 10 images per request
- **Multiple sizes** — 15 ratio presets + custom pixel dimensions
- **Resolution tiers** — 1K (~1MP), 2K (~4MP), 4K (~8.3MP)
- **Quality levels** — Low (fast), Medium (balanced), High (best)
- **Prompt power** — Up to 32,000 characters per prompt

### Usage Examples

Just talk to your agent:

> "Generate an image of a sunset over the ocean"

> "Create a minimalist logo, 1024x1024, high quality"

> "Edit this image — add a cat next to the person"

> "Generate 4 variations of a pixel art robot in 4K"

The agent will guide you through any missing details and handle the generation.

### Requirements

- `curl` and `jq` installed on your system
- `EVOLINK_API_KEY` environment variable set

### Script Reference

The skill includes `scripts/gpt-image-gen.sh` for direct command-line use:

```bash
# Text-to-image (basic)
./scripts/gpt-image-gen.sh "A beautiful sunset over the ocean"

# High quality 4K widescreen
./scripts/gpt-image-gen.sh "Cinematic cityscape at dusk" --size 16:9 --resolution 4K --quality high

# Custom pixel dimensions
./scripts/gpt-image-gen.sh "Minimalist logo" --size 1024x1024

# Image editing
./scripts/gpt-image-gen.sh "Add a cat next to her" --image "https://example.com/photo.png"

# Batch generation
./scripts/gpt-image-gen.sh "Pixel art robot" --count 4 --quality high

# Dry run (preview payload)
./scripts/gpt-image-gen.sh "Test prompt" --dry-run
```

### API Parameters

See [references/api-params.md](references/api-params.md) for complete API documentation.

---

## File Structure

```
.
├── README.md                    # This file
├── SKILL.md                     # Skill definition (for AI agents)
├── _meta.json                   # Skill metadata
├── bin/
│   └── cli.js                   # npm installer CLI
├── references/
│   └── api-params.md            # Complete API parameter reference
└── scripts/
    └── gpt-image-gen.sh         # Image generation script
```

---

## Troubleshooting

| Issue | Solution |
|-------|---------|
| `jq: command not found` | Install jq: `apt install jq` / `brew install jq` |
| `401 Unauthorized` | Check your `EVOLINK_API_KEY` at [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen) |
| `402 Payment Required` | Add credits at [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen) |
| `Content blocked` | Prompt flagged by moderation — modify your description |
| Image too large | Reference images must be <=50MB each |
| Generation timeout | Images can take 5-90s. Try lower quality/resolution first. |

---

## Compatibility

| Agent | Install Method |
|-------|---------------|
| **OpenClaw** | `openclaw skills add <repo>` or `npx evolink-gpt-image` |
| **Claude Code** | `npx evolink-gpt-image -y --path ~/.claude/skills` |
| **OpenCode** | `npx evolink-gpt-image -y --path ~/.opencode/skills` |
| **Cursor** | `npx evolink-gpt-image -y --path <your-skills-dir>` |

---

## License

MIT

---

<p align="center">
  Powered by <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=gpt-image-2-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — Unified AI API Gateway
</p>
