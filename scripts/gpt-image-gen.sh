#!/bin/bash

# GPT Image 2 Image Generation Script
# Usage: ./gpt-image-gen.sh "prompt" [options]
# Requires: jq, curl
# API endpoint: https://api.evolink.ai (hardcoded, not configurable)

set -euo pipefail

# Constants
readonly API_BASE="https://api.evolink.ai"
readonly MAX_POLL_SECONDS=300
readonly POLL_FAST_INTERVAL=3
readonly POLL_SLOW_INTERVAL=8
readonly POLL_SLOW_AFTER=20
readonly PROGRESS_INTERVAL=15   # print STATUS_UPDATE every N seconds

# Default values
SIZE="auto"
RESOLUTION=""
QUALITY="medium"
COUNT=1
IMAGE_URLS=""
CALLBACK_URL=""
PROMPT=""
GLOBAL_TASK_ID=""
GLOBAL_ESTIMATED_TIME=60
DRY_RUN="false"

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

Options:
  --image <url[,url,...]>       Reference image URLs (comma-separated, 1-16 for editing)
  --size <ratio|WxH|auto>       Image size: ratio (1:1, 16:9, ...), pixels (1024x1024), or auto (default: auto)
  --resolution <1K|2K|4K>       Resolution tier, only with ratio sizes (default: 1K)
  --quality <low|medium|high>   Render quality (default: medium)
  --count <1-10>                Number of images to generate (default: 1)
  --callback <https://...>      HTTPS callback URL for async notification
  --dry-run                     Print the JSON payload without sending the request

Examples:
  $0 \"A beautiful sunset over the ocean\"
  $0 \"Futuristic cityscape\" --size 16:9 --resolution 4K --quality high
  $0 \"Minimalist logo\" --size 1024x1024
  $0 \"Add a cat next to her\" --image \"https://example.com/photo.png\"
  $0 \"Pixel art robot\" --count 4 --quality high"
    fi

    PROMPT="$1"
    shift

    while [[ $# -gt 0 ]]; do
        case $1 in
            --image)
                IMAGE_URLS="$2"
                shift 2
                ;;
            --size)
                SIZE="$2"
                shift 2
                ;;
            --resolution)
                RESOLUTION="$2"
                if [[ ! "$RESOLUTION" =~ ^(1K|2K|4K)$ ]]; then
                    error "Resolution must be 1K, 2K, or 4K"
                fi
                shift 2
                ;;
            --quality)
                QUALITY="$2"
                if [[ ! "$QUALITY" =~ ^(low|medium|high)$ ]]; then
                    error "Quality must be low, medium, or high"
                fi
                shift 2
                ;;
            --count)
                COUNT="$2"
                if [[ ! "$COUNT" =~ ^[0-9]+$ ]] || [[ "$COUNT" -lt 1 ]] || [[ "$COUNT" -gt 10 ]]; then
                    error "Count must be between 1-10"
                fi
                shift 2
                ;;
            --callback)
                CALLBACK_URL="$2"
                if [[ ! "$CALLBACK_URL" =~ ^https:// ]]; then
                    error "Callback URL must use HTTPS protocol"
                fi
                shift 2
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            *)
                error "Unknown parameter: $1"
                ;;
        esac
    done
}

# Validate size parameter
validate_size() {
    if [[ "$SIZE" == "auto" ]]; then
        return 0
    fi

    # Ratio format: N:M
    if [[ "$SIZE" =~ ^[0-9]+:[0-9]+$ ]]; then
        local valid_ratios="1:1 1:2 2:1 1:3 3:1 2:3 3:2 3:4 4:3 4:5 5:4 9:16 16:9 9:21 21:9"
        if ! echo "$valid_ratios" | grep -qw "$SIZE"; then
            error "Invalid ratio. Supported: $valid_ratios"
        fi
        return 0
    fi

    # Pixel format: WxH or W×H
    if [[ "$SIZE" =~ ^([0-9]+)[x×]([0-9]+)$ ]]; then
        local w="${BASH_REMATCH[1]}"
        local h="${BASH_REMATCH[2]}"
        if (( w % 16 != 0 || h % 16 != 0 )); then
            error "Width and height must be multiples of 16. Got ${w}x${h}"
        fi
        if (( w < 16 || w > 3840 || h < 16 || h > 3840 )); then
            error "Each dimension must be between 16-3840 pixels. Got ${w}x${h}"
        fi
        local pixels=$(( w * h ))
        if (( pixels < 655360 || pixels > 8294400 )); then
            error "Pixel budget must be 655,360-8,294,400. Got ${pixels} (${w}x${h})"
        fi
        # When pixel format is used, resolution is ignored
        if [[ -n "$RESOLUTION" ]]; then
            warn "Resolution is ignored when using pixel format. Using ${w}x${h} directly."
            RESOLUTION=""
        fi
        return 0
    fi

    error "Invalid size format. Use ratio (e.g. 16:9), pixels (e.g. 1024x1024), or 'auto'"
}

# Build JSON payload safely using jq (no shell injection)
build_payload() {
    local json_payload

    # Base payload
    json_payload=$(jq -n \
        --arg model "gpt-image-2" \
        --arg prompt "$PROMPT" \
        --arg size "$SIZE" \
        --arg quality "$QUALITY" \
        --argjson n "$COUNT" \
        '{model: $model, prompt: $prompt, size: $size, quality: $quality, n: $n}')

    # Add resolution (only if set and size is ratio format)
    if [[ -n "$RESOLUTION" ]]; then
        json_payload=$(echo "$json_payload" | jq --arg res "$RESOLUTION" '. + {resolution: $res}')
    fi

    # Add image_urls (for image editing)
    if [[ -n "$IMAGE_URLS" ]]; then
        local url_array="[]"
        IFS=',' read -ra URLS <<< "$IMAGE_URLS"
        for url in "${URLS[@]}"; do
            url=$(echo "$url" | xargs)  # trim whitespace
            url_array=$(echo "$url_array" | jq --arg u "$url" '. + [$u]')
        done
        json_payload=$(echo "$json_payload" | jq --argjson urls "$url_array" '. + {image_urls: $urls}')
    fi

    # Add callback_url (optional)
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
        403)
            local error_msg
            error_msg=$(echo "$response_body" | jq -r '.error.message // .message // empty' 2>/dev/null || echo "")
            error "Access denied: ${error_msg:-Token does not have access to model gpt-image-2}
-> Check your API key permissions at: https://evolink.ai/dashboard"
            ;;
        429)
            error "Rate limit exceeded. Please wait a few seconds and try again."
            ;;
        503)
            error "Service temporarily unavailable. Please try again later."
            ;;
        400)
            local error_msg
            error_msg=$(echo "$response_body" | jq -r '.error.message // .error // .message // empty' 2>/dev/null || echo "")
            if echo "$error_msg" | grep -qi "content\|moderat\|blocked\|policy"; then
                error "Content blocked by moderation.
-> Please modify your prompt to comply with content policy."
            elif echo "$error_msg" | grep -qi "file.*large\|image.*size\|size.*exceed"; then
                error "File size error: Images must be <=50MB each."
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

    # --dry-run: print payload and exit without sending
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "DRY_RUN: model=gpt-image-2"
        echo "$payload" | jq .
        exit 0
    fi

    info "Submitting image generation request (model=gpt-image-2, size=${SIZE}, quality=${QUALITY}, count=${COUNT})..."

    local http_code response_body
    response_body=$(curl --fail-with-body --show-error --silent \
        --connect-timeout 15 --max-time 30 \
        -w "\n%{http_code}" \
        -X POST "${API_BASE}/v1/images/generations" \
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
    task_id=$(echo "$response_body" | jq -r '.id // .task_id // empty' 2>/dev/null || true)

    if [[ -z "$task_id" ]]; then
        error "Failed to extract task_id from response: $response_body"
    fi

    GLOBAL_TASK_ID="$task_id"

    # Extract estimated_time for progress messages
    local estimated_time
    estimated_time=$(echo "$response_body" | jq -r '.task_info.estimated_time // 60' 2>/dev/null || true)
    GLOBAL_ESTIMATED_TIME="${estimated_time:-60}"

    # Signal to the AI agent that the task is queued — MUST NOT retry after this line
    echo "TASK_SUBMITTED: task_id=${task_id} estimated=${GLOBAL_ESTIMATED_TIME}s"
}

# Poll task status
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
            echo "POLL_TIMEOUT: task_id=${task_id} dashboard=https://evolink.ai/dashboard"
            warn "Polling timed out after $((MAX_POLL_SECONDS / 60)) minutes. The image may still be processing on the server."
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
                echo "STATUS_UPDATE: Image is still generating... (${elapsed}s elapsed, ~${remaining}s remaining)"
            else
                echo "STATUS_UPDATE: Image is still generating, almost there... (${elapsed}s elapsed)"
            fi
        fi

        sleep "$poll_interval"

        local http_code response_body poll_attempts=0
        while [[ $poll_attempts -lt 3 ]]; do
            response_body=$(curl --fail-with-body --show-error --silent \
                --connect-timeout 10 --max-time 10 \
                -w "\n%{http_code}" \
                -X GET "${API_BASE}/v1/tasks/${task_id}" \
                -H "Authorization: Bearer ${EVOLINK_API_KEY}" 2>&1) || true

            http_code=$(echo "$response_body" | tail -n1)
            response_body=$(echo "$response_body" | sed '$d')

            if [[ "$http_code" =~ ^[0-9]{3}$ ]]; then
                break
            fi

            poll_attempts=$(( poll_attempts + 1 ))
            echo "STATUS_UPDATE: Network hiccup, retrying status check (attempt ${poll_attempts}/3)... (${elapsed}s elapsed)"
        done

        if [[ ! "$http_code" =~ ^[0-9]{3}$ ]]; then
            echo "STATUS_UPDATE: Could not reach status API, will retry next cycle... (${elapsed}s elapsed)"
            continue
        fi

        if [[ "$http_code" != "200" ]]; then
            handle_error "$http_code" "$response_body"
        fi

        local task_status
        task_status=$(echo "$response_body" | jq -r '.status // empty' 2>/dev/null || true)

        case "$task_status" in
            "completed"|"succeed"|"success"|"done")
                # Extract image URLs from results array
                local result_count
                result_count=$(echo "$response_body" | jq -r '.results | length' 2>/dev/null || echo "0")

                if [[ "$result_count" -gt 0 ]]; then
                    local i=0
                    while [[ $i -lt $result_count ]]; do
                        local img_url=""

                        # Try: results[i] is a bare string
                        img_url=$(echo "$response_body" | jq -r ".results[$i] | select(type==\"string\")" 2>/dev/null || true)

                        # Try: results[i] is an object with .url or .image_url
                        if [[ -z "$img_url" || "$img_url" == "null" ]]; then
                            img_url=$(echo "$response_body" | jq -r ".results[$i].url // .results[$i].image_url // empty" 2>/dev/null || true)
                        fi

                        if [[ -n "$img_url" && "$img_url" != "null" ]]; then
                            echo "IMAGE_URL=$img_url"
                        fi

                        i=$(( i + 1 ))
                    done

                    echo "ELAPSED=${elapsed}s"
                    echo "RESULT_JSON=$(echo "$response_body" | jq -c '.' 2>/dev/null || echo '{}')"
                    return 0
                fi

                # Fallback: top-level url fields
                local fallback_url
                fallback_url=$(echo "$response_body" | jq -r '.image_url // .url // empty' 2>/dev/null || true)
                if [[ -n "$fallback_url" && "$fallback_url" != "null" ]]; then
                    echo "IMAGE_URL=$fallback_url"
                    echo "ELAPSED=${elapsed}s"
                    return 0
                fi

                # Retry once for eventual consistency
                sleep 2
                local retry_body
                retry_body=$(curl --fail-with-body --show-error --silent \
                    --connect-timeout 10 --max-time 10 \
                    -X GET "${API_BASE}/v1/tasks/${task_id}" \
                    -H "Authorization: Bearer ${EVOLINK_API_KEY}" 2>&1 | sed '$d' || true)

                local retry_count
                retry_count=$(echo "$retry_body" | jq -r '.results | length' 2>/dev/null || echo "0")
                if [[ "$retry_count" -gt 0 ]]; then
                    local j=0
                    while [[ $j -lt $retry_count ]]; do
                        local rurl=""
                        rurl=$(echo "$retry_body" | jq -r ".results[$j] | select(type==\"string\")" 2>/dev/null || true)
                        if [[ -z "$rurl" || "$rurl" == "null" ]]; then
                            rurl=$(echo "$retry_body" | jq -r ".results[$j].url // .results[$j].image_url // empty" 2>/dev/null || true)
                        fi
                        if [[ -n "$rurl" && "$rurl" != "null" ]]; then
                            echo "IMAGE_URL=$rurl"
                        fi
                        j=$(( j + 1 ))
                    done
                    echo "ELAPSED=${elapsed}s"
                    return 0
                fi

                echo "TASK_COMPLETED_NO_URL: task_id=${task_id}"
                echo "RESULT_JSON=$(echo "$response_body" | jq -c '.' 2>/dev/null || echo '{}')"
                error "Task completed but no image URL found. See RESULT_JSON above for raw response."
                ;;
            "failed")
                local error_msg
                error_msg=$(echo "$response_body" | jq -r '.error // "Unknown error"' 2>/dev/null || true)
                echo "RESULT_JSON=$(echo "$response_body" | jq -c '.' 2>/dev/null || echo '{}')"
                error "Generation failed: $error_msg"
                ;;
            "processing"|"pending")
                : # progress handled above
                ;;
            "")
                echo "STATUS_UPDATE: Empty status in response, raw: $(echo "$response_body" | head -c 200) (${elapsed}s elapsed)"
                ;;
            *)
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
    validate_size
    submit_generation
    poll_task "$GLOBAL_TASK_ID" "$GLOBAL_ESTIMATED_TIME"
}

main "$@"
