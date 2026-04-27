---
name: gpt-image-2-gen
description: GPT Image 2 AI image generation via EvoLink API. Supports text-to-image, image-to-image editing, batch generation. Multiple sizes (ratio & pixel), resolutions (1K/2K/4K), quality levels (low/medium/high). Works with OpenClaw, Claude Code, OpenCode, Cursor. Powered by OpenAI GPT Image 2.
homepage: https://github.com/EvoLinkAI/gpt-image-2-gen-skill-for-openclaw
metadata: {"openclaw":{"homepage":"https://github.com/EvoLinkAI/gpt-image-2-gen-skill-for-openclaw","requires":{"bins":["jq","curl"],"env":["EVOLINK_API_KEY"]},"primaryEnv":"EVOLINK_API_KEY"}}
---

# GPT Image 2 Generation

An interactive AI image generation assistant powered by the GPT Image 2 model via EvoLink API.

## When to Activate This Skill

Activate this skill when the user asks to:
- Generate / create / make an image or picture
- Edit / modify an existing image
- Use GPT Image 2 or gpt-image-2
- Create AI art, illustrations, logos, icons, or any visual content
- Batch-generate image variations

Keywords: image, picture, illustration, photo, art, logo, icon, generate image, create image, image editing, gpt-image, text-to-image

## Script Location

**IMPORTANT**: All script paths in this file are relative to the directory containing this SKILL.md file. Before running any script, resolve the absolute path:

```
SKILL_DIR = directory containing this SKILL.md file
Script = {SKILL_DIR}/scripts/gpt-image-gen.sh
```

For example, if this SKILL.md is at `~/.claude/skills/gpt-image-2-gen/SKILL.md`, then the script is at `~/.claude/skills/gpt-image-2-gen/scripts/gpt-image-gen.sh`.

## After Installation

When this skill is first loaded, proactively greet the user and start the setup:

1. Check if `EVOLINK_API_KEY` is set (run: `echo $EVOLINK_API_KEY`)
   - **If not set:** "To generate images, you'll need an EvoLink API key. It takes 30 seconds to get one — just sign up at evolink.ai/signup. Want me to walk you through it?"
   - **If already set:** "You're all set! What kind of image would you like to create?"

2. That's it. One question. The user is now in the flow.

Do NOT list features, show a menu, or dump instructions. Just ask one question to move forward.

## Core Principles

1. **Guide, don't decide** — Present options and let the user decide. Don't make assumptions about their preferences.
2. **Let the user drive the creative vision** — If they have an idea, use their words. If they need inspiration, offer suggestions and let them choose or refine.
3. **Smart context awareness** — Recognize what the user has already provided and only ask about missing pieces.
4. **Intent first** — If the user's intent is unclear, confirm what they want before proceeding.

## Flow

### Step 1: Check for API Key

If the user hasn't provided an API key or set `EVOLINK_API_KEY`:

- Tell them they need an EvoLink API Key
- Guide them to register at https://evolink.ai and get a key from the dashboard
- Once they provide a key, proceed to Step 2

If the key is already set or provided, skip directly to Step 2.

### Step 2: Understand Intent

Assess what the user wants based on their message:

- **Intent is clear** (e.g., "generate an image of a sunset") -> Go to Step 3
- **Intent is ambiguous** (e.g., "I want to try GPT Image 2") -> Ask what they'd like to do: generate a new image, edit an existing image, learn about model capabilities, etc.

### Step 3: Gather Missing Information

Check what the user has already provided and **only ask about what's missing**:

| Parameter | What to tell the user | Required? |
|-----------|----------------------|-----------|
| **Mode / intent** | Two modes available: (1) **Text-to-image** — describe what you want, get an image; (2) **Image editing** — provide reference image(s) and describe the edits. Determine which mode fits from context, or ask if unclear. | Yes |
| **Image content** (prompt) | Ask what they'd like to see. If they need inspiration, suggest a few ideas for them to pick from or build on. Max 32,000 characters. | Yes |
| **Size** | Supports ratio format (1:1, 16:9, 9:16, etc.) or exact pixels (e.g. 1024x1024). Default: `auto` (model decides). Only mention if relevant. | Optional |
| **Resolution** | When using ratio format: `1K` (~1MP), `2K` (~4MP), `4K` (~8.3MP). Default: `1K`. Only mention for high-quality needs. | Optional |
| **Quality** | `low` (fast, cheap), `medium` (balanced, default), `high` (best, ~4x cost). Only mention if relevant. | Optional |
| **Count** | How many images to generate (1-10). Default: 1. Only ask if the user implies wanting multiple variants. | Optional |
| **Reference images** | For image editing: 1-16 images (JPEG/PNG/WebP, <=50MB each). Ask for URLs if editing mode is detected. | Conditional |

**Smart gathering rules — STRICT:**
- **Ask ALL missing parameters in ONE single message.** Never split into multiple rounds of questions.
- **Never ask the same question twice.** If the user already answered a parameter, it is final — do not re-ask it.
- **Offer defaults upfront** so users can say "default is fine": `1:1 / 1K / medium quality / 1 image`. If the user says "default" or "just go", use these values immediately.
- User gives everything at once -> Confirm and generate immediately, no further questions.
- User gives partial info -> Ask only the remaining missing required fields, all in one message.
- If user provides image URLs, auto-detect editing mode — no need to ask explicitly.
- **Size, Resolution, Quality, Count** all have sensible defaults — if the user skips them, use defaults and proceed.

### Step 4: Generate

Once all required information is confirmed:

1. **Before running the script**, immediately tell the user: "Got it! Starting your image now — this usually takes 15-60 seconds. I'll keep you posted while it generates."
2. Run the generation script **once**. **NEVER run it a second time** unless the user explicitly asks to retry.
3. When complete, share the image URL(s) (valid for 24 hours) and generation time.

#### Execution Pattern by Agent

**Claude Code** — use the Bash tool with `run_in_background: true`, then read the output file to check progress:

```
# Step 1: Run in background (resolves SKILL_DIR first)
Bash(command: "{SKILL_DIR}/scripts/gpt-image-gen.sh \"prompt\" --size 1:1 --quality medium", run_in_background: true, timeout: 300000)

# Step 2: Wait ~30 seconds, then read the background task output file to check for IMAGE_URL= or STATUS_UPDATE lines

# Step 3: When you see IMAGE_URL=<url>, relay it to the user
```

**OpenClaw / OpenCode / Cursor** — run the script as a blocking shell command (the script handles its own polling internally, typically completes in 15-120 seconds):

```bash
EVOLINK_API_KEY=$EVOLINK_API_KEY {SKILL_DIR}/scripts/gpt-image-gen.sh "prompt" --size 1:1 --quality medium
```

**All agents — critical rules:**
- Once you see `TASK_SUBMITTED:` in the output, the task is **already queued on the server**. Do NOT run the script again — retrying wastes the user's API credits.
- The script blocks until the image is ready (up to 5 minutes). Do NOT kill it prematurely.
- If the script times out with `POLL_TIMEOUT`, the image may still be processing — tell the user to check https://evolink.ai/dashboard.

## Script Usage

**Remember**: Replace `{SKILL_DIR}` with the actual directory containing this SKILL.md file.

```bash
# Set API key
export EVOLINK_API_KEY=your_key_here

# Text-to-image (basic)
{SKILL_DIR}/scripts/gpt-image-gen.sh "A beautiful sunset over the ocean"

# Text-to-image with high quality and 4K resolution
{SKILL_DIR}/scripts/gpt-image-gen.sh "Cinematic wide-angle shot of a futuristic city skyline at dusk" --size 16:9 --resolution 4K --quality high

# Text-to-image with exact pixel size
{SKILL_DIR}/scripts/gpt-image-gen.sh "Minimalist logo design" --size 1024x1024 --quality medium

# Image editing (add elements to existing image)
{SKILL_DIR}/scripts/gpt-image-gen.sh "Add a cute kitten next to her" --image "https://example.com/input.png" --size 1:1

# Batch generation (multiple variants)
{SKILL_DIR}/scripts/gpt-image-gen.sh "Pixel art cute robot" --size 1:1 --resolution 2K --quality high --count 4

# With callback URL
{SKILL_DIR}/scripts/gpt-image-gen.sh "Abstract landscape painting" --callback "https://your-domain.com/webhook/image-done"
```

## Script Output Protocol

The script writes structured lines to stdout that you must parse and act on:

| Line format | When | Your action |
|-------------|------|-------------|
| `TASK_SUBMITTED: task_id=<id> estimated=<Ns>` | Right after submission | **Confirm to the user that generation has started.** This means the API call succeeded — do NOT retry. |
| `STATUS_UPDATE: <message>` | Every ~15s during generation | **Relay to the user** — e.g., *"Still working on your image, about 30 seconds remaining..."* |
| `IMAGE_URL=<url>` | On success (one line per image) | Extract the URL and present the image to the user |
| `ELAPSED=<Ns>` | On success | Optionally mention how long it took |
| `POLL_TIMEOUT: task_id=<id> dashboard=<url>` | Polling exceeded 5 min | Tell user: "Your image may already be done — check <dashboard_url> (task: `<id>`)" |
| `ERROR: ...` (stderr) | On failure | Surface the error message to the user |

**Critical**: Once you see `TASK_SUBMITTED:`, the task is queued on the server. **Do NOT run the script again.** Retrying wastes the user's API credits. If the script times out locally, the image may still complete — tell the user to check their dashboard at https://evolink.ai/dashboard.

## Error Handling

Provide friendly, actionable messages:

| Error | What to tell the user |
|-------|----------------------|
| Invalid/missing key (401) | "Your API key doesn't seem to work. You can check it at https://evolink.ai/dashboard" |
| Insufficient balance (402) | "Your account balance is low. You can add credits at https://evolink.ai/dashboard" |
| Rate limited (429) | "Too many requests — let's wait a moment and try again" |
| Content blocked (400) | "This prompt was flagged by content moderation. Try adjusting the description" |
| Image file too large (400) | "One of the images is too large. Each image must be <=50MB" |
| Service unavailable (503) | "The service is temporarily busy. Let's try again in a minute" |

## Model Capabilities Summary

Use this when the user asks what the model can do:

- **Text-to-image**: Describe what you want, get an image. Supports prompts up to 32,000 characters.
- **Image editing**: Provide 1-16 reference images and describe the edits you want.
- **Sizes**: 15 ratio presets (1:1, 16:9, 9:16, 2:1, 3:2, 4:3, 5:4, etc.) + exact pixel format (WxH, 16-aligned, 16-3840px per side)
- **Resolution**: 1K (~1MP), 2K (~4MP), 4K (~8.3MP) — only with ratio sizes
- **Quality**: low (fast/cheap), medium (balanced), high (best/4x cost)
- **Batch**: Generate 1-10 images per request
- **Output**: Images valid for 24 hours, save promptly

## References

- `references/api-params.md`: Complete API parameter reference
- `scripts/gpt-image-gen.sh`: Generation script with automatic polling and error handling
