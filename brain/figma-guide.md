# Figma REST API — Operating Manual

Model-agnostic access to Figma. No MCP, no SDK dependencies — plain HTTPS + JSON from any terminal.

## Auth
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

### Write (limited)
| Purpose | Endpoint |
|---|---|
| Create a new file | `POST /v1/files` (draft only) |
| Full node authoring | Figma Plugin API (runs inside Figma) — future; see `skills/figma-write` |

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
