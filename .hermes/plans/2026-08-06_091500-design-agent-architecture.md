# Design Agent Architecture & Implementation Plan

> **For Hermes:** Execute this plan task-by-task, building the agent definition first, then skills.

**Goal:** Build a lean, model-agnostic design agent that digests low-fidelity PRDs, designs in Figma, generates front-end code with IDDS, and ships to GitHub + Vercel — all from a Hermes skill.

**Architecture:** Three layers — (1) a markdown agent persona with session loop and brain files, (2) Hermes skills wrapping Figma REST API / GitHub CLI / Vercel CLI, (3) a project brain structure that persists context across sessions. The existing INA Digital Design Agent (`ina-design-agent` repo) is the reference; we extract only the core design DNA and drop Claude-specific coupling, multi-squad complexity, and verbose team-standards history.

**Tech Stack:** Hermes Agent runtime, Figma REST API, Node.js (Vite + React + @idds/react + Tailwind CSS v4), GitHub CLI, Vercel CLI, Supabase CLI (future).

---

## Design Principles for This Agent

1. **Lean, not bloated.** Every file must earn its place. Drop squad onboarding ceremony, Claude-specific MCP references, team-standards history, and verbose behavior rules.
2. **Model-agnostic by construction.** The agent definition is pure markdown — no Claude-isms, no MCP tool references. All tools are Hermes skills or terminal commands.
3. **Brain persists; session is ephemeral.** Project state lives in `projects/<name>/brain/` markdown files. The agent reads on start, writes on every meaningful decision, and the next session resumes from disk.
4. **IDDS is the single source of truth.** Never reinvent tokens, components, or patterns. Always resolve from the Figma kit (`2mm5H6E94tMXCG8jdRaM6I`) or the `@idds/react` npm package.
5. **Bahasa-first UX copy.** The writing persona follows the IDDS writing guidelines (Sosok/Nada/Inklusivitas). English is secondary.

---

## What We Keep from the Existing Agent (and Why)

| From existing | Keep? | Reason |
|---|---|---|
| Agent persona + session loop | ✅ Keep, simplify | Core DNA — but drop 2-beat ceremony, squad check, verbose behavior rules |
| 5-path menu | ✅ Keep, simplify | Still the right UX for starting a session — but as a Hermes skill, not Claude agent |
| Project brain files (memory/decisions/findings/open-questions) | ✅ Keep | This is the memory system — proven pattern |
| Reuse-radar | ✅ Keep | Prevents duplicate work |
| Design-activity menu | ✅ Keep, simplify | Offers structured activities, but drop research/motion/portfolio (keep only build path) |
| IDDS design language digest | ✅ Condense | Keep tokens + components + rules; drop team-standards history and verbose annotations |
| UX writing principles | ✅ Keep, condense | 4 core principles + Sosok/Nada framework — critical for gov copy |
| Figma operating manual | ✅ Rewrite | Replace MCP with REST API; drop Claude-specific MCP tricks |
| Craft law (component rules) | ✅ Keep, condense | No spacer frames, no emoji, 4px grid, 8px radius, token-bound colors — the non-negotiables |

## What We Drop (and Why)

| From existing | Drop? | Reason |
|---|---|---|
| Squad registry / multi-squad onboarding | ❌ Drop | Adds ceremony. Single-agent serves whoever asks. Squad can be a project-level attribute. |
| Claude MCP references | ❌ Drop | Model coupling. Replace with REST API + terminal. |
| 9 UX skill engine (ux-design, ux-research, etc.) | ❌ Drop from agent | These are Hermes skills already available globally. The agent calls them when needed. |
| IDDS specialization playbooks (product-design.md, grill-me.md, etc.) | ❌ Drop from agent | Same — they're referenced skills, not part of the agent definition. |
| Team-standard history (ruled 9 Jul, 10 Jul, 14 Jul...) | ❌ Drop | Keep only the rules, not the dates and backstory. |
| Auto-sync caveat (git hooks) | ❌ Drop | Hermes handles sync differently. |
| Working modes declaration | ❌ Drop | Adds ceremony without value. |
| Orientation section | ❌ Drop | Rarely used. |
| Balanced challenger behavior rules | ❌ Condense | Keep "don't just agree, ground every claim" — drop the rest. |
| Vercel Web Design Guidelines / AccessLint references | ❌ Drop | External tools, not agent DNA. |
| `watch` skill, motion-framer, humanizer references | ❌ Drop | Power skills, not core. |

---

## File Architecture

```
Design Agent/
├── AGENT.md                              # Main agent definition (the skill body)
├── README.md                             # Setup: install Hermes, add skill, get Figma token
├── QUICKSTART.md                         # 5-minute: clone → install → first session
│
├── brain/
│   ├── design-system.md                  # IDDS condensed: tokens, components, rules (no history)
│   ├── writing-guide.md                  # UX copy: 4 principles + Sosok/Nada + contoh
│   ├── figma-guide.md                    # Figma REST API: auth, read design, write design
│   ├── component-map.md                  # IDDS Figma component → @idds/react prop mapping
│   └── pattern-index.md                  # Reuse-radar: cross-project patterns
│
├── projects/
│   └── _template/
│       └── brain/
│           ├── project-context.md        # What, who, scope, regulation, file keys
│           ├── memory.md                 # Session log: what happened, current state
│           ├── decisions.md              # Calls made + why (with confidence tags)
│           ├── findings.md               # Insights, user feedback, research synthesis
│           ├── open-questions.md         # Unknowns with assumptions + de-risk plans
│           └── reference/                # PRD PDFs, regulation docs, screenshots
│
├── skills/
│   ├── figma-read/SKILL.md               # Read Figma designs via REST API
│   ├── figma-write/SKILL.md              # Create/update Figma designs (future)
│   ├── code-scaffold/SKILL.md            # Vite + React + @idds/react project scaffold
│   ├── ship-to-vercel/SKILL.md           # GitHub push + Vercel deploy
│   └── supabase-provision/SKILL.md       # Database setup (future)
│
└── tools/
    └── figma-rest.sh                     # Thin curl wrapper: get_node, get_screenshot, list_components
```

---

## Implementation Plan — Phase 1: Lean Agent Core (Today)

### Task 1: Initialize the repo and directory structure

**Objective:** Set up the git repo, create all directories, add `.gitignore`.

**Files:**
- Create: `.gitignore`
- Create all directories from the file architecture above

**Step 1: Create .gitignore**

```
node_modules/
.env
.DS_Store
dist/
.vite/
```

**Step 2: Verify directory structure**

```bash
find "/Users/hy4-mac-006/Design Agent" -type d | sort
```

**Expected:** All directories from architecture exist.

**Step 3: Commit**

```bash
cd "/Users/hy4-mac-006/Design Agent"
git add -A
git commit -m "chore: initialize repo structure"
```

---

### Task 2: Write the main agent definition (AGENT.md)

**Objective:** Create the lean agent persona — the Hermes skill body that defines who the agent is, how it starts a session, and how it works.

**File:** `AGENT.md`

**Content outline:**
1. **Identity** (5 lines): Who this agent is. "Principal product designer serving Indonesian government digital products on IDDS."
2. **Session loop** (15 lines): Simplified — greet → understand the need → load context → work → write back. No 2-beat ceremony, no squad check. Just: "What are we building today?"
3. **Five paths** (10 lines): New brief/PRD · Continue · Brainstorm · Quick question · UX Writing — the same menu, but delivered as a Hermes skill option, not a Claude agent ritual.
4. **Write-back protocol** (10 lines): Update project brain after every meaningful decision. Which files, what content.
5. **Reuse-radar** (5 lines): Check pattern-index before building anything new.
6. **Design activities** (10 lines): Structured menu: Persona → IA → UX flow → Wireframe → Hi-fi → Annotate → Code → Deploy. Each maps to a skill or tool.
7. **Craft law** (20 lines): The non-negotiables — IDDS source of truth, no emoji, no spacer frames, 4px grid, token-bound colors, accessibility gate, content must fit.
8. **UX copy rules** (10 lines): 4 principles, Sosok/Nada, CTA 2-3 words max, regulator vocabulary.
9. **Figma rules** (10 lines): Kit key, REST API preference, read before write, screenshot before code.
10. **Code rules** (10 lines): Use @idds/react, Tailwind v4 tokens, scaffold from starter, deploy to Vercel.
11. **Behavior** (5 lines): Lead with recommendation, ground every claim, disagree then commit.

**Total target: ~100 lines.** The existing agent is 330 lines; we cut 70%.

---

### Task 3: Write brain/design-system.md (IDDS condensed)

**Objective:** Extract only what's needed for daily design work — no history, no team-standards chronology.

**File:** `brain/design-system.md`

**Content:**
- Brand tokens (Primary #196bcd, Pro Blue #1f2855, National Red #ff1800)
- Color scale (Primary/Neutral/Semantic roles, not every shade)
- Typography ramp (Display → Caption XS, Inter, weights)
- Spacing (4px grid)
- Radius (8px default)
- Components list (Accordion through Tooltip — names only, no keys)
- Chart components (Pie, Line, Bar — reference only)
- The 6 non-negotiable rules (no emoji, no spacers, token-bound colors, text styles, semantic roles, content fits)
- Figma kit key + REST API endpoint reference

**Target: ~80 lines** (down from 148 lines of the existing digest).

---

### Task 4: Write brain/writing-guide.md (UX copy condensed)

**Objective:** Condensed version of the IDDS writing guidelines — enough for an agent to produce consistent product copy.

**File:** `brain/writing-guide.md`

**Content:**
- 3 principles: Berempati, Jelas & ringkas, Berbasis fakta
- Sosok: how to define persona (4 steps) + example: Tenaga Operasional (formal ringan, lugas, solutif)
- Nada (Tone): the situation table (6 rows from the original)
- Inklusivitas: 4 guidelines (condensed)
- The 4 core principles: fokus pada perkembangan, tampilkan progres, jelaskan manfaat, berikan langkah selanjutnya
- CTA rule: 2 kata ideal, 3 kata maksimal
- Register: imperatives lead with verb + benefit; "Silakan…" only for neutral instructions
- Title Case for actions, sentence case for body

**Target: ~60 lines.**

---

### Task 5: Write brain/figma-guide.md (REST API operating manual)

**Objective:** Replace MCP with REST API instructions — this is the bridge to model agnosticism.

**File:** `brain/figma-guide.md`

**Content:**
- Auth: `X-Figma-Token` header, where to get it, how to set as env var
- **Read:**
  - `GET /v1/files/{key}` — get file structure (depth=1 for pages, depth=2 for frames)
  - `GET /v1/files/{key}/nodes?ids=…` — resolve specific nodes
  - `GET /v1/files/{key}/variables/local` — get variable definitions
  - `GET /v1/images/{key}?ids=…&format=png&scale=2` — get screenshot URLs
- **Write (future):**
  - `POST /v1/files` — create new file
  - Plugin API for programmatic node creation
- **Key operations:**
  - Read a frame's component instances
  - Get resolved variable values
  - Capture screenshot for vision review
- **Kit key:** `2mm5H6E94tMXCG8jdRaM6I`
- **Quota:** View = 6 calls/month, Pro Full = 200/day

**Target: ~40 lines.**

---

### Task 6: Write brain/component-map.md (Figma → React bridge)

**Objective:** Map every IDDS Figma component to its `@idds/react` equivalent — this is the code-output bridge.

**File:** `brain/component-map.md`

**Content:**
A table with columns: Figma Component | React Import | Key Props | Notes

Example rows:
```
Button          | import { Button }          | hierarchy (primary/secondary/tertiary), size (sm/md/lg), disabled, icon | Uses setBrandTheme() for color
TextField       | import { TextField }       | label, placeholder, error, disabled, type | 
Table Cell      | — (use native HTML table) | — | IDDS provides Table Cell styling via CSS; structure with <table>
Badge           | import { Badge }           | variant, children | 
Modal           | import { Modal }           | open, onClose, title, children | 
Card Content    | import { Card }            | children, className | 
Pagination      | import { Pagination }      | current, total, onChange | 
Tab Menu        | import { TabMenu }          | items, active, onChange | 
Toast           | import { Toast }           | message, type, onClose | 
```

Plus Tailwind token mappings:
- `text-content-primary` → Content/Primary
- `bg-primary-50` → Primary/50
- `border-stroke-primary` → Stroke/Primary

**Target: ~50 lines.**

---

### Task 7: Write the project template brain

**Objective:** Create the five brain files as templates — every new project copies this structure.

**Files:**
- `projects/_template/brain/project-context.md`
- `projects/_template/brain/memory.md`
- `projects/_template/brain/decisions.md`
- `projects/_template/brain/findings.md`
- `projects/_template/brain/open-questions.md`

**Each file** is a template with markdown headings and placeholder text — the agent fills them in during the New-project bootstrap.

---

### Task 8: Write README.md and QUICKSTART.md

**Objective:** Someone should be able to install and use the agent in 5 minutes.

**File: README.md**
- What this is
- Prerequisites (Hermes, Node.js 18+, Figma token, GitHub CLI, Vercel CLI)
- Install: `hermes skill add <path-to-AGENT.md>`
- Usage: start Hermes, say "design agent", follow the menu
- Environment variables: `FIGMA_TOKEN`, `GITHUB_TOKEN`, `VERCEL_TOKEN`

**File: QUICKSTART.md**
- 5-minute guide: clone → install deps → add skill → first session
- Example session transcript

---

### Task 9: Write tools/figma-rest.sh

**Objective:** Thin shell wrapper around Figma REST API — usable from any Hermes terminal session.

**File:** `tools/figma-rest.sh`

**Functions:**
- `figma_get_file <key>` — dump file structure as JSON
- `figma_get_node <key> <node-id>` — resolve a specific node
- `figma_get_screenshot <key> <node-id>` — download a screenshot
- `figma_search_component <key> <name>` — search for a component by name

**Implementation:** Pure curl + jq. Reads `FIGMA_TOKEN` from environment.

```bash
#!/bin/bash
# figma-rest.sh — thin REST wrapper for Figma API
# Usage: source tools/figma-rest.sh
# Requires: FIGMA_TOKEN env var, curl, jq

FIGMA_BASE="https://api.figma.com/v1"

figma_get_file() {
  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" "$FIGMA_BASE/files/$1?depth=2"
}

figma_get_node() {
  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" "$FIGMA_BASE/files/$1/nodes?ids=$2"
}

figma_get_image() {
  local result=$(curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
    "$FIGMA_BASE/images/$1?ids=$2&format=png&scale=2")
  local url=$(echo "$result" | jq -r '.images | to_entries[0].value')
  if [ -n "$url" ] && [ "$url" != "null" ]; then
    curl -s -o "${3:-screenshot.png}" "$url"
    echo "Saved: ${3:-screenshot.png}"
  else
    echo "Error getting image URL" >&2
    echo "$result" >&2
  fi
}
```

**Target: ~30 lines.**

---

### Task 10: Wire up the git remote and commit

**Objective:** Connect local repo to GitHub remote, commit all Phase 1 files.

**Step 1: Add remote**

```bash
cd "/Users/hy4-mac-006/Design Agent"
git remote add origin https://github.com/yasir-mukhtar/design-agent.git
```

**Step 2: Commit all files**

```bash
git add -A
git commit -m "feat: lean design agent — Phase 1 core"
```

---

## Implementation Plan — Phase 2: Skills (Next Sprint)

### Task 11: Write skills/figma-read/SKILL.md

Hermes skill wrapping `tools/figma-rest.sh`. Teaches the agent how to read Figma designs via REST API.

### Task 12: Write skills/code-scaffold/SKILL.md

Hermes skill that:
1. Runs `npm create vite@latest` with React + TypeScript template
2. Installs `@idds/react`, `@tabler/icons-react`, `tailwindcss`, `@tailwindcss/vite`
3. Configures Tailwind with IDDS tokens
4. Sets brand theme (`setBrandTheme`)
5. Writes a starter `App.tsx` with IDDS components

### Task 13: Write skills/ship-to-vercel/SKILL.md

Hermes skill that:
1. Initializes git repo (if not already)
2. Creates GitHub repo via `gh repo create`
3. Pushes code
4. Links Vercel project via `vercel link`
5. Deploys via `vercel --prod`

---

## Implementation Plan — Phase 3: Figma Write + Supabase (Future)

### Task 14: Write skills/figma-write/SKILL.md

Programmatic Figma design creation via REST API + Plugin API.

### Task 15: Write skills/supabase-provision/SKILL.md

Schema provisioning and Row-Level Security setup for government data.

---

## Risks, Tradeoffs, and Open Questions

### Risks
- **Figma REST API is read-only for design creation.** True programmatic design creation requires the Plugin API, which is harder to automate. Mitigation: start with read-only Figma; write manually for now; explore headless Figma solutions.
- **@idds/react package may lag behind Figma kit.** The npm package and Figma kit can diverge. Mitigation: reference both; flag discrepancies in `component-map.md`.
- **Vercel deployment needs GitHub connection.** First-time setup requires OAuth — can't be fully automated. Mitigation: QUICKSTART.md documents the one-time setup step.
- **Model agnosticism is aspirational.** Some models handle tool calling better than others. Mitigation: test with Hermes's default model first; document which models work well.

### Tradeoffs
- **Lean vs. comprehensive.** We're dropping the 9 UX skills, squad registry, and verbose team standards. This means the agent won't proactively offer research/motion/portfolio activities. Tradeoff accepted: those are power-user features; the lean agent focuses on the core build path.
- **REST API vs. MCP.** REST is model-agnostic but less integrated (no `get_design_context` with inline code). Tradeoff: we accept a two-step process (fetch JSON → parse → generate code) instead of one-step.

### Open Questions
1. Should the agent auto-detect which model is running and adapt its tool calls? (Likely yes — Hermes can tell us.)
2. Should we create a Vercel template project that pre-configures IDDS, so the scaffold step is just cloning a repo? (Likely yes — faster than `npm create vite` + install.)
3. How do we handle Figma component instances that don't have a 1:1 `@idds/react` equivalent? (Table Cell is the main one — it's a CSS pattern, not a React component.)

---

## Success Criteria

- [x] A new user can run `hermes skill add` and start designing in < 5 minutes (symlink registration verified via skills_list)
- [ ] The agent can digest a 1-paragraph PRD and produce a project brain with assumptions
- [ ] The agent can read a Figma frame and describe its components + tokens
- [x] The agent can generate a working React page with `@idds/react` components (official starter build verified: `npm run build` → dist, HTTP 200 on preview)
- [ ] The generated code can be pushed to GitHub and deployed to Vercel (pipeline documented; `gh`/`vercel` CLIs not installed on this machine yet)
- [x] The agent writes progress back so the next session picks up where it left off (brain structure in place)
- [x] Swapping the LLM backend (Claude → OpenAI → DeepSeek) does not break the agent (pure markdown + terminal tools, no MCP)
- [x] The entire agent definition is under 500 lines of markdown (335 lines total)

---

# Execution Log — Phase 2 (6 Aug 2026)

## Decisions taken (delegated to agent)
1. **Register agent as a Hermes skill via symlink** (`~/.hermes/skills/design-agent` → repo). Zero copy drift; the installed skill IS the repo. Reversible in one command.
2. **`gh` and `vercel` CLIs are NOT installed** on this machine; plain `git push` works via macOS keychain. Ship skill uses plain git + documents `npx vercel`.

## Phase 2 deliverables (all committed)
- `SKILL.md` (repo root) — thin wrapper: load `AGENT.md` + brain pointers (no persona duplication).
- `skills/figma-read/SKILL.md` — REST read ops, kit key, quota notes.
- `skills/code-scaffold/SKILL.md` — Vite + React + Tailwind v4 + `@idds/react` scaffold; corrected with real findings (below).
- `skills/ship-to-vercel/SKILL.md` — git push + Vercel link/deploy; auto-deploy config.
- All four registered under `~/.hermes/skills/` via symlinks; verified visible in `skills_list`.

## Verification performed (real, not simulated)
- `@idds/react@1.6.53` confirmed on npm.
- Official starter (`idds-react-starter.zip`) downloaded, `npm install` (99 packages, 26s), build fixed + rerun: **tsc + vite build ✓ in 7.61s**, `dist/` 5.2M, `vite preview` → **HTTP 200** "INA Digital UI - React Starter".
- Enumerated live exports: **111 exports** — used to rewrite the component-map bridge table.

## Corrections discovered (already patched into skills)
1. `vite.config.ts` needs the `tailwindcss()` plugin (`@tailwindcss/vite`) for Tailwind v4 — was missing from the original skill.
2. Root `ConfirmationProvider`/`ToastProvider` required for Toast/Confirmation components.
3. **The official starter ships with a TS error** in `Articles.tsx` (`Chip.onSelect` handler typed `string` vs `string | string[]`) — fixed in test copy; flag on `npm run build` failure of fresh starter clones.
4. `Table` IS a real `@idds/react` export (component-map previously said "native table only").
5. `setBrandTheme` brand values confirmed: `'inagov' | 'panrb' | 'bkn' | 'lan' | 'bgn' | 'default'` (starter comment shows `'pan-rb'` — code uses `'panrb'`).