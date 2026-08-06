# IDDS Design System — Condensed Reference

> **Source of truth:** IDDS UI Kit 1.0.0 — Figma key `2mm5H6E94tMXCG8jdRaM6I`, npm `@idds/react`.
> Pull exact values from the kit before going pixel-final. Do NOT infer tokens from screenshots.

## Brand
- "Satu Wajah, Satu Suara, Satu Digital Indonesia."
- Brand anchors: **National Red `#ff1800`** (identity only), **Pro Blue `#1f2855`**.
- Working UI primary: **`#196bcd`** (`Primary/Primary`). Blue = product action; red = brand identity.

## Color tokens (light)
**Primary (blue):** `25 #f6f9ff · 50 #eff5fd · 100 #c0d7f9 · 200 #a1c4f5 · 300 #629cef · 400 #196bcd · 600 #0a489f · 700 #083575 · 800 #022a5b · 900 #041225`

**Neutral:** `25 #ffffff · 50 #fdfbfb · 100 #f2f2f2 · 200 #e5e5e5 · 300 #d4d4d4 · 400 #a3a3a3 · 500 #737373 · 600 #525252 · 700 #404040 · 800 #1f1f1f · 900 #141414`

**Semantic roles (use these, not raw scale):**
- `Content/Primary` `#1f1f1f` · `Content/Secondary` `#525252` · `Content/Guide` `#0968f6`
- `Background/Primary` `#ffffff` · `Background/Secondary` `#fdfbfb`
- `Stroke/Primary` `#e5e5e5` · `Stroke/Secondary` `#a3a3a3`

**Semantic status:** Positive `#3cc14e` · Negative `#f02d2d` · Warning `#eebb04` · Guide/info `#0968f6`

**Instansi accents:** PANRB/Yellow `#f2c548` · LAN: Red `#a40f0a` Green `#1cbd19` Blue `#0a35c0` Orange `#f08519`

**Shade rule:** solid/strong usage → shades 500 and up; pastel/soft → 400 and below.
Dark mode exists (Product collection Dark mode; `setThemeMode('dark')` in React).

## Typography — Inter (the whole ramp)
| Token | Size / LH | Default use |
|---|---|---|
| Display L | 52 / 56 | hero |
| Display S | 44 / 48 | hero number |
| H1–H5 | 40→24 | page titles down |
| Body L | 20 / 28 | long reads |
| Body | 18 / 26 | |
| Body S | 16 / 24 | card title |
| Caption | 14 / 20 | **default UI text** |
| Caption S | 12 / 16 | card subtitle/caption |
| Caption XS | 10 / 12 | |

Weights: Regular 400 · Medium 500 · Semibold 600 · Bold 700 · Extra Bold 800 (Display only).
**Off-ramp sizes (11 · 13 · 15 · 22 · 26 · 48 …) do not exist — snap to the ramp.**

## Spacing & radius
- **4px grid only:** `4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48 · 64 · 80`. No odd values.
- **Surface radius = 8px** (`rad-8`): buttons, cards, inputs, dialogs. Override kit defaults (Modal ships 12px → 8px).
- Effects: flat — `Float` + `Focused` only. Shadows sparing.

## Components (kit ↔ React)
**Figma kit:** Accordion · Alert · Avatar · Badge · Breadcrumb · Button · Button Group · Card Content · Chart (Pie/Line/Bar) · Checkbox · Chip · Date Picker · Drawer · Dropdown List · File Upload · Loading · Modal · Pagination · Radio · Stepper · Tab Menu · Table Cell · Text Input · Toast · Toggle · Tooltip

**React (`@idds/react`):** Button · TextField · Card · … — full map in `component-map.md` (verify current exports against the package).

**Patterns:** Dashboard · Sidebar · Navbar · Header · Login & Register · Table · Card Data/Metrics · Empty State · FAQ · Searchbar · OTP · 404 · Footer

## React setup (official docs)
```bash
npm install @idds/react
npm install @tabler/icons-react tailwindcss @tailwindcss/vite   # recommended
```
```jsx
// src/main.jsx — CSS FIRST, then set theme once at entry
import '@idds/react/index.css'
import { setBrandTheme, setThemeMode, toggleThemeMode, getThemeMode } from '@idds/react'

setBrandTheme('panrb')   // 'inagov' | 'panrb' | 'bkn' | 'lan' | 'bgn' | 'default'
setThemeMode('light')    // sets data-theme on <html>
```
Tailwind v4:
```css
@import 'tailwindcss';
@import '@idds/styles/tailwind/css/idds.css';
@import '@idds/styles/tailwind/css/panrb.css';   /* or inagov, bkn, lan */
```
Utility classes: `text-content-primary` · `text-content-secondary` · `text-content-guide` · `bg-primary-50/100/500` · `border-stroke-primary` · `border-stroke-secondary`.
Tailwind v3: extend `colors` in `tailwind.config.js` via `iddsColorToken` + brand tokens from `@idds/react`.

## Hard rules (violations are defects)
1. **No emoji as UI icons/glyphs — ever.** Genuine kit icons or Tabler icons only.
2. **No spacer frames — ever.** Auto-layout + SPACE_BETWEEN instead of gap-filler frames.
3. **Colors bound to variables/tokens, never raw hex.** Variable binding must exist, not just matching hex.
4. **Type via ramp/styles, never raw sizes.**
5. **4px spacing grid; 8px radius default.**
6. **Content fits — no bleed, no clipping, no messy auto-layout.**
7. **Token roles semantic — `Background/*` never fills text.**
8. **Icons are components, never typed glyphs** (`›`, `✕`, `↻`) or emoji.
9. **No redundant data on charts** (one fact appears once); custom charts keep gridlines, axis labels, baseline at 0, true-scale target lines.
10. **Microcopy reads human:** short declarative sentences, no em dash, numbers as people say them.
