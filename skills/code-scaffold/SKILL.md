---
name: code-scaffold
description: "Scaffold a Vite + React + TypeScript + Tailwind v4 project wired to the INA Digital Design System (@idds/react, latest verified 1.6.53). Use when generating React code from a Figma design or starting a new IDDS front-end."
version: 1.0.0
metadata:
  hermes:
    tags: [react, vite, tailwind, idds, scaffolding]
---

# Code Scaffold — Vite + React + IDDS

Goal: a working front-end wired to IDDS in ~2 minutes. Node ≥ 18 (verified: v24 works).
Reference: the official starter (design.inadigital.co.id/sample-project/idds-react-starter.zip) ships React 19 + Vite 5 + Tailwind v4 + `@idds/react@latest` + apexcharts — mirror it.

## 1. Scaffold
```bash
npm create vite@latest <name> -- --template react-ts
cd <name>
npm install
npm install @idds/react @tabler/icons-react tailwindcss @tailwindcss/vite
```

## 2. Wire the design system

`vite.config.ts` — add the Tailwind plugin (required for Tailwind v4):
```ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
```

`src/main.tsx` (entry — CSS first, theme once, providers for Toast/Confirmation):
```tsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { setBrandTheme, ConfirmationProvider, ToastProvider } from '@idds/react'
import '@idds/react/index.css'                    // FIRST import, before any other CSS
import './index.css'
import App from './App.tsx'

setBrandTheme('default')   // 'inagov' | 'panrb' | 'bkn' | 'lan' | 'bgn' | 'default'
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ConfirmationProvider>
      <ToastProvider>
        <App />
      </ToastProvider>
    </ConfirmationProvider>
  </StrictMode>
)
```
> ⚠️ **Toast/Confirmation components need their providers at the root** — without `ConfirmationProvider`/`ToastProvider` they fail at runtime. Wrap unconditionally.

`src/index.css` (Tailwind v4 token wiring):
```css
@import 'tailwindcss';
@import '@idds/styles/tailwind/css/idds.css';
@import '@idds/styles/tailwind/css/panrb.css';   /* or inagov, bkn, lan */
```

## 3. Build a screen
```tsx
import { Button, TextField, Card } from '@idds/react'
import { IconArrowRight } from '@tabler/icons-react'

export function Login() {
  return (
    <Card className="w-full max-w-md p-8">
      <h1 className="mb-2 text-2xl font-semibold text-content-primary">Masuk</h1>
      <TextField label="NIP" placeholder="Masukkan NIP Anda" />
      <Button hierarchy="primary" size="md" className="mt-4">
        Masuk
      </Button>
    </Card>
  )
}
```

## 4. Verify
```bash
npm run dev      # → http://localhost:5173, visual check against the Figma screenshot
npm run build    # → dist/ compiles clean; catches bad imports
```

## Pitfalls
- **CSS import order matters** — `@idds/react/index.css` must come before other CSS.
- `setBrandTheme()` once at entry, never per-component.
- Tailwind **v4**: no `tailwind.config.js` needed (CSS imports suffice). Tailwind **v3**: extend `colors` with `iddsColorToken` + brand tokens in `tailwind.config.js`.
- Package exports grow over time — enumerate before assuming: `node -e "import('@idds/react').then(m=>console.log(Object.keys(m).sort().join('\n')))"`.
- Map Figma components to React via `brain/component-map.md`; never hand-build what the kit provides.
