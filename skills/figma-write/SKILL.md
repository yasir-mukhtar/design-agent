---
name: figma-write
description: "Create and modify Figma designs via the official remote Figma MCP (write-to-canvas). Use when the user asks the agent to design, build, or edit screens directly in Figma — frames, IDDS components, auto-layout, variables."
version: 1.0.0
metadata:
  hermes:
    tags: [figma, design, mcp, idds, write-to-canvas]
---

# Figma Write — design directly in Figma (MCP write-to-canvas)

Goal: turn a design brief or spec into real, IDDS-compliant Figma content the user can open and refine in the Figma browser or desktop app.

## Prerequisites (one-time)
- Installed + authorized: `hermes mcp install figma` then `hermes mcp login` (OAuth in browser), then restart Hermes.
- Verified: `hermes mcp ls` shows the server; `hermes mcp test figma` passes.
- The target file must have the **IDDS UI Kit available as a library** (published), or be the kit file itself — `search_design_system` / `get_libraries` must be able to find it.
- MCP tools appear as `mcp_figma_*` (e.g. `mcp_figma_use_figma`, `mcp_figma_create_new_file`, `mcp_figma_get_screenshot`, `mcp_figma_search_design_system`, `mcp_figma_whoami`).

## The design loop (always, in order)
1. **Read first (study-then-reuse):** `get_screenshot` + `get_design_context` a comparable live screen (or IDDS kit frames) BEFORE building anything. Never design from memory or from the digest alone.
2. **Plan the build:** list the frames needed and the IDDS components each screen composes (map via `brain/component-map.md`). Name the plan before touching the canvas.
3. **Create/open the file:** `create_new_file` for a new design (lands in the user's Drafts), or target an existing file the user names.
4. **Place components, not raw shapes:** for every element, `search_design_system` the IDDS kit first ("Button", "TextField", "Table", "Badge", "Pagination"…) and place the genuine component. Raw rects/text only when no kit component fits.
5. **Bind tokens & styles:** colors/type come from the kit's variables and text styles (resolve via `search_design_system` / `get_variable_defs` on kit frames) — never raw hex, never raw sizes.
6. **Screenshot-verify:** `get_screenshot` the result, review against craft law (below), fix, re-verify. **Never declare done without a screenshot pass.**
7. **Report:** give the user the Figma link, what was built, and what still needs their hand (states, content, motion).

## Craft law (violations are defects — same as AGENT.md)
- **No emoji as icons/glyphs** — genuine IDDS icons only.
- **No spacer frames** — auto-layout + `SPACE_BETWEEN` for push-apart; `itemSpacing`/padding for fixed gaps.
- **Colors from kit variables**, never raw hex.
- **Type from kit text styles/ramp**, never raw sizes.
- **4px spacing grid; 8px radius** (override kit defaults like Modal 12px → 8px).
- **Content fits** — no clipping/overflow; verify by screenshot.
- **Semantic roles** — `Background/*` never fills text.
- **Microcopy per `brain/writing-guide.md`** — Bahasa, CTA ≤ 3 words, no em dash.

## Common operations (prompts to the MCP)
- New file: *"Create a new Figma file called '<Name>'."*
- Frame: *"Add a frame 1440×900 named 'Login' in <file>."*
- Component: *"Find the IDDS 'Button' component and place an instance with hierarchy=primary, size=md, label 'Masuk'."*
- Auto-layout: *"Group these into auto-layout, gap 16, padding 24; header row uses SPACE_BETWEEN."*
- Verify: *"Screenshot node <id> and describe what's rendered."*

## Pitfalls
- **Write-to-canvas is free beta** — may become usage-based; expect rough edges, report them with screenshots.
- **Fidelity depends on the library being reachable** — if `search_design_system` returns nothing, check `get_libraries` first.
- **Session-bound to the authenticated user** — everything lands in THEIR Drafts/files; never assume another account's access.
- **Don't hand-build what the kit has** — searching + placing a component beats raw geometry almost every time.
- **Locate nodes by title text / selection links, not stale IDs.**
- Big screens in one shot can fail — build frame by frame, verifying each with a screenshot before the next.
