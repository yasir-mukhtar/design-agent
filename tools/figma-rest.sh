#!/bin/bash
# figma-rest.sh — thin REST wrapper for the Figma API (model-agnostic, no MCP).
# Usage: source tools/figma-rest.sh   (or add to PATH)
# Requires: FIGMA_TOKEN env var, curl, jq

FIGMA_BASE="${FIGMA_BASE:-https://api.figma.com/v1}"

# figma_get_file <file_key> [depth] — file structure (depth 1 = pages, 2 = frames)
figma_get_file() {
  local depth="${2:-2}"
  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" "$FIGMA_BASE/files/$1?depth=$depth"
}

# figma_get_node <file_key> <node_ids> — resolve specific nodes (comma-separated ids)
figma_get_node() {
  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" "$FIGMA_BASE/files/$1/nodes?ids=$2"
}

# figma_get_image <file_key> <node_id> [outfile] — download a PNG screenshot of a node
figma_get_image() {
  local outfile="${3:-screenshot.png}"
  local result
  result=$(curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
    "$FIGMA_BASE/images/$1?ids=$2&format=png&scale=2")
  local url
  url=$(echo "$result" | jq -r '.images | to_entries[0].value')
  if [ -n "$url" ] && [ "$url" != "null" ]; then
    curl -s -o "$outfile" "$url"
    echo "Saved: $outfile"
  else
    echo "Error getting image URL" >&2
    echo "$result" >&2
    return 1
  fi
}

# figma_get_variables <file_key> — local variable definitions (tokens)
figma_get_variables() {
  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" "$FIGMA_BASE/files/$1/variables/local"
}

# figma_me — current user + seat quota info
figma_me() {
  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" "$FIGMA_BASE/me"
}

# figma_component_instances <file_key> <node_id> — list INSTANCE nodes with their component names
figma_component_instances() {
  figma_get_node "$1" "$2" | jq -r '
    .. | objects | select(.type == "INSTANCE") |
    "\(.name)  ←  \(.mainComponent.name // "unknown component")  (id \(.id))"'
}
