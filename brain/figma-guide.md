# Figma Access — Operating Manual

Two paths to Figma, same rules: locate nodes by **title text** (IDs shift), **screenshot before declaring done**, read tokens from the **kit** (`2mm5H6E94tMXCG8jdRaM6I`) never from memory.

1. **Official Figma MCP — primary (read AND write-to-canvas).** Remote endpoint `https://mcp.figma.com/mcp`, OAuth (no token). Tools appear in Hermes as `mcp_figma_*`.
2. **REST API — headless fallback.** Plain HTTPS + JSON from any terminal; needs a Personal Access Token. Good for scripted reads, CI, and when the MCP isn't connected.

## MCP — primary path (read + write)

### Setup (one-time)
```bash
hermes mcp install figma   # Nous catalog — official remote MCP
hermes mcp login           # authorize in the browser
# restart Hermes, then verify:
hermes mcp ls && hermes mcp test figma
```

### Read tools
| Tool | Use |
|---|---|
| `get_screenshot` | see a selection — the verify step for everything |
| `get_design_context` | code + screenshot + variables for a node |
| `get_metadata` | sparse layer tree of a selection |
| `get_variable_defs` | variables/styles used in a selection |
| `search_design_system` | find kit components/variables/styles by text query |
| `get_libraries` | libraries available/subscribed in the file |
| `whoami` | authenticated user + quota diagnosis |

### Write tools (write-to-canvas)
| Tool | Use |
|---|---|
| `use_figma` | create/edit/inspect any object — frames, components, auto-layout, variables |
| `create_new_file` | new blank Figma Design / FigJam / Slides in Drafts |
| `generate_diagram` | Mermaid → FigJam |
| `upload_assets` / `download_assets` | images into a file / export renders |

Playbooks: `skills/figma-write` (design in Figma) · `skills/figma-read` (extract for code).

### Plans & quota
- Remote MCP: **all seats/plans**; **free during beta** (Figma states it will become usage-based).
- Desktop MCP (local server in the Figma desktop app): Dev or Full seat — org/enterprise use cases; not needed for remote mode.
- Quota blocked? `whoami` to diagnose; a Dev/Full seat may be required.

## REST API — headless fallback

Model-agnostic access to Figma. No MCP, no OAuth session — plain HTTPS + JSON from any terminal. Wrapper: `tools/figma-rest.sh`.

## REST — Auth
- Get a token: Figma → Settings → Security → Personal access tokens.
- `export FIGMA_TOKEN=...` — every call sends header `X-Figma-Token: $FIGMA_TOKEN`.
- Wrapper: `tools/figma-rest.sh` (`figma_get_file`, `figma_get_node`, `figma_get_image`).

## Key endpoints

### Read
| Purpose | Endpoint |
|---|---|
| File structure (pages) | `GET /v1/files/{key}?depth=1` |
| Frames & nodes | `GET /v1/files/{key}?depth=2` or `GET /v1/files/{key}/nodes?ids=<id1>,<id2>` |
| Screenshot | `GET /v1/images/{key}?ids=<id>&format=png&scale=2` → JSON `images.<id>` holds a URL → download it |
| Variables (tokens) | `GET /v1/files/{key}/variables/local` (needs `file_variables:read` scope) |
| Comments (review pins) | `GET /v1/files/{key}/comments` |
| Text/effect styles | `GET /v1/files/{key}/styles` |

### Write (limited — REST canNOT author nodes)
| Purpose | Endpoint |
|---|---|
| Create a new file | `POST /v1/files` (draft only) |
| Full node authoring | ❌ not possible via REST — use MCP write-to-canvas (`skills/figma-write`) |

## Working rules
- **Kit key: `2mm5H6E94tMXCG8jdRaM6I`** (IDDS UI Kit 1.0.0).
- Read component instances: node JSON `type === 'INSTANCE'` → `mainComponent.name` tells you which kit component composes it.
- Resolved colors/type come in the node JSON; variable *bindings* need the variables endpoint.
- **Locate nodes by title text, not stored IDs** — IDs shift as screens are edited.
- **Screenshot before code:** capture the frame, review it with a vision pass, then generate code or declare done.
- Quota: View seat ≈ 6 calls/month (hard block); Pro Full/Dev ≈ 200/day. Check with `GET /v1/me`. If blocked, the user needs a Dev/Full seat on the file's team.
- `curl` with the token header works from any Hermes terminal — no web-fetch auth issues.

## Example (from any Hermes terminal)
```bash
export FIGMA_TOKEN=xxx
# List pages of the kit
curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/2mm5H6E94tMXCG8jdRaM6I?depth=1" | jq '.document.children[].name'
# Screenshot a specific frame
curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/images/2mm5H6E94tMXCG8jdRaM6I?ids=25408:74156&format=png&scale=2" | jq -r '.images | to_entries[0].value'
```
