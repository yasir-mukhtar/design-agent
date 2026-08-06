# Component Map — Figma IDDS Kit → `@idds/react`

The bridge between design and code. When generating React from a Figma frame, resolve each IDDS component instance to its React equivalent below.

## Verified React exports (`@idds/react` — enumerated 6 Aug 2026, 111 exports)

| Figma component | React | Notes |
|---|---|---|
| Button / Button Group | `<Button>`, `<ButtonGroup>` | `hierarchy` (`primary`/`secondary`/`tertiary`), `size` (`sm`/`md`/`lg`) |
| Text Input / TextArea | `<TextField>`, `<TextArea>` | `label`, `placeholder`, `error`, `disabled`, `type` |
| Card Content | `<Card>`, `<CardPlain>` | `children`, `className` |
| Table | `<Table>`, `<TableProgressBar>` | real Table component exists — prefer it over hand-built tables |
| Modal / Drawer / BottomSheet | `<Modal>`, `<Drawer>`, `<BottomSheet>` | |
| Badge / Avatar / Chip | `<Badge>`, `<Avatar>`, `<Chip>` | |
| Pagination / Stepper | `<Pagination>`, `<Stepper>` | |
| Tab Menu | `<TabHorizontal>`, `<TabVertical>` | |
| Accordion | `<Accordion>`, `<AccordionGroup>`, `<AccordionCard>` | `useAccordionGroup` hook |
| Alert / Toast / Toggle / Tooltip | `<Alert>`, `<Toast>`, `<Toggle>`, `<Tooltip>` | Toast needs `ToastProvider` at root |
| Checkbox / Radio | `<Checkbox>`, `<RadioInput>` | |
| Date / Time / Month / Year Picker | `<DatePicker>`, `<TimePicker>`, `<MonthPicker>`, `<YearPicker>` | |
| Dropdown | `<BasicDropdown>`, `<ActionDropdown>`, `<SelectDropdown>` | |
| OTP | `<OneTimePassword>` | |
| File Upload | `<FileUpload>`, `<SingleFileUpload>` | |
| Input variants | `<InputSearch>`, `<PasswordInput>`, `<PhoneInput>`, `<FormField>` | |
| Feedback / Loading | `<Alert>`, `<Skeleton>`, `<Spinner>`, `<ProgressBar>`, `<LinearProgressIndicator>`, `<CircleProgressBar>` | |
| List | `<List>`, `<ListItem>`, `<ListItemButton>`, `<ListItemIcon>`, `<ListItemText>`, `<ListSubheader>` | |
| Collapse / Divider | `<Collapse>`, `<Divider>` | |
| Forms | `FormProvider`, `useForm` | |

**Helpers & tokens:** `setBrandTheme`, `getAvailableBrands`, `isValidBrand`, `setThemeMode`/`getThemeMode`/`toggleThemeMode`/`getCurrentTheme`/`initializeTheme`/`resetTheme`/`setCustomTheme`, color token objects (`iddsColorTokens`, `panrbColorTokens`, `bgnColorTokens`, `bknColorTokens`, `lanColorTokens`, `inagovColorTokens`, `inakuColorTokens`, `inapasColorTokens`, `defaultColorTokens`), input sanitizers (`sanitizeInput`, `validateInput`, `onlyNumericValue`, `onlyDecimalNumber`, `onlyAlphanumeric`), file validation (`validateFile*`), `formattingThousand`, `useConfirmation`, `useToast`.

> Re-verify before relying on a rare export: `node -e "import('@idds/react').then(m => console.log(Object.keys(m).sort().join('\n')))"` — the package grows over time.

## Design patterns without a React component (CSS / structure)
| Pattern | Approach |
|---|---|
| Layout shell (Sidebar, Navbar, Header) | Compose from components + Tailwind IDDS tokens (no dedicated shell export). |
| Dashboard metrics | Card grid; metric = H5/Semibold + Caption S label. |
| Empty state / FAQ / 404 / OTP | Compose from Button + TextField + icons + copy (OTP has `<OneTimePassword>`). |

## Theme & tokens in React
```jsx
import '@idds/react/index.css'                     // FIRST import — before other CSS
import { setBrandTheme, setThemeMode, toggleThemeMode } from '@idds/react'

setBrandTheme('panrb')   // 'inagov' | 'panrb' | 'bkn' | 'lan' | 'bgn' | 'default'
setThemeMode('light')    // 'light' | 'dark' — sets data-theme on <html>
```

## Root providers (discovered from official starter, Feb 2026)
Toast and Confirmation components need their providers at the root or they fail at runtime:
```jsx
import { ConfirmationProvider, ToastProvider } from '@idds/react'
// wrap <App /> in <ConfirmationProvider><ToastProvider>…</ToastProvider></ConfirmationProvider>
```
The official starter (idds-react-starter.zip) also ships **React 19 + Vite 5 + Tailwind v4 + apexcharts** — mirror it for new projects.

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
