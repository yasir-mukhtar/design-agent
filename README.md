# INA Digital Design Agent

A lean, model-agnostic design agent for Indonesian government digital products on the **INA Digital Design System (IDDS)**. Digests low-fidelity PRDs → designs in Figma → generates React code → ships to GitHub + Vercel.

## What it does
- Digests ambiguous PRDs and banks **explicit assumptions** (confidence + de-risk plan)
- Reads Figma via **REST API** (no MCP, no vendor lock-in)
- Designs on IDDS — tokens, components, patterns as the single source of truth
- Writes **Bahasa UX copy** per the IDDS writing guidelines (Sosok/Nada/Inklusivitas)
- Generates React + Tailwind code from `@idds/react`
- Ships to GitHub + Vercel (Supabase when a project needs persistence)
- Remembers across sessions via per-project brain files

## Prerequisites
- [Hermes Agent](https://hermes-agent.nousresearch.com/docs) (desktop or CLI)
- Node.js ≥ 18
- Figma personal access token → `FIGMA_TOKEN`
- GitHub CLI → `gh auth login` (repos)
- Vercel CLI → `npm i -g vercel` (deploys)

## Install (2 min)
1. Clone or download this repo.
2. Add the agent definition as a Hermes skill:
   ```bash
   hermes skill add /path/to/Design\ Agent/AGENT.md
   ```
   (or copy it into `~/.hermes/skills/design-agent/SKILL.md` — see `hermes-agent` skill for the canonical layout)
3. Export credentials:
   ```bash
   export FIGMA_TOKEN=your_figma_token
   ```
4. Start a session and say **"design agent"** — pick a path from the menu.

## Repository structure
```
AGENT.md                      # The agent: persona, session loop, craft law
brain/
  design-system.md            # IDDS tokens, components, hard rules
  writing-guide.md            # Bahasa UX copy rules
  figma-guide.md              # Figma REST API manual
  component-map.md            # Figma component → @idds/react bridge
  pattern-index.md            # Reuse-radar
projects/
  _template/brain/            # Copy this for every new project
  <name>/brain/               # Per-project memory (context, memory, decisions, findings, open-questions)
tools/
  figma-rest.sh               # Thin curl wrapper: get_file, get_node, get_image
skills/                       # Phase 2: figma-read, code-scaffold, ship-to-vercel, …
```

## Model agnosticism
The agent definition is **plain markdown + terminal tools**. No MCP, no vendor-specific bindings. Swap the LLM backend in Hermes freely — Claude, OpenAI, DeepSeek, or anything else — the agent works the same.

## Docs
- `QUICKSTART.md` — first session in 5 minutes
- `.hermes/plans/` — the architecture plan this repo implements
