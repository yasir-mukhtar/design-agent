---
name: ship-to-vercel
description: "Push a front-end project to GitHub and deploy to Vercel. Use when shipping generated IDDS React code: git init/add/commit/push, GitHub repo creation, Vercel link + production deploy."
version: 1.0.0
metadata:
  hermes:
    tags: [github, vercel, deploy, ci, shipping]
---

# Ship to GitHub + Vercel

## 1. GitHub
```bash
git init            # if not already a repo
git add -A && git commit -m "feat: <description>"
git branch -M main

# Existing remote? push. New repo? add remote or create via gh:
git remote add origin https://github.com/<user>/<repo>.git
git push -u origin main
```
- `gh` CLI is optional: `gh repo create <name> --private --source=. --push` when installed.
- Plain https push works whenever git credentials are configured (e.g. macOS keychain) — `gh` is not required.

## 2. Vercel
```bash
npm i -g vercel       # or: npx vercel@latest (no global install)
vercel link           # one-time: import/attach the project (first time = OAuth in browser, cannot be fully automated)
vercel --prod         # production deploy → prints the https URL
```

## 3. Auto-deploy (one-time config)
Once linked, every `git push` to the default branch triggers a build. Verify in the Vercel dashboard:
- Framework Preset: **Vite** · Root Directory: project root
- Build: `npm run build` · Output: `dist`

## 4. Verify the deployment
```bash
curl -sI <vercel-url> | head -1        # expect HTTP/2 200
```
Open the URL and compare against the Figma screenshot — brain/component-map.md checklist item 6.

## Pitfalls
- First `vercel link` is interactive (OAuth) — plan for it, don't script around it.
- Runtime env vars (e.g. `SUPABASE_URL`, `SUPABASE_ANON_KEY` when the app uses Supabase) are set in the Vercel dashboard, not committed.
- `dist/` and `node_modules/` stay gitignored.
- If a push seems to not trigger a build, check Vercel → Project → Deployments; force with `vercel --prod` if needed.
