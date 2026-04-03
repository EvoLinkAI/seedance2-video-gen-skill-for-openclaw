---
name: seedance-2-video-gen
description: Seedance 2.0 AI video generation via EvoLink API. Three modes — text-to-video, image-to-video (1-2 images), reference-to-video (images + videos + audio). Auto audio (voice, SFX, BGM). Works with OpenClaw, Claude Code, Cursor. Powered by ByteDance Seedance 2.0.
homepage: https://github.com/EvoLinkAI/evolink-skills
metadata: {"openclaw":{"homepage":"https://github.com/EvoLinkAI/evolink-skills","requires":{"bins":["jq","curl"],"env":["EVOLINK_API_KEY"]},"primaryEnv":"EVOLINK_API_KEY"}}
---

# Seedance Video Generation

An interactive AI video generation assistant powered by the Seedance 2.0 model via EvoLink API.

## After Installation

When this skill is first loaded, proactively greet the user and start the setup:

1. Check if `EVOLINK_API_KEY` is set
   - **If not set:** "To generate videos, you'll need an EvoLink API key. It takes 30 seconds to get one — just sign up at evolink.ai/signup. Want me to walk you through it?"
   - **If already set:** "You're all set! What kind of video would you like to create?"

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

- **Intent is clear** (e.g., "generate a video of a cat dancing") → Go to Step 3
- **Intent is ambiguous** (e.g., "I want to try Seedance") → Ask what they'd like to do: generate a new video, learn about model capabilities, etc.

### Step 3: Gather Missing Information

Check what the user has already provided and **only ask about what's missing**:

| Parameter | What to tell the user | Required? |
|-----------|----------------------|-----------|
| **Mode / intent** | Three modes available: (1) **Text-to-video** — describe a scene, get a video; (2) **Image-to-video** — animate from 1-2 reference photos; (3) **Reference-to-video** — remix/edit/extend using images, video clips, and audio. Determine which mode fits from context, or ask if unclear. | Yes |
| **Video content** (prompt) | Ask what they'd like to see. If they need inspiration, suggest a few ideas for them to pick from or build on. | Yes |
| **Duration** | Supported: **4–15 seconds**. Ask how long they want. | Yes |
| **Resolution** | Supported: **480p** / **720p**. Ask their preference. | Yes |
| **Audio** | The model can auto-generate **voice, sound effects, and background music** matching the video. Ask if they want audio enabled. | Yes |
| **Aspect ratio** | Supported: 16:9, 9:16, 1:1, 4:3, 3:4, 21:9, **adaptive** (model chooses best fit). Only mention if relevant or if user asks. | Optional |
| **Reference images** | Image-to-video: 1–2 images (JPEG/PNG/WebP, ≤30MB each). 1 image = first-frame animation; 2 images = first+last frame interpolation. Reference mode: 0–9 images. | Conditional |
| **Reference videos** | Reference mode only: 0–3 videos (.mp4/.mov, 2–15s each, total ≤15s, ≤50MB each). Use for camera reference, motion reference, or as source video for editing/extension. | Conditional |
| **Reference audio** | Reference mode only: 0–3 audio files (.wav/.mp3, 2–15s each, total ≤15s, ≤15MB each). Use for background music, sound effects, or voice reference. | Conditional |
| **Web search** | Text mode only: enables the model to search the web for enhanced timeliness (e.g., current weather, trending topics). Only mention if the user's prompt involves time-sensitive content. | Optional |

**Smart gathering rules — STRICT:**
- **Ask ALL missing parameters in ONE single message.** Never split into multiple rounds of questions.
- **Never ask the same question twice.** If the user already answered a parameter, it is final — do not re-ask it.
- **Offer defaults upfront** so users can say "default is fine": `5s / 720p / audio on / 16:9`. If the user says "default" or "just go", use these values immediately.
- User gives everything at once → Confirm and generate immediately, no further questions.
- User gives partial info → Ask only the remaining missing required fields, all in one message.
- If user provides images/videos/audio, auto-detect the appropriate mode — no need to ask explicitly.
- **Duration, Resolution, Audio** all have sensible defaults — if the user skips them, use defaults and proceed.

### Step 4: Generate

Once all required information is confirmed:

1. Tell the user: "Generating your video now — this usually takes 30–120 seconds. I'll let you know when it's ready."
2. Run the generation script **once**. **NEVER run it a second time** unless the user explicitly asks to retry.
3. Watch stdout for structured lines and act accordingly (see **Script Output Protocol** below).
4. When complete, share the video URL (valid for 24 hours) and generation time.

## Script Usage

```bash
# Set API key
export EVOLINK_API_KEY=your_key_here

# Text-to-video (basic)
./scripts/seedance-gen.sh "A serene sunset over ocean waves" --duration 5 --quality 720p

# Text-to-video with web search (time-sensitive content)
./scripts/seedance-gen.sh "Today's weather in Tokyo with animated forecast" --duration 8 --quality 720p --web-search

# Image-to-video: 1 image (animate from first frame)
./scripts/seedance-gen.sh "The camera slowly zooms in, the scene comes to life" --image "https://example.com/scene.jpg" --duration 6 --quality 720p

# Image-to-video: 2 images (first + last frame interpolation)
./scripts/seedance-gen.sh "A smooth transition between day and night" --image "https://example.com/day.jpg,https://example.com/night.jpg" --duration 8 --quality 720p

# Reference-to-video: edit a video clip
./scripts/seedance-gen.sh "Replace the item in the box with the product from image 1" --image "https://example.com/product.jpg" --video "https://example.com/original.mp4" --duration 5 --quality 720p

# Reference-to-video: extend/remix with audio
./scripts/seedance-gen.sh "Continue the scene with this background music" --video "https://example.com/clip.mp4" --audio "https://example.com/bgm.mp3" --duration 10 --quality 720p

# Adaptive aspect ratio (model chooses best fit)
./scripts/seedance-gen.sh "A tall waterfall in a narrow canyon" --aspect-ratio adaptive --duration 5 --quality 720p

# Without audio
./scripts/seedance-gen.sh "Abstract art animation" --duration 6 --quality 720p --no-audio

# Force specific mode
./scripts/seedance-gen.sh "Remix these elements" --mode reference --image "url1" --video "url2" --duration 8 --quality 720p
```

## Script Output Protocol

The script writes structured lines to stdout that you must parse and act on:

| Line format | When | Your action |
|-------------|------|-------------|
| `TASK_SUBMITTED: task_id=<id> estimated=<Ns>` | Right after submission | **Confirm to the user that generation has started.** This means the API call succeeded — do NOT retry. |
| `STATUS_UPDATE: <message>` | Every ~30s during generation | **Relay to the user** — e.g., *"Still working on your video, about 45 seconds remaining..."* |
| `VIDEO_URL=<url>` | On success | Extract the URL and present the video to the user |
| `ELAPSED=<Ns>` | On success | Optionally mention how long it took |
| `WARNING: ...` | On timeout (>10 min) | Inform user generation may still be running, suggest checking back |
| `ERROR: ...` (stderr) | On failure | Surface the error message to the user |

**Critical**: Once you see `TASK_SUBMITTED:`, the task is queued on the server. **Do NOT run the script again.** Retrying wastes the user's API credits. If the script times out locally, the video may still complete — tell the user to check their dashboard at https://evolink.ai/dashboard.

## Error Handling

Provide friendly, actionable messages:

| Error | What to tell the user |
|-------|----------------------|
| Invalid/missing key (401) | "Your API key doesn't seem to work. You can check it at https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw" |
| Insufficient balance (402) | "Your account balance is low. You can add credits at https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw" |
| Rate limited (429) | "Too many requests — let's wait a moment and try again" |
| Content blocked (400) | "This prompt was flagged (realistic human faces are restricted). Try adjusting the description" |
| Video file too large (400) | "One of the video files is too large. Each video must be ≤50MB and total video duration ≤15 seconds" |
| Image file too large (400) | "One of the images is too large. Each image must be ≤30MB" |
| Service unavailable (503) | "The service is temporarily busy. Let's try again in a minute" |

## Model Capabilities Summary

Use this when the user asks what the model can do:

- **Text-to-video** (`seedance-2.0-text-to-video`): Describe a scene, get a video. Optional web search for time-sensitive content.
- **Image-to-video** (`seedance-2.0-image-to-video`): 1 image = animate from first frame; 2 images = first+last frame interpolation.
- **Reference-to-video** (`seedance-2.0-reference-to-video`): Multimodal — combine images (0–9), video clips (0–3), audio (0–3), and a text prompt to create, edit, or extend video. Use natural language in the prompt to reference inputs by number.
- **Audio generation**: Auto-generates synchronized voice, sound effects, and background music (enabled by default).
- **Duration**: 4–15 seconds
- **Resolution**: 480p, 720p
- **Aspect ratios**: 16:9, 9:16, 1:1, 4:3, 3:4, 21:9, adaptive
- **Limitation**: Realistic human faces are restricted

## References

- `references/api-params.md`: Complete API parameter reference for all three models
- `scripts/seedance-gen.sh`: Generation script with automatic model selection, polling, and error handling
