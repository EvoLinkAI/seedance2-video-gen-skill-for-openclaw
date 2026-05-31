#!/bin/bash

# Seedance 2.0 Video Generation Script
# Usage: ./seedance-gen.sh "prompt" [options]
# Models: text-to-video | image-to-video | reference-to-video (auto-detected)
# Requires: jq, curl
# API endpoint: https://api.evolink.ai (hardcoded, not configurable)

set -euo pipefail

# Constants
readonly API_BASE="https://api.evolink.ai"
readonly MAX_POLL_SECONDS=600
readonly POLL_FAST_INTERVAL=5
readonly POLL_SLOW_INTERVAL=10
readonly POLL_SLOW_AFTER=30
readonly PROGRESS_INTERVAL=30   # print STATUS_UPDATE every N seconds

# Default values
DURATION=5
QUALITY="720p"
ASPECT_RATIO="16:9"
GENERATE_AUDIO="true"
IMAGE_URLS=""
VIDEO_URLS=""
AUDIO_URLS=""
WEB_SEARCH="false"
CALLBACK_URL=""
EXPLICIT_MODE=""
SELECTED_MODEL=""
PROMPT=""
GLOBAL_TASK_ID=""
GLOBAL_ESTIMATED_TIME=120

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${BLUE}INFO: $1${NC}"
}

success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
}

warn() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Check dependencies
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        error "jq is required but not installed. Install it with:
  apt install jq   # Debian/Ubuntu
  brew install jq   # macOS"
    fi
    if ! command -v curl &> /dev/null; then
        error "curl is required but not installed."
    fi
}

# Check API key
check_api_key() {
    if [[ -z "${EVOLINK_API_KEY:-}" ]]; then
        error "EVOLINK_API_KEY environment variable is required.

To get started:
1. Register at: https://evolink.ai
2. Get your API key from the dashboard
3. Set the environment variable:
   export EVOLINK_API_KEY=your_key_here"
    fi
}

# Parse command line arguments
parse_args() {
    if [[ $# -eq 0 ]]; then
        error "Usage: $0 \"prompt\" [options]

Models (auto-detected from inputs, or use --mode to override):
  text:      no media inputs       -> seedance-2.0-text-to-video
  image:     1-2 images            -> seedance-2.0-image-to-video
  reference: videos/audio/3+ imgs  -> seedance-2.0-reference-to-video

Options:
  --image <url[,url]>         Reference images (comma-separated; 1-2 for image mode, 0-9 for reference)
  --video <url>               Reference video URL (repeatable, 0-3, reference mode only)
  --audio <url>               Reference audio URL (repeatable, 0-3, reference mode only)
  --duration <4-15>           Video duration in seconds (default: 5)
  --quality <480p|720p>       Video resolution (default: 720p)
  --aspect-ratio <ratio>      16:9, 9:16, 1:1, 4:3, 3:4, 21:9, adaptive (default: 16:9)
  --no-audio                  Disable auto-generated audio
  --web-search                Enable web search for enhanced timeliness (text mode only)
  --callback <https://...>    HTTPS callback URL for async notification
  --mode <text|image|reference>  Force model selection (overrides auto-detection)

Examples:
  $0 \"A serene sunset over ocean waves\"
  $0 \"Dancing cat\" --duration 4 --quality 480p
  $0 \"Beach scene\" --image \"url1.jpg,url2.jpg\" --aspect-ratio adaptive
  $0 \"Extend this clip\" --video \"https://example.com/clip.mp4\" --duration 10
  $0 \"Add music\" --image \"url.jpg\" --audio \"https://example.com/bgm.mp3\""
    fi

    PROMPT="$1"
    shift

    while [[ $# -gt 0 ]]; do
        case $1 in
            --image)
                IMAGE_URLS="$2"
                shift 2
                ;;
            --video)
                if [[ -n "$VIDEO_URLS" ]]; then
                    VIDEO_URLS="$VIDEO_URLS $2"
                else
                    VIDEO_URLS="$2"
                fi
                shift 2
                ;;
            --audio)
                if [[ -n "$AUDIO_URLS" ]]; then
                    AUDIO_URLS="$AUDIO_URLS $2"
                else
                    AUDIO_URLS="$2"
                fi
                shift 2
                ;;
            --duration)
                DURATION="$2"
                if [[ ! "$DURATION" =~ ^[0-9]+$ ]] || [[ "$DURATION" -lt 4 ]] || [[ "$DURATION" -gt 15 ]]; then
                    error "Duration must be between 4-15 seconds"
                fi
                shift 2
                ;;
            --quality)
                QUALITY="$2"
                if [[ ! "$QUALITY" =~ ^(480p|720p)$ ]]; then
                    error "Quality must be 480p or 720p"
                fi
                shift 2
                ;;
            --aspect-ratio)
                ASPECT_RATIO="$2"
                if [[ ! "$ASPECT_RATIO" =~ ^(16:9|9:16|1:1|4:3|3:4|21:9|adaptive)$ ]]; then
                    error "Aspect ratio must be one of: 16:9, 9:16, 1:1, 4:3, 3:4, 21:9, adaptive"
                fi
                shift 2
                ;;
            --no-audio)
                GENERATE_AUDIO="false"
                shift
                ;;
            --web-search)
                WEB_SEARCH="true"
                shift
                ;;
            --callback)
                CALLBACK_URL="$2"
                if [[ ! "$CALLBACK_URL" =~ ^https:// ]]; then
                    error "Callback URL must use HTTPS protocol"
                fi
                shift 2
                ;;
            --mode)
                EXPLICIT_MODE="$2"
                if [[ ! "$EXPLICIT_MODE" =~ ^(text|image|reference)$ ]]; then
                    error "Mode must be one of: text, image, reference"
                fi
                shift 2
                ;;
            *)
                error "Unknown parameter: $1"
                ;;
        esac
    done
}

# Select model based on inputs (auto-detect or explicit mode)
select_model() {
    local img_count=0
    local vid_count=0
    local audio_count=0

    if [[ -n "$IMAGE_URLS" ]]; then
        IFS=',' read -ra _imgs <<< "$IMAGE_URLS"
        img_count=${#_imgs[@]}
    fi

    if [[ -n "$VIDEO_URLS" ]]; then
        read -ra _vids <<< "$VIDEO_URLS"
        vid_count=${#_vids[@]}
    fi

    if [[ -n "$AUDIO_URLS" ]]; then
        read -ra _auds <<< "$AUDIO_URLS"
        audio_count=${#_auds[@]}
    fi

    # Select model
    if [[ -n "$EXPLICIT_MODE" ]]; then
        case "$EXPLICIT_MODE" in
            text)      SELECTED_MODEL="seedance-2.0-text-to-video" ;;
            image)     SELECTED_MODEL="seedance-2.0-image-to-video" ;;
            reference) SELECTED_MODEL="seedance-2.0-reference-to-video" ;;
        esac
    elif [[ $vid_count -gt 0 || $audio_count -gt 0 || $img_count -gt 2 ]]; then
        SELECTED_MODEL="seedance-2.0-reference-to-video"
    elif [[ $img_count -ge 1 && $img_count -le 2 ]]; then
        SELECTED_MODEL="seedance-2.0-image-to-video"
    else
        SELECTED_MODEL="seedance-2.0-text-to-video"
    fi

    # Cross-validation
    case "$SELECTED_MODEL" in
        "seedance-2.0-text-to-video")
            if [[ $img_count -gt 0 || $vid_count -gt 0 || $audio_count -gt 0 ]]; then
                error "Text-to-video mode does not accept image, video, or audio inputs. Use --mode image or --mode reference instead."
            fi
            ;;
        "seedance-2.0-image-to-video")
            if [[ $img_count -lt 1 || $img_count -gt 2 ]]; then
                error "Image-to-video mode requires 1-2 images (1 for first-frame, 2 for first+last-frame). Got $img_count images."
            fi
            if [[ $vid_count -gt 0 || $audio_count -gt 0 ]]; then
                error "Image-to-video mode does not accept video or audio inputs. Use --mode reference instead."
            fi
            ;;
        "seedance-2.0-reference-to-video")
            if [[ $img_count -eq 0 && $vid_count -eq 0 ]]; then
                error "Reference-to-video mode requires at least 1 image or 1 video."
            fi
            if [[ $img_count -gt 9 ]]; then
                error "Reference-to-video supports up to 9 images. Got $img_count."
            fi
            if [[ $vid_count -gt 3 ]]; then
                error "Reference-to-video supports up to 3 videos. Got $vid_count."
            fi
            if [[ $audio_count -gt 3 ]]; then
                error "Reference-to-video supports up to 3 audio files. Got $audio_count."
            fi
            ;;
    esac

    # Warn if web_search used with non-text model
    if [[ "$WEB_SEARCH" == "true" && "$SELECTED_MODEL" != "seedance-2.0-text-to-video" ]]; then
        warn "web_search is only supported by text-to-video model; ignoring."
        WEB_SEARCH="false"
    fi
}

# Build JSON payload safely using jq (no shell injection)
build_payload() {
    local json_payload

    # Base payload (common to all models)
    json_payload=$(jq -n \
        --arg model "$SELECTED_MODEL" \
        --arg prompt "$PROMPT" \
        --argjson duration "$DURATION" \
        --arg quality "$QUALITY" \
        --arg aspect_ratio "$ASPECT_RATIO" \
        --argjson generate_audio "$GENERATE_AUDIO" \
        '{model: $model, prompt: $prompt, duration: $duration, quality: $quality, aspect_ratio: $aspect_ratio, generate_audio: $generate_audio}')

    # Add image_urls (image and reference models)
    if [[ -n "$IMAGE_URLS" ]]; then
        local url_array="[]"
        IFS=',' read -ra URLS <<< "$IMAGE_URLS"
        for url in "${URLS[@]}"; do
            url=$(echo "$url" | xargs)  # trim whitespace
            url_array=$(echo "$url_array" | jq --arg u "$url" '. + [$u]')
        done
        json_payload=$(echo "$json_payload" | jq --argjson urls "$url_array" '. + {image_urls: $urls}')
    fi

    # Add video_urls (reference model)
    if [[ -n "$VIDEO_URLS" ]]; then
        local vid_array="[]"
        read -ra VIDS <<< "$VIDEO_URLS"
        for url in "${VIDS[@]}"; do
            url=$(echo "$url" | xargs)
            vid_array=$(echo "$vid_array" | jq --arg u "$url" '. + [$u]')
        done
        json_payload=$(echo "$json_payload" | jq --argjson urls "$vid_array" '. + {video_urls: $urls}')
    fi

    # Add audio_urls (reference model)
    if [[ -n "$AUDIO_URLS" ]]; then
        local aud_array="[]"
        read -ra AUDS <<< "$AUDIO_URLS"
        for url in "${AUDS[@]}"; do
            url=$(echo "$url" | xargs)
            aud_array=$(echo "$aud_array" | jq --arg u "$url" '. + [$u]')
        done
        json_payload=$(echo "$json_payload" | jq --argjson urls "$aud_array" '. + {audio_urls: $urls}')
    fi

    # Add model_params.web_search (text model only)
    if [[ "$WEB_SEARCH" == "true" ]]; then
        json_payload=$(echo "$json_payload" | jq '. + {model_params: {web_search: true}}')
    fi

    # Add callback_url (all models, optional)
    if [[ -n "$CALLBACK_URL" ]]; then
        json_payload=$(echo "$json_payload" | jq --arg url "$CALLBACK_URL" '. + {callback_url: $url}')
    fi

    echo "$json_payload"
}

# Handle API errors with user-friendly messages
handle_error() {
    local status_code=$1
    local response_body=$2

    case $status_code in
        401)
            error "Invalid API key.
-> Check your key at: https://evolink.ai/dashboard"
            ;;
        402)
            error "Insufficient account balance.
-> Add credits at: https://evolink.ai/dashboard"
            ;;
        429)
            error "Rate limit exceeded. Please wait a few seconds and try again."
            ;;
        503)
            error "Service temporarily unavailable. Please try again later."
            ;;
        400)
            local error_msg
            error_msg=$(echo "$response_body" | jq -r '.error // .message // empty' 2>/dev/null || echo "")
            if echo "$error_msg" | grep -qi "face\|人脸"; then
                error "Content blocked: Realistic faces not supported.
-> Please modify your prompt to avoid human faces."
            elif echo "$error_msg" | grep -qi "video.*large\|video.*size\|size.*exceed"; then
                error "File size error: Videos must be <=50MB each. Total video input must be <=15 seconds."
            elif echo "$error_msg" | grep -qi "file.*large\|image.*size"; then
                error "File size error: Images must be <=30MB each."
            else
                error "Request error (400): ${error_msg:-$response_body}"
            fi
            ;;
        *)
            error "API error ($status_code): $response_body"
            ;;
    esac
}

# Submit generation request
submit_generation() {
    local payload
    payload=$(build_payload)

    # Minimal output -- only final result matters

    local http_code response_body
    response_body=$(curl --fail-with-body --show-error --silent \
        --connect-timeout 15 --max-time 30 \
        -w "\n%{http_code}" \
        -X POST "${API_BASE}/v1/videos/generations" \
        -H "Authorization: Bearer ${EVOLINK_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$payload" 2>&1) || true

    http_code=$(echo "$response_body" | tail -n1)
    response_body=$(echo "$response_body" | sed '$d')

    if [[ "$http_code" != "200" ]]; then
        handle_error "$http_code" "$response_body"
    fi

    # Extract task_id using jq
    local task_id
    task_id=$(echo "$response_body" | jq -r '.id // .task_id // empty' 2>/dev/null)

    if [[ -z "$task_id" ]]; then
        error "Failed to extract task_id from response: $response_body"
    fi

    GLOBAL_TASK_ID="$task_id"

    # Extract estimated_time for progress messages
    local estimated_time
    estimated_time=$(echo "$response_body" | jq -r '.task_info.estimated_time // 120' 2>/dev/null)
    GLOBAL_ESTIMATED_TIME="${estimated_time:-120}"

    # Signal to the AI agent that the task is queued — MUST NOT retry after this line
    echo "TASK_SUBMITTED: task_id=${task_id} estimated=${GLOBAL_ESTIMATED_TIME}s"
}

# Poll task status
# Prints STATUS_UPDATE lines every PROGRESS_INTERVAL seconds so AI agents
# (e.g. OpenClaw / 小龙虾) can relay live progress to the user.
# Final output lines: VIDEO_URL=<url>  ELAPSED=<Ns>
poll_task() {
    local task_id=$1
    local estimated_time=${2:-$GLOBAL_ESTIMATED_TIME}
    local start_time
    start_time=$(date +%s)
    local poll_interval=$POLL_FAST_INTERVAL
    local last_progress_report=-1

    while true; do
        local current_time elapsed
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))

        if [[ $elapsed -gt $MAX_POLL_SECONDS ]]; then
            echo "POLL_TIMEOUT: task_id=${task_id}"
            warn "Polling timed out after $((MAX_POLL_SECONDS / 60)) minutes. The video may still be processing on the server."
            warn "Check your dashboard: https://evolink.ai/dashboard"
            exit 1
        fi

        if [[ $elapsed -gt $POLL_SLOW_AFTER ]]; then
            poll_interval=$POLL_SLOW_INTERVAL
        fi

        # Emit a progress update every PROGRESS_INTERVAL seconds
        local progress_bucket=$(( elapsed / PROGRESS_INTERVAL ))
        if [[ $progress_bucket -gt $last_progress_report && $elapsed -ge $PROGRESS_INTERVAL ]]; then
            last_progress_report=$progress_bucket
            local remaining=$(( estimated_time - elapsed ))
            if [[ $remaining -gt 0 ]]; then
                echo "STATUS_UPDATE: Video is still generating... (${elapsed}s elapsed, ~${remaining}s remaining)"
            else
                echo "STATUS_UPDATE: Video is still generating, almost there... (${elapsed}s elapsed)"
            fi
        fi

        sleep "$poll_interval"

        local http_code response_body poll_attempts=0
        # Retry the status check up to 3 times on network error before giving up
        while [[ $poll_attempts -lt 3 ]]; do
            response_body=$(curl --fail-with-body --show-error --silent \
                --connect-timeout 15 --max-time 60 \
                -w "\n%{http_code}" \
                -X GET "${API_BASE}/v1/tasks/${task_id}" \
                -H "Authorization: Bearer ${EVOLINK_API_KEY}" 2>&1) || true

            http_code=$(echo "$response_body" | tail -n1)
            response_body=$(echo "$response_body" | sed '$d')

            # Valid HTTP response — break out of retry loop
            if [[ "$http_code" =~ ^[0-9]{3}$ ]]; then
                break
            fi

            # Network error / curl timeout — retry immediately (no sleep)
            poll_attempts=$(( poll_attempts + 1 ))
            echo "STATUS_UPDATE: Network hiccup, retrying status check (attempt ${poll_attempts}/3)... (${elapsed}s elapsed)"
        done

        # Still no valid response after 3 attempts — skip this cycle
        if [[ ! "$http_code" =~ ^[0-9]{3}$ ]]; then
            echo "STATUS_UPDATE: Could not reach status API, will retry next cycle... (${elapsed}s elapsed)"
            continue
        fi

        if [[ "$http_code" != "200" ]]; then
            handle_error "$http_code" "$response_body"
        fi

        local task_status
        task_status=$(echo "$response_body" | jq -r '.status // empty' 2>/dev/null)

        case "$task_status" in
            "completed")
                local video_url
                video_url=$(echo "$response_body" | jq -r '
                    (.results // [])[0] //
                    .video_url //
                    .url //
                    empty
                ' 2>/dev/null)

                if [[ -n "$video_url" && "$video_url" != "null" ]]; then
                    echo "VIDEO_URL=$video_url"
                    echo "ELAPSED=${elapsed}s"
                    return 0
                else
                    error "Task completed but no video URL found in response: $response_body"
                fi
                ;;
            "failed")
                local error_msg
                error_msg=$(echo "$response_body" | jq -r '.error // "Unknown error"' 2>/dev/null)
                error "Generation failed: $error_msg"
                ;;
            "processing"|"pending")
                : # progress handled above
                ;;
            "")
                echo "STATUS_UPDATE: Empty status in response, raw: $(echo "$response_body" | head -c 200) (${elapsed}s elapsed)"
                ;;
            *)
                # Unexpected status — log it and treat as still-in-progress
                echo "STATUS_UPDATE: Unexpected status '${task_status}', continuing to poll... (${elapsed}s elapsed)"
                ;;
        esac
    done
}

# Main execution
main() {
    check_dependencies
    check_api_key
    parse_args "$@"
    select_model

    submit_generation
    poll_task "$GLOBAL_TASK_ID" "$GLOBAL_ESTIMATED_TIME"
}

main "$@"
