# GPT Image 2 Skill — Agent Installation Guide

You are an AI agent. Follow these steps to install the GPT Image 2 image generation skill.

## Step 1: Install

Run this command (silent mode, no user interaction needed):

```bash
npx evolink-gpt-image@latest -y --path {SKILLS_DIR}
```

Replace `{SKILLS_DIR}` with your skills directory:

| Agent | SKILLS_DIR |
|-------|-----------|
| Claude Code | `~/.claude/skills` |
| OpenCode | `~/.opencode/skills` |
| OpenClaw | omit `--path` (auto-detected) |
| Cursor | project `.cursor/skills` or `~/.cursor/skills` |
| Other | ask the user where to install |

## Step 2: Set API Key

Check if `EVOLINK_API_KEY` is already set:

```bash
echo $EVOLINK_API_KEY
```

If empty, ask the user for their EvoLink API key. They can get one at https://evolink.ai/signup

Once they provide it, set it for the current session:

```bash
export EVOLINK_API_KEY=their_key_here
```

## Step 3: Load the Skill Definition

Run this command to get the complete skill definition (interaction flow, script usage, output protocol):

```bash
npx evolink-gpt-image@latest --skill
```

Read the output carefully — it tells you exactly how to handle user requests for image generation and editing.

Alternatively, read the installed file directly:

```
{SKILLS_DIR}/gpt-image-2-gen/SKILL.md
```

## Quick Verify

Test that the script works:

```bash
EVOLINK_API_KEY=$EVOLINK_API_KEY {SKILLS_DIR}/gpt-image-2-gen/scripts/gpt-image-gen.sh "a red circle on white background" --size 1:1 --quality low --dry-run
```

If you see a JSON payload with `"model": "gpt-image-2"`, the installation is correct.

## One-Liner (If User Provides API Key Upfront)

```bash
EVOLINK_API_KEY=their_key npx evolink-gpt-image@latest -y --path {SKILLS_DIR}
```

This installs the skill AND verifies the API key in one step.

## Available Commands

| Command | Purpose |
|---------|---------|
| `npx evolink-gpt-image --llms` | Print this installation guide |
| `npx evolink-gpt-image --skill` | Print the SKILL.md (skill definition) |
| `npx evolink-gpt-image -y --path <dir>` | Silent install to a directory |
| `npx evolink-gpt-image --help` | Show all options |
| `npx evolink-gpt-image --version` | Show version |
