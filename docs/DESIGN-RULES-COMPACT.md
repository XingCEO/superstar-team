# Design Rules (Compact — agent reference)
# Full version: docs/FRONTEND-DESIGN-RULES.md

## Banned (instant fail)
- Purple/blue gradients, decorative glassmorphism, gradient text
- Built-in emoji as icons — use Lucide/Heroicons SVG
- 3-column icon+text card grids, center-everything layouts
- Decorative blobs/waves, uniform border-radius on all elements
- Generic copy: "Build the future", "All-in-one", "Best-in-class"
- Pure black #000000 text — use #111827
- Font weight < 400, body text < 16px

## Spacing (4px grid, no arbitrary values)
- Icon-text: 4px | Same-group: 8px | Card padding: 16-24px
- Section gap: desktop 48-96px, mobile 32-48px
- Rule: outer margin >= inner padding (proximity law)

## Typography
- Scale: 12/14/16/18/20/24/30/36/48/60px
- Line-height: headings 1.1-1.2, body 1.5-1.6
- Max line width: 65ch | Weight: 400/500/600/700 only
- Max 2 font families | Hierarchy: change 2+ variables at once

## Color & Contrast
- Text >= 4.5:1, large text >= 3:1, UI elements >= 3:1 (WCAG AA)
- Use semantic naming (--color-text-primary), not decorative

## Shadows & Radius
- Max 3 shadow levels per page | Vertical offset required
- Radius tokens: 4/6/8/12/16/9999px | Nested = outer - padding
- Separation priority: spacing > background > shadow > border

## Interaction
- Every button: hover/focus-visible/active/disabled
- Focus: outline 2px solid, offset 2px | Touch target >= 44x44px
- Animation: hover 100ms, normal 200ms, expand 300ms
- No decorative animations | No scale on card hover

## Layout
- Content max-width: 1024-1152px | Reading: max-w-prose (65ch)
- 12-column grid | Mobile <640, Tablet 640-1023, Desktop 1024+

## Icons
- SVG only (Lucide/Heroicons/Phosphor) | currentColor, no colored icons
- Size tokens: 16/20/24px matching text hierarchy
