---
name: figma-read
description: "Read Figma designs via the REST API — file structure, node trees, component instances, variables, screenshots. Use when the user asks to read/analyze a Figma file or extract a design for code generation. Model-agnostic: no MCP."
version: 1.0.0
metadata:
  hermes:
    tags: [figma, design, rest-api, idds]
---

# Figma Read (REST, model-agnostic)

## Setup
```bash
export FIGMA_TOKEN=...   # Figma → Settings → Security → Personal access tokens
source tools/figma-rest.sh   # from the design-agent skill dir
```

## Operations
| Task | Command |
|---|---|
| List pages of a file | `figma_get_file <key> 1 \| jq '.document.children[].name'` |
| Inspect a frame/node | `figma_get_node <key> <node-id> \| jq .` |
| Components inside a frame | `figma_component_instances <key> <node-id>` |
| Tokens / variables | `figma_get_variables <key>` |
| Screenshot a node | `figma_get_image <key> <node-id> shot.png` → review with vision |
| Seat / quota check | `figma_me` |

## Working rules
- **IDDS kit key: `2mm5H6E94tMXCG8jdRaM6I`** (IDDS UI Kit 1.0.0).
- Locate nodes by **title text, not stored IDs** — IDs shift as screens are edited.
- **Screenshot before code:** capture the frame, review it visually, then generate code.
- Full endpoint reference: `brain/figma-guide.md`.
- Quota: View seat ≈ 6 calls/month (hard block); Pro Full/Dev ≈ 200/day. If blocked, the user needs a Dev/Full seat on the file's team.

## Verification
Every read: confirm the JSON shape matches expectation AND capture a screenshot. Never trust stored IDs or inferred tokens — resolve from the kit.
