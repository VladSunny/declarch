# Smoky Lofi — System Visual Style

## Purpose

Smoky Lofi is a unified visual foundation for the workstation: calm, nocturnal,
organized, and slightly dreamlike. It combines the softness of Catppuccin
Mocha, the cool clarity of Tokyo Night, and the atmosphere of lofi
illustrations without copying any of them literally.

This document defines the mood, color roles, and shared interface language.
Application configurations should follow these rules, but they do not need to
look identical. Existing styling may serve as inspiration, but is not a
standard by itself.

Core associations: **smoky graphite, quiet night, soft local light, order,
comfort, and open space**.

The following do not belong to this style: acid neon, cyberpunk or gaming
aesthetics, excessive glassmorphism, colorful gradients, decorative noise, and
motion without purpose.

## Principles

1. **Calm before decoration.** The interface supports concentration and does
   not demand attention until feedback is needed.
2. **Hierarchy through value and spacing.** Use surface levels, whitespace,
   and typography first. Add color, borders, and shadows only when necessary.
3. **One primary accent.** Dusty lavender identifies focus, selection, and the
   primary action. Every other color retains a narrow semantic role.
4. **Softness remains functional.** Rounded corners, blur, and transparency
   must not compromise density, readability, or navigation speed.
5. **Consistency comes from roles, not literal sameness.** When an application
   cannot be recolored precisely, choose a dark theme with comparable contrast,
   temperature, and accent behavior.

## Palette

Token names are canonical. Configurations should refer to their semantic roles
instead of choosing a nearby color independently.

### Backgrounds and surfaces

| Token | Color | Purpose |
|---|---|---|
| `void` | `#0C0E12` | Deepest areas, dimming, and the background behind overlays |
| `canvas` | `#111319` | Workspace and root background |
| `base` | `#171A21` | Primary application and persistent panel background |
| `surface` | `#1D212A` | Nested sections and secondary regions |
| `raised` | `#252A35` | Emphasized elements and elevated surfaces |
| `overlay` | `#303642` | Menus, tooltips, and the highest interactive layer |
| `border` | `#3B4251` | Quiet outlines, separators, and inactive borders |

Transitions between surface levels should remain subtle. Avoid separating one
element with a new background, a prominent border, and a shadow at the same
time; one technique is usually enough, and two are the maximum.

### Text

| Token | Color | Purpose |
|---|---|---|
| `text` | `#D5DAE5` | Primary text and important values |
| `subtext` | `#ADB5C5` | Labels, explanations, and secondary information |
| `muted` | `#778093` | Inactive states and decorative details |

`text` and `subtext` provide confident contrast on `base`. Do not use
`muted` for important information or small text. If a label must be readable
without effort, use at least `subtext`.

### Accents and states

| Token | Color | Purpose |
|---|---|---|
| `lavender` | `#B7A7D8` | Focus, selection, and the primary action |
| `blue` | `#85A4C7` | Information, links, and neutral active states |
| `sage` | `#8FAA9A` | Success, readiness, and normal operation |
| `amber` | `#C3A36F` | Warnings and states that need attention |
| `rose` | `#C38F9D` | Rare supporting or emotional emphasis |
| `red` | `#CF7F89` | Errors, critical states, and destructive actions |

Lavender is the only primary accent. Blue and rose must not compete with it for
focus. Sage, amber, and red appear only when color communicates state. Together,
accent colors should occupy no more than 10–15% of a typical screen.

Color must not be the sole carrier of meaning. Reinforce important states with
text, an icon, shape, or a change in intensity. Do not use gradients in
functional interface elements.

## Space and geometry

Dimensions follow a **4 px** base grid. The standard spacing scale is
`4 / 8 / 12 / 16 / 24 px`. Intermediate values are acceptable only when
alignment with an application's external constraints requires them.

- `4 px` — icon-to-label spacing or a tightly related internal group;
- `8 px` — compact internal padding;
- `12 px` — standard control or panel padding;
- `16 px` — separation between independent groups;
- `24 px` — a major compositional break.

The standard corner radius is **10 px** for windows, menus, and panels. Use
**6 px** for small controls. A full pill shape is reserved for short statuses,
switches, and workspace indicators.

The standard border is **1 px** in `border`. A **2 px** outline is acceptable
for the current focus when color alone is insufficient. Bright double borders
and gradient outlines do not belong to the style.

## Depth, transparency, and light

Working surfaces should feel stable and remain readable over any suitable
wallpaper.

- Primary windows and text-heavy regions: `0.94–1.00` opacity.
- Panels, launchers, and temporary overlays: `0.90–0.96`, provided their
  background is also controlled with blur or dimming.
- Do not stack nested translucent surfaces; it muddies color and makes contrast
  unpredictable.
- Blur creates depth rather than showcasing an effect. Its radius should hide
  small wallpaper details while preserving only broad, soft color masses.
- Use shadows sparingly. Prefer a wide, low-opacity dark shadow without colored
  glow.

Light is directional: a lighter surface level indicates focus, elevation, or
an available action. Do not introduce extra bright hues for decorative glow.

## Typography

- **Inter** — system UI, menus, dialogs, and long-form text.
- **JetBrains Mono Nerd Font** — terminal, editor, technical labels, and compact
  status elements.
- The base interface size is **13–14 px**. Smaller text is acceptable only for
  optional labels with sufficient contrast.
- Semibold weight identifies a selected state or heading; it is not the default
  treatment for every element.
- Use italics sparingly for metadata, quotations, or semantic emphasis, not for
  persistent navigation.

Create text hierarchy through size, weight, and the `text`, `subtext`, and
`muted` colors. Avoid changing all three properties at once without a clear
need.

## Icons and cursor

The primary system icon theme is **Papirus Dark**. Panels and controls should
prefer simple monochrome symbols with consistent visual weight. Retain branded
color icons where they improve application recognition; do not force every
brand mark into lavender.

The primary cursor theme is **Bibata Modern Classic**. Its neutral light gray
remains visible on dark surfaces without competing with the lavender focus
color.

## Motion

Motion should explain a state change and preserve spatial relationships without
becoming an event of its own.

| Event | Duration | Character |
|---|---:|---|
| Hover, focus, or state change | about `160 ms` | Soft `ease-out` |
| Window, menu, or layer entrance | about `220 ms` | Subtle fade or short directional movement |
| Exit | `120–160 ms` | Faster fade |

Avoid springy bounce, strong zoom, random directions, and long decorative
transitions. Elements moving together should use coordinated timing. When a
reduced-motion mode is available, retain only short fades or instantaneous
state changes.

## Wallpapers

Wallpapers provide the emotional layer; the interface provides order and
readability. Prefer dark lofi illustrations with the following traits:

- a quiet nighttime scene such as a room, city, train, café, rain, or a view
  through a window;
- soft local light and large calm areas;
- graphite, twilight blue, muted lavender, or warm amber color families;
- restrained detail and sufficient negative space behind working areas;
- no large white regions, acid neon, text, or excessively contrasty focal
  points.

Characters are welcome, but they should not turn the wallpaper into a poster or
continually pull attention away from work. Subtle grain and atmospheric haze
are appropriate when they are part of the illustration. The interface does not
recolor itself for every wallpaper: choose images for Smoky Lofi, not the other
way around.

## Using existing themes

For complex applications, the closest ready-made dark theme is acceptable,
especially Tokyo Night or Catppuccin Mocha. Select by character rather than
name alone: a neutral-cool graphite background, soft contrast, restrained
accents, and no bright blue or purple glow.

When an application supports selective overrides, align the primary background,
main text, focus color, and critical states first. The rest of its palette may
retain the application's internal logic as long as it preserves the overall
calm hierarchy.
