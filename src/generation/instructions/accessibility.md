---
generates: .github/instructions/accessibility.instructions.md
---

/create-instruction accessibility.instructions.md

# Accessibility Standards — Generation Prompt

You are generating a Copilot instruction file that enforces accessibility standards for all code that produces user-facing interaction or content. The file is scoped to UI/frontend/template file patterns via `applyTo`, not universal `"**"`.

## Standards Hierarchy

- **Primary technical baseline: WCAG 2.2 AA** — published October 2023, updated December 2024. Use 2.2, not 2.1. Content conforming to 2.2 also conforms to 2.1 and 2.0. WCAG 2.2 adds: Focus Not Obscured, Dragging Movements, Target Size (Minimum), Consistent Help, Redundant Entry, Accessible Authentication.
- **Implementation guidance: WAI-ARIA Authoring Practices Guide (APG)** — the reference for keyboard interaction patterns and ARIA semantics on custom widgets. Position as: use native HTML first, reach for ARIA + APG only when native semantics are insufficient.
- **Legal frameworks (generation file reference only, NOT in control file)**: ADA (US), Section 508 (US federal, still references WCAG 2.0 A/AA), EN 301 549 v3.2.1 (EU, based on WCAG 2.1), European Accessibility Act (EAA). The control file should state it implements the technical baseline commonly used to satisfy these obligations, without becoming legal boilerplate.

## Scope and applyTo

Scoped to UI, template, and content-producing file patterns:
```yaml
applyTo: ["**/*.tsx", "**/*.jsx", "**/*.html", "**/*.vue", "**/*.svelte", "**/*.astro", "**/*.css", "**/*.scss", "**/*.ejs", "**/*.hbs", "**/*.njk", "**/*.cshtml", "**/*.razor"]
```

Plus a rich `description` so it can be loaded on-demand for contexts outside those patterns (CLI output, email templates, markdown docs, generated documents).

## Critical LLM Failure Modes to Target

These are the most common accessibility mistakes LLMs make and must be explicitly addressed:

### Semantic failures
- Clickable `<div>` or `<span>` instead of `<button>` — the #1 most common
- Missing `type="button"` on buttons inside forms (causes accidental form submission)
- Broken heading hierarchy (h1 → h3 with no h2)
- Layout with generic containers and no semantic structure or landmarks
- `<a>` used as button or button used as link (wrong semantics for the action)

### ARIA misuse
- Unnecessary ARIA on elements that already have native semantics
- Invalid role/state/property combinations
- `aria-hidden="true"` on content that contains focusable elements
- Custom tabs, comboboxes, menus, dialogs that only look correct visually but lack keyboard + ARIA implementation per APG
- `role="button"` on a `<div>` without keyboard event handlers

### Labeling failures
- Unlabeled inputs (no `<label>`, no `aria-label`, no `aria-labelledby`)
- `placeholder` used as the sole label (disappears on input)
- Icon-only buttons without accessible name
- Vague link text: "Click here", "Read more", "Learn more" repeated without context
- Form errors not programmatically associated to the field

### Keyboard and focus failures
- No visible focus indicator (or focus indicator removed for aesthetics)
- Focus lost after modal open/close or dynamic content changes
- Incorrect or illogical tab order
- Keyboard traps (user cannot leave a component with keyboard alone)
- Hover-only or pointer-only interactions with no keyboard equivalent
- SPA route changes with no focus reset or announcement

### Visual-only communication
- Color as the sole differentiator for required fields, errors, statuses
- Insufficient contrast (below 4.5:1 for normal text, 3:1 for large text, 3:1 for UI components)
- Text embedded in images without alt text equivalent
- Disabled-looking but still interactive elements

### Dynamic content failures
- Toast/snackbar/status updates not announced to assistive tech
- Async loading states with no semantic exposure
- Form validation that appears visually but is not associated to the field or announced
- Carousels, accordions, tabs with weak state communication

### Responsive and target failures
- Clipped text at 200% zoom
- Non-reflowing layouts at 320px viewport (horizontal scroll)
- Touch targets too small (< 24x24 CSS px per WCAG 2.2)
- Drag-only interactions with no single-pointer alternative

## Control Families (12 sections)

### 1. Semantic Structure and Native Elements
- Use correct HTML elements for their semantic purpose
- Heading hierarchy (one h1, logical nesting)
- Landmark regions (`<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`, `<section>` with label)
- Document language (`lang` attribute)
- Descriptive page titles
- Tables for data, not layout — with proper `<th>`, `scope`, `<caption>`
- WCAG: 1.3.1, 1.3.6, 2.4.1, 2.4.2, 2.4.6, 3.1.1, 1.3.2

### 2. Accessible Names, Labels, and Instructions
- Every interactive control has a programmatically determinable accessible name
- Visible labels must match or be contained in the accessible name
- Icon-only buttons and controls must have `aria-label` or visually hidden text
- Links and buttons describe their action/destination without relying on surrounding context
- No placeholder-as-label, no title-as-label
- WCAG: 1.3.1, 2.4.4, 2.4.6, 2.5.3, 4.1.2

### 3. Keyboard Operability and Logical Navigation
- All interactive elements operable via keyboard alone
- Logical tab order matching visual layout
- No keyboard traps — user can always navigate away
- Standard keyboard patterns: Enter/Space for activation, Escape for dismissal, Arrow keys within composite widgets
- Every pointer/gesture interaction has a keyboard equivalent
- WCAG: 2.1.1, 2.1.2, 2.4.3

### 4. Focus Visibility and Focus Management
- All focusable elements have a visible focus indicator that meets 2.2 contrast requirements
- Focus indicator not obscured by other content (WCAG 2.2: Focus Not Obscured)
- Focus moves to modal/dialog on open, returns to trigger on close
- SPA route/view changes manage focus: update document title, move focus to new content or announce change
- Focus not stolen unexpectedly by dynamic content
- WCAG: 2.4.7, 2.4.11, 2.4.3, 3.2.1

### 5. ARIA: Only When Necessary, APG-Compliant When Used
- Use native HTML semantics FIRST — do not add ARIA to recreate native behavior
- The first rule of ARIA: don't use ARIA if native HTML can do it
- When ARIA IS needed for custom widgets: follow APG patterns for that widget (tabs, combobox, dialog, menu, tree, etc.)
- All custom ARIA widgets must have complete keyboard support per APG
- Never apply `aria-hidden="true"` to elements containing focusable content
- Never use invalid role/state/property combinations
- WCAG: 4.1.2 | APG patterns

### 6. Color, Contrast, and Non-Visual Communication
- Normal text: 4.5:1 contrast ratio minimum against background
- Large text (18pt+ or 14pt+ bold): 3:1 minimum
- UI components and graphical objects: 3:1 minimum against adjacent colors
- Never convey information by color alone — use text, icons, patterns, or shape as secondary indicators
- Ensure disabled, error, active, selected, and hover states are distinguishable without color
- WCAG: 1.4.1, 1.4.3, 1.4.11

### 7. Forms, Validation, Status, and Error Prevention
- Every `<input>`, `<select>`, `<textarea>` has a visible, programmatically associated `<label>`
- Group related controls with `<fieldset>` + `<legend>`
- Inline validation errors must identify the field AND the problem, and be programmatically associated (`aria-describedby` or `aria-errormessage`)
- Validation must not rely solely on color, placeholder, or timing
- For critical/destructive actions: provide confirmation, review, or undo mechanisms
- Auto-complete suggestions and datepickers must be keyboard operable and announced
- WCAG: 1.3.1, 3.3.1, 3.3.2, 3.3.3, 3.3.4, 3.3.7, 3.3.8

### 8. Dynamic Content, Live Regions, and SPA Transitions
- Status messages announced without moving focus (`aria-live` or `role="status"`)
- Async operations (loading, saving, submitting) expose loading, success, and failure states accessibly
- Toast/snackbar notifications use `aria-live="polite"` or `role="alert"` appropriately
- SPA route changes must: update `document.title`, manage focus, announce navigation to assistive tech
- Content inserted or removed dynamically must not break reading order or focus
- WCAG: 4.1.3, 3.2.1, 3.2.2

### 9. Media, Motion, Flashing, and Timed Content
- Respect `prefers-reduced-motion` — disable or reduce animations and transitions
- No auto-playing audio or video — or provide immediate pause/stop controls
- No content that flashes more than 3 times per second
- Auto-advancing content (carousels, slideshows) must have pause, stop, and manual navigation controls
- No forced time limits without accommodation (extend, disable, or warn)
- Provide captions for video and transcripts for audio content
- WCAG: 1.2.1, 1.2.2, 2.2.1, 2.2.2, 2.3.1, 2.3.3

### 10. Reflow, Zoom, Spacing, and Target Size
- Content reflows at 320px viewport width without horizontal scrolling (except data tables, maps, toolbars)
- Content and functionality preserved at 200% browser zoom
- Text resizable up to 200% without loss of content or function
- User spacing overrides (line-height, paragraph spacing, word/letter spacing) must not break content or hide information
- Interactive targets: minimum 24x24 CSS pixels (WCAG 2.2 Target Size Minimum) with adequate spacing
- Dragging interactions must have a single-pointer alternative (WCAG 2.2 Dragging Movements)
- WCAG: 1.4.4, 1.4.10, 1.4.12, 2.5.5, 2.5.7, 2.5.8

### 11. Tables and Structured Data
- Use `<table>`, `<th>`, `<td>`, `<thead>`, `<tbody>` for tabular data — never for layout
- Associate headers with `scope` attribute or `headers` attribute for complex tables
- Provide `<caption>` or `aria-label` for table purpose
- Keep table structure simple when possible — avoid deeply nested or merged cells
- WCAG: 1.3.1, 1.3.2

### 12. Testing and Verification
- Run automated accessibility testing in CI (axe-core, Lighthouse accessibility, or equivalent)
- Automated testing catches ~30-40% of issues — it is necessary but not sufficient
- Manually test keyboard navigation for all interactive components
- Test with at least one screen reader (NVDA, VoiceOver, or JAWS) for critical flows
- Verify focus management, live region announcements, and heading navigation manually
- Test at 200% zoom and 320px viewport width

## Style Notes

- ⛔/✅ format, imperative voice, no hedging
- Organize by the 12 sections above — developer-activity-oriented
- Include WCAG success criteria numbers in HTML comments for traceability: `<!-- WCAG: 1.3.1, 4.1.2 -->`
- Reference APG by name when discussing custom widget patterns
- Keep legal frameworks OUT of the control file — mention in this generation file only
- Note at the top: "This file implements the technical baseline commonly used to satisfy ADA, Section 508, EN 301 549, and EAA obligations"
- Target ~100-120 lines of rules
