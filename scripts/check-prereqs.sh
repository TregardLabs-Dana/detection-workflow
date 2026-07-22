#!/bin/bash
# scripts/check-prereqs.sh - SessionStart hook that warns if required tools are missing.

MISSING=()

command -v jq >/dev/null 2>&1 || MISSING+=("jq")
command -v python3 >/dev/null 2>&1 || MISSING+=("python3")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "Warning: missing required tool(s): ${MISSING[*]}" >&2
fi

exit 0
