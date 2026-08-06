# Quickstart — first session in 5 minutes

## 1. Prereqs
```bash
node -v          # ≥ 18
hermes --version # Hermes Agent installed
```

## 2. Credentials
```bash
export FIGMA_TOKEN=your_figma_token   # Figma → Settings → Security → Personal access tokens
```

## 3. Start the agent
Open Hermes and say: **"design agent"**. You'll get the five paths:

1. **New brief/PRD** — new feature or module
2. **Continue a project** — resume in-flight work
3. **Brainstorm** — think before committing
4. **Quick question** — "does IDDS have X?"
5. **UX Writing / Copy** — write or review copy

## 4. Example session
```
You:    design agent
Agent:  Hi — I'm the INA Digital Design Agent. What are we building today?
        1. New brief/PRD   2. Continue a project   3. Brainstorm
        4. Quick question  5. UX Writing / Copy
You:    1 — here's the PRD: "A module for ASN to declare conflicts of interest
        before their annual performance review. Must be auditable."
Agent:  (grills the brief → seeds open-questions with assumptions →
        bootstraps projects/coi/brain/ → proposes starting point)
```

## 5. What happens next
- The agent writes every meaningful decision back to `projects/<name>/brain/` — the next session resumes where you left off.
- Before any hi-fi work it reads `brain/design-system.md` and studies a comparable live IDDS screen.
- When you're ready to ship: "generate the React code for this and deploy it" → Vite + `@idds/react` scaffold → GitHub push → Vercel deploy.
