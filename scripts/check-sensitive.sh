#!/bin/bash
# scripts/check-sensitive.sh - PreToolUse hook that blocks tool calls whose
# input appears to contain a credential or secret.

INPUT=$(cat)

MATCH=$(echo "$INPUT" | grep -EIio \
  -e 'BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY' \
  -e 'AKIA[0-9A-Z]{16}' \
  -e 'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' \
  -e '(api[_-]?key|secret|token|password|bearer)"?[[:space:]]*[:=][[:space:]]*"?[A-Za-z0-9/+_.-]{16,}' \
  | head -5)

if [ -n "$MATCH" ]; then
  echo "Blocked: tool input appears to contain a credential or secret:" >&2
  echo "$MATCH" >&2
  exit 2
fi

exit 0
