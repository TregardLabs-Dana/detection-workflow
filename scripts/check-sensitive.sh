#!/bin/bash
# scripts/check-sensitive.sh - PreToolUse hook that blocks tool calls whose
# file_path targets a sensitive file (.env, *.key, *.pem, secrets/, credentials/).

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
NORMALIZED_PATH="${FILE_PATH//\\//}"

case "$NORMALIZED_PATH" in
  *.env|*.key|*.pem|*secrets/*|*credentials/*)
    echo "Blocked: tool input targets a sensitive path: $FILE_PATH" >&2
    exit 2
    ;;
esac

exit 0
