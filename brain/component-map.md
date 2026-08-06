# Component Map — Figma IDDS Kit → `@idds/react`

The bridge between design and code. When generating React from a Figma frame, resolve each IDDS component instance to its React equivalent below.

## Verified React exports (`@idds/react`)
| Figma component | React | Key props | Notes |
|---|---|---|---|
| Button | `<Button>` | `hierarchy` (`primary`/`secondary`/`tertiary`), `size` (`sm`/`md`/`lg`), `disabled` | Official docs example |
| Text Input | `<TextField>` | `label`, `placeholder`, `error`, `disabled`, `type` | Official docs example |
| Card Content | `<Card>` | `children`, `className` | Official docs example |

> ⚠️ The package grows over time — **verify current exports before use**: in a scratch project run
> `node -e "import('@idds/react').then(m => console.log(Object.keys(m).sort().join('\n')))"`.
> Not every kit component has a 1:1 React export; some are CSS patterns (below).

## Design patterns without a React component (CSS / structure)
| Pattern | Approach |
|---|---|
| Table | Native `<table>` + IDDS CSS (Table Cell styling). Never hand-build with divs. |
| Layout shell (Sidebar, Navbar, Header) | Compose from components + Tailwind IDDS tokens. |
| Dashboard metrics | Card grid; metric = H5/Semibold + Caption S label. |
| Empty state / FAQ / 404 / OTP | Compose from Button + TextField + icons + copy. |

## Theme & tokens in React
```jsx
import '@idds/react/index.css'                     // FIRST import — before other CSS
import { setBrandTheme, setThemeMode, toggleThemeMode } from '@idds/react'

setBrandTheme('panrb')   // 'inagov' | 'panrb' | 'bkn' | 'lan' | 'bgn' | 'default'
setThemeMode('light')    // 'light' | 'dark' — sets data-theme on <html>
```

## Tailwind token utilities (v4)
```css
@import 'tailwindcss';
@import '@idds/styles/tailwind/css/idds.css';
@import '@idds/styles/tailwind/css/panrb.css';    /* or inagov, bkn, lan */
```
Classes: `text-content-primary` · `text-content-secondary` · `text-content-guide` · `bg-primary-50/100/500` · `border-stroke-primary` · `border-stroke-secondary`.

## Fonts & icons
- Font: Inter (bundled via package CSS).
- Icons: `@tabler/icons-react` — map kit icon names to the closest Tabler icon. Never emoji.

## Mapping checklist (Figma frame → React)
1. Frame → page/section component.
2. Each INSTANCE → its React component + props from `mainComponent.name` and overridden properties.
3. Text nodes → JSX text; preserve style (title/body/caption) and copy verbatim.
4. Auto-layout → flex/gap; SPACE_BETWEEN → `justify-between`.
5. Colors → Tailwind token classes (never raw hex).
6. Screenshot the Figma frame and compare against the rendered React output before shipping.
