#!/bin/bash
# scripts/validate-rule.sh - validates detection rule YAML files on write

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
NORMALIZED_PATH="${FILE_PATH//\\//}"

case "$NORMALIZED_PATH" in
  rules/*.yml|rules/*.yaml|*/rules/*.yml|*/rules/*.yaml) ;;
  *) exit 0 ;;
esac

ERRORS=$(python - "$FILE_PATH" <<'EOF'
import sys
import yaml

path = sys.argv[1]

try:
    with open(path) as f:
        data = yaml.safe_load(f)
except Exception as e:
    print(f"failed to parse YAML: {e}")
    sys.exit(1)

if not isinstance(data, dict):
    print("rule file must contain a YAML mapping")
    sys.exit(1)

errors = []

if not data.get("title"):
    errors.append("missing required field: title")

if not data.get("description"):
    errors.append("missing required field: description")

tags = data.get("tags") or []
if not isinstance(tags, list) or not any(isinstance(t, str) and t.startswith("attack.t") for t in tags):
    errors.append("tags must include at least one 'attack.t*' entry")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
EOF
)
STATUS=$?

if [ $STATUS -ne 0 ]; then
    echo "Invalid detection rule: $FILE_PATH" >&2
    echo "$ERRORS" >&2
    exit 2
fi

echo "Valid detection rule: $FILE_PATH" >&2
exit 2
