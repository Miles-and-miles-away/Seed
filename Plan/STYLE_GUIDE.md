# Seed Visual Style Guide

Reference for all generated and hand-made art assets in the app.
This guide drives the prompts, validation, and review criteria in `scripts/art_pipeline/`.

---

## 1. Design Philosophy

Seed is a sustainability app that should feel **warm, optimistic, and approachable** -- never preachy or clinical. The visual language should make users feel good about the small actions they take, not guilty about what they haven't done.

```
Keywords:  friendly, clean, hopeful, nature-inspired, playful but mature
Avoid:     childish, dark/gloomy, overly complex, corporate, clip-art
```

<!-- WHY: The target audience ranges from teens to adults. "Cute" is fine
     but it shouldn't look like a kids' app. Think Duolingo's warmth
     without the cartoonishness, or Headspace's calm without the
     minimalism taken to the extreme. -->


## 2. Illustration Style

### 2.1 Core Style

| Property         | Value                                          |
|------------------|------------------------------------------------|
| Type             | Flat vector illustration                       |
| Geometry         | Soft rounded shapes, no sharp corners          |
| Outlines         | None -- shapes defined by color fills only     |
| Shadows          | None -- flat style, no drop shadows or glows   |
| Detail level     | Medium -- recognizable but not photorealistic  |
| Texture          | None -- solid color fills only                 |

<!-- WHY outline-free: Outlines add visual weight and complexity. Without them, assets feel lighter and more modern. This also keeps SVG file sizes smaller (fewer paths). Matches the Material 3 aesthetic of the app which uses elevation=0, clean surfaces. -->

<!-- WHY medium detail: Too simple and the Eco-Dex entries won't be interesting to collect. Too complex and they'll look muddy at small sizes (48dp action log icons) and SVG file sizes balloon. -->

### 2.2 Composition

| Property         | Value                                          |
|------------------|------------------------------------------------|
| Subject          | Single centered subject per asset              |
| Framing          | Subject fills ~75% of the canvas               |
| Background       | Transparent (no background fill)               |
| Orientation      | Front-facing or 3/4 view                       |
| Text             | Never -- no labels, numbers, or words          |

<!-- WHY transparent background: The app has both light and dark themes. White backgrounds would create harsh boxes in dark mode. Transparent lets the asset sit naturally on any surface (cards, lists, dialogs). The Recraft prompt says "white background" to keep generation clean, but we strip it during optimization. -->

<!-- WHY 75% fill: Leaves breathing room so assets don't feel cramped in cards, but fills enough space to be visually impactful. Assets that are too small in their canvas look like floating dots at icon sizes. -->

### 2.3 Prompt Template

The Recraft API prompt is assembled from parts:

```
[style prefix] + [category suffix] + [subject] + [color hint]
```

**Style prefix** (shared by all assets):
```
simple flat vector illustration, minimal geometric style,
cute rounded shapes, natural tones, white background, no text, no shadows, no outlines, centered composition, single subject
```

<!-- WHY "natural tones" not "earthy natural tones": "Earthy" biases
     the AI toward browns/olives and mutes the brighter category colors
     (blues, purples, oranges) that are part of our palette. "Natural
     tones" is less restrictive while still avoiding neon/artificial
     colors. -->

<!-- WHY "no outlines" added: Without this explicit instruction, Recraft
     sometimes adds black outlines that clash with the flat style. -->

<!-- WHY "single subject" added: Without this, the AI sometimes generates
     scenes with multiple objects, which look cluttered at small sizes
     and are harder to validate for consistency. -->


## 3. Color Palette

### 3.1 Palette Structure

The app has three distinct color groups. Assets should use the
appropriate group for their category.

#### Brand Colors (primary + secondary)

Used for: UI chrome, app identity, Eco-Dex flora/fauna/elements

| Color            | Hex       | Usage                            |
|------------------|-----------|----------------------------------|
| Primary          | `#2E7D32` | Main green, plant/nature subjects|
| Primary Light    | `#60AD5E` | Lighter green accents            |
| Primary Dark     | `#005005` | Deep green details               |
| Secondary        | `#795548` | Earth/soil/wood/bark             |
| Secondary Light  | `#A98274` | Lighter earth tones              |
| Secondary Dark   | `#4B2C20` | Dark earth, shadows              |

<!-- WHY these specific greens/browns: They're the app's brand identity.
     Every screen uses these in the app bar, buttons, cards. Art assets
     using the same greens/browns feel native to the app rather than
     pasted in from a stock library. -->

#### Action Category Colors

Used for: challenge assets, action-related illustrations

| Color            | Hex       | Category                         |
|------------------|-----------|----------------------------------|
| Green            | `#4CAF50` | Recycling                        |
| Blue             | `#2196F3` | Transport                        |
| Orange           | `#FF9800` | Food                             |
| Yellow           | `#FFC107` | Energy                           |
| Purple           | `#9C27B0` | Consumption                      |
| Cyan             | `#00BCD4` | Water                            |
| Brown            | `#8D6E63` | Community                        |
| Pink             | `#E91E63` | Advocacy                         |
| Blue Grey        | `#607D8B` | Learning                         |

<!-- WHY include all 9 categories: The previous config.yaml palette
     was missing Advocacy and Learning. When a challenge asset relates
     to advocacy (e.g., signing a petition), it should use the same
     pink the user sees on the action card. Consistency builds the
     mental model that "pink = advocacy." -->

#### Official SDG Colors

Used for: sdg_world category assets only

| SDG | Color     | Goal                              |
|-----|-----------|-----------------------------------|
| 1   | `#E5243B` | No Poverty                        |
| 2   | `#DDA63A` | Zero Hunger                       |
| 3   | `#4C9F38` | Good Health                       |
| 5   | `#FF3A21` | Gender Equality                   |
| 6   | `#26BDE2` | Clean Water                       |
| 7   | `#FCC30B` | Clean Energy                      |
| 10  | `#DD1367` | Reduced Inequality                |
| 11  | `#FD9D24` | Sustainable Cities                |
| 12  | `#BF8B2E` | Responsible Consumption           |
| 13  | `#3F7E44` | Climate Action                    |
| 14  | `#0A97D9` | Life Below Water                  |
| 15  | `#56C02B` | Life on Land                      |

<!-- WHY official UN colors: These are globally recognized. Users who
     know the SDGs expect to see the right colors. Using our own palette
     for SDG content would feel wrong and undermine credibility. -->

<!-- WHY only 12 of 17: SDGs 4, 8, 9, 16, 17 are marked isLearnOnly
     in the app (no trackable actions). We don't generate art assets
     for learn-only SDGs, but their colors are still in app_colors.dart
     for the SDG info screens. -->

#### Neutrals

Used for: backgrounds, borders, subtle details in any category

| Color            | Hex       | Weight                           |
|------------------|-----------|----------------------------------|
| Near White       | `#FAFAFA` | Lightest backgrounds             |
| Light Grey       | `#F5F5F5` | Card backgrounds                 |
| Grey 200         | `#EEEEEE` | Borders, dividers                |
| Grey 300         | `#E0E0E0` | Disabled states                  |
| Grey 500         | `#9E9E9E` | Placeholder text                 |
| Grey 600         | `#757575` | Secondary text                   |
| Grey 800         | `#424242` | Primary text (dark)              |
| Grey 900         | `#212121` | Headings (dark)                  |

### 3.2 Color Rules Per Asset Category

| Asset category   | Primary palette          | Accent palette           |
|------------------|--------------------------|--------------------------|
| flora            | Brand greens + browns    | Neutrals for detail      |
| fauna            | Brand + category colors  | Subject-appropriate      |
| elements         | Brand + category colors  | Subject-appropriate      |
| sdg_world        | Official SDG colors      | Brand greens as accents   |
| eco_pioneers     | Brand greens + browns    | Skin-tone neutrals       |
| milestones       | Brand + gold/yellow      | Category color accents   |
| challenge        | Matching category color  | Brand greens + neutrals  |
| garden           | Brand greens + browns    | Bloom colors from accent |
| mascot           | Brand primary + accent   | Expressive highlights    |

<!-- WHY per-category rules: A single "use this palette" rule doesn't
     work because a honeybee (fauna) naturally needs yellows and blacks
     while a recycling challenge naturally needs category green. The
     validator should know which palette to check against based on the
     asset's category. -->

### 3.3 Validation Tolerance

The color validator uses CIELAB distance to check palette adherence.

| Setting                    | Value | Rationale                       |
|----------------------------|-------|---------------------------------|
| Color distance threshold   | 60    | Allows natural variation within a hue family without accepting completely off-brand colors |
| Max off-palette colors     | 5     | AI generators add incidental colors (anti-aliasing, gradients); 5 is noise-level tolerance |

<!-- WHY CIELAB not RGB: RGB distance doesn't match human perception.
     Two colors can be far apart in RGB but look similar, or close in
     RGB but look very different. CIELAB distance correlates with how
     different colors actually look to humans. -->


## 4. Sizing and Display Contexts

Assets appear at multiple sizes throughout the app. They must remain
clear and recognizable at every size.

### 4.1 Display Sizes

| Context                  | Approximate size | Priority     |
|--------------------------|------------------|--------------|
| Eco-Dex detail card      | 200 x 200 dp    | High         |
| Eco-Dex grid thumbnail   | 80 x 80 dp      | High         |
| Action log icon          | 48 x 48 dp      | Medium       |
| Achievement popup        | 120 x 120 dp    | Medium       |
| Garden plant             | 100-200 dp tall | High         |
| Mascot (home screen)     | 200-300 dp tall | High         |

<!-- WHY this matters for generation: An asset that looks great at 200dp
     but becomes an unreadable blob at 48dp is a failed asset. The
     "medium detail" style rule exists specifically to keep assets
     readable at the smallest display size. -->

### 4.2 Generation Size

| Setting          | Value     | Rationale                        |
|------------------|-----------|----------------------------------|
| Recraft size     | 1024x1024 | Good detail for complex subjects |

<!-- WHY 1024: Gives the AI enough canvas for medium-detail subjects.
     512 might produce cleaner/simpler vectors for icon-style assets --
     worth testing a few at 512 for the simpler categories (elements,
     milestones) to compare file size and clarity. -->

### 4.3 File Size Targets

| Stage            | Max size  | Rationale                        |
|------------------|-----------|----------------------------------|
| Pre-optimization | 100 KB    | Recraft output before SVGO       |
| Post-optimization| 20 KB     | Final asset bundled in the app   |

<!-- WHY 20KB post-SVGO: The app bundles all assets. With ~113 total
     assets at 20KB each, that's ~2.2MB total. Acceptable for a mobile
     app. At 50KB each it would be ~5.5MB which starts to matter for
     download size and memory on low-end devices. -->


## 5. Dark Mode Considerations

The app supports both light and dark themes via Material 3.

| Rule                                                          |
|---------------------------------------------------------------|
| All assets must use transparent backgrounds                   |
| Avoid pure white (#FFFFFF) as a fill color in subjects        |
| Avoid pure black (#000000) as a fill color in subjects        |
| Use off-white (#FAFAFA, #F5F5F5) for light-colored areas     |
| Use dark grey (#424242, #212121) instead of black             |

<!-- WHY avoid pure white/black: Pure white subject areas disappear
     against light theme backgrounds. Pure black disappears in dark
     mode. Off-white and dark grey maintain visibility in both themes
     while still reading as "white" and "black" to the eye. -->

### 5.1 Post-Generation Cleanup

After SVGO optimization, the pipeline should:
1. Remove any `<rect>` background fills (white backgrounds from generation)
2. Replace `#FFFFFF` fills with `#FAFAFA` in subject areas
3. Replace `#000000` fills with `#212121` in subject areas

<!-- Automated: optimize.py runs fix_dark_mode_colors() after SVGO -->


## 6. Asset Categories Reference

### 6.1 Eco-Dex (56 entries)

The collectible encyclopedia. Each entry represents a concept the user
"discovers" by taking related actions.

- **Flora** (10): Individual plant species, botanical feel
- **Fauna** (10): Friendly animal characters, approachable
- **Elements** (8): Natural forces/elements as icons
- **SDG World** (8): Sustainability concepts, use SDG colors
- **Eco-Pioneers** (7): Human figures doing eco activities
- **Milestones** (7): Achievement/progress symbols
- **Challenge** (6): Action/activity symbols

Style: Each entry should feel like a collectible card illustration --
special enough to feel rewarding when unlocked.

### 6.2 Garden Plants (planned: ~45 assets)

15 plant species x 3 growth stages (seed, sprout, mature).

Style: Must show clear visual progression between stages. Same plant,
same colors, increasing size and detail. Consider whether these should
be Rive animations instead of static SVGs for the growth transitions.

### 6.3 Mascots (planned: ~12 assets)

3 species x 4 evolution stages.

Style: Most expressive and character-driven of all asset types. Should
have personality and charm. These are the user's companion -- they need
to feel alive even as static images.


## 7. Quality Checklist

Before approving a generated asset:

- [ ] Recognizable at 48dp (smallest display size)
- [ ] No embedded raster images (pure vector)
- [ ] Has viewBox attribute
- [ ] No text or numbers in the image
- [ ] Transparent background (or white to be stripped)
- [ ] Colors match the appropriate palette for its category
- [ ] Single centered subject, ~75% canvas fill
- [ ] No outlines or drop shadows
- [ ] Consistent style with other approved assets in same category
- [ ] Post-SVGO file size under 20KB


## 8. Prompt Reference

Complete prompt templates per category for the Recraft API.

### Shared prefix
```
simple flat vector illustration, minimal geometric style,
cute rounded shapes, natural tones, white background,
no text, no shadows, no outlines, centered composition,
single subject
```

### Category suffixes
```
flora:         botanical plant illustration, single specimen
fauna:         friendly animal character, simple features
elements:      natural element icon, symbolic
sdg_world:     globe or world concept, sustainability themed
eco_pioneers:  human figure, minimalist, diverse
milestones:    achievement symbol, celebratory
challenge:     action or activity symbol, energetic
garden:        garden plant with pot or soil, growth stages
mascot:        cute mascot character, kawaii inspired, expressive
```

<!-- WHY "diverse" added to eco_pioneers: The app is global. Generated
     human figures should represent diverse people, not default to one
     ethnicity. This prompt nudge helps the AI vary its output. -->

---

*Last updated: 2026-03-20*
*Maintained alongside `scripts/art_pipeline/config.yaml`*
