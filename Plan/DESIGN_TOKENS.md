# Seed UI Design Tokens and Chart Conventions

**Created:** 2026-08-21
**Purpose:** A self-contained reference for designing new UI, especially
charts, without reading the codebase. Every value here is copied from the
source of truth listed beside it. If a value here disagrees with the code,
the code wins and this file is stale.
**Companion docs:** [STYLE_GUIDE.md](./STYLE_GUIDE.md) covers illustration
and generated art assets. This file covers the app's UI theme. It was
compiled for the original SDG progress visuals that are to replace the
bundled UN report infographics, described under "Open item" in
[ATTRIBUTIONS.md](../ATTRIBUTIONS.md).

---

## 1. Read this first: the theme is not a fixed palette

**Scope note.** This section governs app chrome: screens, cards, buttons,
and any chart that sits directly on a themed surface. It does **not**
apply to a fixed-background graphic such as a per-goal SDG panel, where
the artwork carries its own background and the mascot seed never reaches
it. For those, see section 3.5.

`lib/core/theme/app_theme.dart` is 33 lines and builds everything from a
single seed:

```dart
ThemeData appTheme(Brightness brightness, {Color? seedColor}) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor ?? AppColors.primary,
    brightness: brightness,
  ),
  ...
);
```

**The seed follows the user's active mascot species.** The whole scheme
re-tints per character, in both light and dark:

| Species id | Seed | Notes |
|---|---|---|
| `seed` | `#2E7D32` (Material Green 800) | the default, `AppColors.primary` |
| `coral` | `#4FC3F7` (light ocean blue) | shipped |
| `fungi` | `#A1887F` (light chocolate brown) | pre-registered, third species |

Consequences for any design:

- **There is no fixed brand primary.** A design that assumes green breaks
  for a coral user. Six combinations exist today (3 species x 2
  brightnesses) and more are planned.
- **Never hardcode a colour that has to harmonise** with surrounding UI.
  Use `ColorScheme` roles and let Material derive them.
- **Do hardcode** colours that carry fixed meaning: the SDG palette
  (section 3) and the semantic and category colours (section 2.2). These
  must not shift when the mascot changes.
- Mock any new design in at least two seeds, `seed` and `coral`, plus dark.

---

## 2. Colour

### 2.1 Scheme roles the shipped charts use

From `co2_trend_chart.dart` and `co2_category_chart.dart`. Reuse these
exact roles so new charts match:

| Role | Used for |
|---|---|
| `colorScheme.surfaceContainerLow` | chart card background |
| `colorScheme.primary` | the data series itself (dots, main line) |
| `colorScheme.onSurfaceVariant` | axis labels, secondary text, legend text |
| `colorScheme.outlineVariant` at `alpha 0.8` | the "Other" wedge in the donut |
| `dividerColor` at `alpha 0.4` | horizontal grid lines |

Note the series colour is `primary`, so it too moves with the mascot seed.

### 2.2 Fixed colours (source: `lib/core/theme/app_colors.dart`)

Action categories:

| Token | Hex |
|---|---|
| `categoryRecycling` | `#4CAF50` |
| `categoryTransport` | `#2196F3` |
| `categoryFood` | `#FF9800` |
| `categoryEnergy` | `#FFC107` |
| `categoryConsumption` | `#9C27B0` |
| `categoryWater` | `#00BCD4` |
| `categoryCommunity` | `#8D6E63` |
| `categoryAdvocacy` | `#E91E63` |
| `categoryLearning` | `#607D8B` |

Semantic: `success #4CAF50`, `warning #FFC107`, `error #F44336`,
`streak #FF9800`.

Info affordance, reserved: `infoLight #6200EA` on light themes and
`infoDark #B388FF` on dark, picked by `infoColor(brightness)`. Only the
shared info widgets (`InfoIconButton`, `TermWithInfo`) use them;
`test/shared/widgets/info_affordance_reserved_test.dart` enforces it.

Neutral ramp (full Material grey, available as design tokens):
`neutral50 #FAFAFA`, `100 #F5F5F5`, `200 #EEEEEE`, `300 #E0E0E0`,
`400 #BDBDBD`, `500 #9E9E9E`, `600 #757575`, `700 #616161`,
`800 #424242`, `900 #212121`.

---

## 3. The 17 SDG colours

### 3.1 Where they live

**Source of truth is `data/app/sdg_goals.json`, not Dart.** A duplicate
palette in `app_colors.dart` drifted out of sync and was deliberately
deleted; the comment there says so. Do not reintroduce one.

Parsed in `lib/features/sdg/data/sdg_data.dart` as:

```dart
color: Color(int.parse(hex, radix: 16) + 0xFF000000)
```

so the JSON stores bare 6-digit hex with no `#` and no alpha.

### 3.2 Values

| # | Hex | Short title |
|---|---|---|
| 1 | `#E5243B` | No Poverty |
| 2 | `#DDA63A` | Zero Hunger |
| 3 | `#4C9F38` | Good Health |
| 4 | `#C5192D` | Education |
| 5 | `#FF3A21` | Gender Equality |
| 6 | `#26BDE2` | Clean Water |
| 7 | `#FCC30B` | Clean Energy |
| 8 | `#A21942` | Decent Work |
| 9 | `#FD6925` | Innovation |
| 10 | `#DD1367` | Equality |
| 11 | `#FD9D24` | Sustainable Cities |
| 12 | `#BF8B2E` | Responsible Consumption |
| 13 | `#3F7E44` | Climate Action |
| 14 | `#0A97D9` | Life Below Water |
| 15 | `#56C02B` | Life on Land |
| 16 | `#00689D` | Peace & Justice |
| 17 | `#19486A` | Partnerships |

### 3.3 Pairs that are perceptually too close

**Only relevant when one graphic shows more than one goal.** A per-goal
panel uses a single goal colour, so collisions cannot arise; skip this.
It applies to any cross-goal overview, multi-series chart, or legend.

CIELAB deltaE (CIE76). Anything under about 20 is hard to
tell apart in adjacent chart elements; under 12 is effectively identical
at small sizes.

| dE | Pair |
|---|---|
| 10.2 | SDG 1 No Poverty vs SDG 4 Education |
| 11.9 | SDG 2 Zero Hunger vs SDG 12 Responsible Consumption |
| 17.1 | SDG 16 Peace & Justice vs SDG 17 Partnerships |
| 19.3 | SDG 14 Life Below Water vs SDG 16 Peace & Justice |
| 19.3 | SDG 5 Gender Equality vs SDG 9 Innovation |

There are effectively four clusters: reds (1, 4, 5, 8), oranges and golds
(2, 9, 11, 12), greens (3, 13, 15), and blues (6, 14, 16, 17). A
17-series chart keyed only on these colours is unreadable.

Outside the SDG set: a new species seed keeps every scheme role more
than delta E 20 from both info tones (2.2), so the violet stays unique.

### 3.4 Contrast against surfaces

WCAG contrast ratio against a light surface (`#FFFBFE`) and a dark one
(`#1C1B1F`). Below 3:1 means unusable for thin lines, small text, or
1.5px strokes.

Caveat: because the scheme is generated by `ColorScheme.fromSeed`, the
real surface is tinted by the active mascot seed and shifts slightly from
these Material 3 baseline values. Treat the numbers as accurate to within
a few tenths, and treat anything near the 3:1 line as failing.

| # | Hex | on light | on dark | verdict |
|---|---|---|---|---|
| 1 | `#E5243B` | 4.41 | 3.79 | ok both |
| 2 | `#DDA63A` | 2.14 | 7.82 | weak on light |
| 3 | `#4C9F38` | 3.24 | 5.16 | ok both |
| 4 | `#C5192D` | 5.77 | 2.90 | weak on dark |
| 5 | `#FF3A21` | 3.48 | 4.80 | ok both |
| 6 | `#26BDE2` | 2.17 | 7.72 | weak on light |
| 7 | `#FCC30B` | 1.58 | 10.56 | weak on light |
| 8 | `#A21942` | 7.44 | 2.25 | weak on dark |
| 9 | `#FD6925` | 2.84 | 5.89 | weak on light |
| 10 | `#DD1367` | 4.69 | 3.56 | ok both |
| 11 | `#FD9D24` | 2.04 | 8.18 | weak on light |
| 12 | `#BF8B2E` | 2.95 | 5.67 | weak on light |
| 13 | `#3F7E44` | 4.79 | 3.49 | ok both |
| 14 | `#0A97D9` | 3.18 | 5.25 | ok both |
| 15 | `#56C02B` | 2.28 | 7.32 | weak on light |
| 16 | `#00689D` | 5.91 | 2.83 | weak on dark |
| 17 | `#19486A` | 9.41 | 1.78 | weak on dark |

Only 6 of 17 clear 3:1 on both. **SDG yellow (7) at 1.58 on light and
SDG dark blue (17) at 1.78 on dark are the worst cases.**

### 3.5 On a white or off-white background

The numbers in 3.4 are against themed surfaces. For a fixed
light-background graphic the relevant figures are these, against pure
white, with off-white `#FAFAFA` in brackets:

| # | Hex | on white | large fill | any text |
|---|---|---|---|---|
| 7 | `#FCC30B` | 1.62 (1.55) | **LOW** | FAIL |
| 11 | `#FD9D24` | 2.09 (2.01) | **LOW** | FAIL |
| 2 | `#DDA63A` | 2.19 (2.10) | **LOW** | FAIL |
| 6 | `#26BDE2` | 2.22 (2.13) | **LOW** | FAIL |
| 15 | `#56C02B` | 2.34 (2.24) | **LOW** | FAIL |
| 9 | `#FD6925` | 2.91 (2.79) | **LOW** | FAIL |
| 12 | `#BF8B2E` | 3.02 (2.90) | ok | FAIL |
| 14 | `#0A97D9` | 3.26 (3.12) | ok | FAIL |
| 3 | `#4C9F38` | 3.32 (3.18) | ok | FAIL |
| 5 | `#FF3A21` | 3.57 (3.42) | ok | FAIL |
| 1 | `#E5243B` | 4.52 (4.33) | ok | ok |
| 10 | `#DD1367` | 4.81 (4.61) | ok | ok |
| 13 | `#3F7E44` | 4.91 (4.70) | ok | ok |
| 4 | `#C5192D` | 5.91 (5.67) | ok | ok |
| 16 | `#00689D` | 6.06 (5.80) | ok | ok |
| 8 | `#A21942` | 7.63 (7.31) | ok | ok |
| 17 | `#19486A` | 9.65 (9.24) | ok | ok |

6 of 17 fall below 3:1, unsafe even as a large graphic element. 10 of 17
fall below 4.5:1, unsafe for any text. White is the worst background for
this palette, and the off-white the style guide prefers costs only about
4% more, so use `#FAFAFA`.

**The one rule this reduces to:** goal colour for large fills only; every
number, label, and thin line in `#212121` or `#424242`.

### 3.6 Rules

1. SDG colour is an identifier, never the only carrier of meaning. Always
   pair with a label, number, shape, or position.
2. Use SDG colour for fills of decent area (a bar, a wedge, a dot of 4px+
   radius). Do not use it for 1px strokes or for text.
3. For text or thin strokes, use `onSurfaceVariant` and put the SDG colour
   in an adjacent swatch, exactly as the donut legend does.
4. Never place two colours from the same section 3.3 cluster adjacent
   without a non-colour distinguisher.
5. Do not tint, shade, or blend SDG colours to make a ramp. They are
   official identifiers. If a sequential ramp is needed, derive it from
   the theme, not from the SDG palette.
6. Never build a logo or icon out of SDG colour elements. The UN
   guidelines prohibit integrating any element of the SDG logo or icons
   into a separate design. See `ATTRIBUTIONS.md`.

---

## 4. Typography

**No custom font is declared.** `pubspec.yaml`'s `fonts:` block is
commented out, there is no `google_fonts` dependency, and
`app_theme.dart` sets no `textTheme` or `fontFamily`. So typography is
Material 3 defaults: Roboto on Android, San Francisco on iOS.

The only `fontFamily` anywhere in `lib/` is a `'monospace'` for numeric
values in `equivalency_info_sheet.dart`.

**Design against type scale roles, not pixel sizes.** Roles actually used
in the progress feature, with their Material 3 default values:

| Role | Size / line height | Weight | Tracking | Used for |
|---|---|---|---|---|
| `titleSmall` | 14 / 20 | 500, overridden to **w600** in both charts | 0.1 | chart card titles |
| `bodySmall` | 12 / 16 | 400 | 0.4 | tooltip text |
| `labelSmall` | 11 / 16 | 500 | 0.5 | axis labels, legend text |

Frequency across the progress widgets, as a guide to what the feature
leans on: `bodyMedium` 9, `titleMedium` 7, `labelSmall` 6, `bodySmall` 4,
`titleSmall` 3, `titleLarge` 3.

Chart titles are `titleSmall` with `fontWeight: FontWeight.w600`. Match
that for a new chart card.

---

## 5. Spacing, radii, motion, opacity

Verbatim from `lib/core/constants/ui_constants.dart`. Use these names;
do not invent intermediate values.

**Spacing:** `xxs 2`, `xs 4`, `sm 8`, `md 12`, `lg 16`, `xl 20`,
`xxl 24`, `xxxl 32`, `huge 48`.

**Radii:** `xs 4`, `sm 8`, `md 12`, `lg 16`, `xl 20`, `xxl 24`. Each has a
matching `borderRadiusXx` `BorderRadius.circular` constant. Cards use
`borderRadiusLg` via the theme; **charts use `borderRadiusMd`**.

**Durations:** `instant 100ms`, `fast 200`, `normal 300`, `emphasis 400`,
`slow 500`, `slower 600`, `reveal 800`, `celebration 1200`,
`showcase 1500`, `particleLoop 3s`, `glowLoop 2s`.

**Opacity:** `veryFaint .08`, `faint .1`, `subtle .15`, `light .2`,
`muted .3`, `disabled .38`, `medium .4`, `half .5`, `moderate .6`,
`strong .7`, `heavy .8`, `nearOpaque .85`.

---

## 6. Chart conventions

`fl_chart: ^1.2.0` is already a dependency. Two charts ship today and
define the house style.

### 6.1 The card recipe

Both charts wrap themselves in the same container. Copy it:

```dart
Container(
  padding: const EdgeInsets.fromLTRB(spacingLg, spacingLg, spacingLg, spacingMd),
  decoration: BoxDecoration(
    color: theme.colorScheme.surfaceContainerLow,
    borderRadius: borderRadiusMd,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [ /* title, gap, chart, optional legend */ ],
  ),
)
```

The trend chart uses `fromLTRB(spacingMd, spacingLg, spacingLg, spacingSm)`
because its y-axis labels need less left padding. Title to chart gap is
`spacingMd` (donut) or `spacingSm` (trend).

### 6.2 Fixed heights

| Constant | Value |
|---|---|
| `Co2TrendChart.height` | 220 |
| donut height | 180 |
| donut `centerSpaceRadius` | 52 |
| donut `sectionRadius` | 30 |
| donut `sectionsSpace` | 2 |
| scatter dot radius | 4 |
| average line width | 1.5, `dashArray: [4, 4]` |

### 6.3 Axes and grid

- `borderData: FlBorderData(show: false)`. No chart frame.
- `gridData`: horizontal only, `drawVerticalLine: false`,
  `strokeWidth: 0.5`, colour `dividerColor` at `alpha 0.4`.
- `topTitles` and `rightTitles` are always `const AxisTitles()`, i.e. off.
- Left axis `reservedSize: 32`; bottom axis `reservedSize: 24`.
- Y-axis interval is chosen by a small helper to land on 3 to 4 grid
  lines: `<=1 -> 0.25`, `<=5 -> 1`, `<=20 -> 5`, `<=50 -> 10`, else 25.
- Bottom axis shows **only first, middle, last** labels, so the same
  widget stays readable across 7, 30, and 90-day windows.
- Y max is padded to `peak * 1.15` with a floor, so points never sit on
  the top axis.

### 6.4 Legend and tooltips

- Legend is a separate private widget below the chart: swatch, localised
  name, share percentage.
- The trend chart puts a tiny inline legend **in the title row**: a 16x1.5
  box in the average-line colour, `spacingXs` gap, then a `labelSmall`
  label. Do this when a single line needs explaining.
- Tooltips return `null` for series that shouldn't be touchable, so users
  don't tap a reference line and get a meaningless readout.
- Donut centre holds the total; slices set `showTitle: false` rather than
  drawing labels on the wedges.
- Anything beyond the top 5 categories is pre-rolled into one "Other"
  wedge coloured `outlineVariant` at `alpha 0.8`.

### 6.5 Architecture

Charts take their data entity directly as a constructor argument and do
**not** read providers themselves. The comment in `co2_trend_chart.dart`
gives both reasons: the parent decides whether there is enough data to
render, and widget tests need no provider overrides. Follow this.

Pattern: freezed entity in `domain/entities/`, riverpod provider in
`presentation/providers/`, dumb widget in `presentation/widgets/`.

---

## 7. Dark mode

From `STYLE_GUIDE.md` section 5, and it applies to UI as much as art:

| Rule |
|---|
| Never pure white `#FFFFFF` as a fill in subjects |
| Never pure black `#000000` as a fill in subjects |
| Use off-white `#FAFAFA` or `#F5F5F5` for light areas |
| Use dark grey `#424242` or `#212121` instead of black |

Reason: pure white vanishes on a light surface, pure black vanishes in
dark mode; the off-shades still read as white and black to the eye.

Design philosophy, same doc: "warm, optimistic, and approachable, never
preachy or clinical". Keywords are friendly, clean, hopeful,
nature-inspired, playful but mature. Avoid childish, gloomy, corporate,
clip-art.

---

## 8. Localisation

Three locales: EN, JA, ES. User-facing strings come from ARB via
`AppLocalizations.of(context)`. Spanish is Spain Spanish (es-ES); the
style authority is `scripts/i18n/glossary_es.md`.

Rules:

- **No string assembly around translated text.** When a sentence holds a
  value (a name, a percent, a level), the ARB owns the whole sentence
  through a placeholder, so each language sets its own word order and
  punctuation. Gluing a translated fragment to a name and a `?` in code
  breaks Japanese order and drops the Spanish ¿.
- **Fractional and grouped numbers go through the locale formatter** in
  `lib/core/utils/helpers.dart` (`formatDecimal`, `formatCO2Compact`,
  `formatPoints`), never `toStringAsFixed` or plain interpolation, so
  Spanish gets its decimal comma and period grouping. Small counts that
  can never reach a thousand (levels, stage numbers) may interpolate.
- **A value and its unit do not wrap apart.** The formatters and the ARB
  templates that put a placeholder before a unit (`{km}\u00A0km`) use a
  no-break space (`unitSpace`). Data strings that carry quantities
  (servings, presets, energy behaviour names) go through
  `keepUnitsTogether` at their display sites; it joins g, kg, ml, L, km,
  h, min, kWh, W, lm, °C, C and %. Literal numbers inside long ARB prose
  are not covered. Editable quantity fields seed and parse with the
  locale (`decimalSeedText`, `parseDecimalInput`), and flag a
  thousands-shaped entry such as "1.500" rather than guess.
- **No hard-coded user-visible literal.**
  `test/core/l10n/no_hardcoded_strings_test.dart` scans `lib/` for any
  literal inside a text argument (`Text` and its subclasses, `TextSpan`
  `text:`, tooltips, labels, hints, semantics and input decoration text),
  including ternaries, adjacent literals and `+`. Its allowlist is keyed
  by file and literal and holds brand names, notation that reads the
  same in every language, and the postponed reminder text. It ignores
  literals with no letters, so assembly with `' - '` or `'?'` still needs
  review against the first rule.
- **Single-line labels never wrap.** Segmented controls use
  `ScaledSegmentedButton`, which shrinks all labels by one common factor
  when the widest does not fit, so siblings never render at different
  sizes. Rows holding translated text give it an `Expanded` or
  `Flexible`, or use a `Wrap`.
- **Multi-line Japanese text renders through `PhraseText`**
  (`lib/shared/widgets/phrase_text.dart`; `PhraseText.rich` for spans,
  `phraseMarkdownGenerator` for markdown). Flutter breaks Japanese
  between any two characters; `PhraseText` inserts word joiners so lines
  break between BudouX phrases and never before a closing mark or small
  kana. Pass `minLineWidth`, the narrowest width the text gets on a 320pt
  phone (dialogs use `phraseDialogMinLineWidth`); too large a value lets
  a joined phrase outgrow the line. Text with `maxLines` gets the
  kinsoku joins only, and measures itself to drop them if they alone
  would ellipsise it, so it must not sit under an intrinsic-sizing
  parent such as an `AlertDialog`. Joiners stay in the display layer:
  never in ARB values, data files, search keys, Firestore writes or
  analytics. Single-line labels stay plain `Text`.
- **Spanish punctuation:** questions and exclamations open with ¿ and ¡
  (`test/core/l10n/arb_spanish_punctuation_test.dart`); feature names
  inside a sentence are quoted with « ».
- **Layout tests run in Japanese and Spanish** at `testPhoneWidths`
  (`test/helpers/test_helpers.dart`). Japanese uses the default test
  font, whose 1em glyphs match kana and kanji. Spanish loads Roboto from
  `test/fonts/` with `loadTestFonts()` and runs at
  `robotoToSfWidthFactor` of each width, because the default test font
  draws Latin letters 1em wide. Roboto has no kana and stays loaded for
  the rest of the file, so a Japanese case in the same file sets
  `fontFamily: 'FlutterTest'` in its theme.
- **Spanish data text follows the same number marks.** `factEs` in
  `data/app/eco_facts.json` and `data/app/eco_dex_entries.json` uses the
  decimal comma and period grouping
  (`test/core/l10n/spanish_fact_numbers_test.dart`).

- Dates use `DateFormat.MMMd(locale)` with
  `Localizations.localeOf(context).toLanguageTag()`.
- Japanese has no spaces and wraps differently. Axis and legend labels
  must survive roughly 1.5x the English width, and Japanese dates are
  longer in `MMMd` form.
- SDG indicator `definition` and `unit_of_measure` in
  `data/reference/sdg_indicator_metadata/` are **English only**.

---

## 9. Pre-handoff checklist

- [ ] Renders in `seed` (green) and `coral` (blue) seeds, light and dark.
- [ ] No hardcoded colour that should have been a `ColorScheme` role.
- [ ] No SDG colour used for text or a stroke under 2px.
- [ ] No two same-cluster SDG colours adjacent without a second cue.
- [ ] Legible in greyscale.
- [ ] Spacing and radii come from `ui_constants.dart` names.
- [ ] Card is `surfaceContainerLow` + `borderRadiusMd`.
- [ ] Title is `titleSmall` at `w600`.
- [ ] Widget takes its entity as a parameter, reads no provider.
- [ ] Every string is localised; checked at JA width.
- [ ] Any explainer uses the shared info widgets.
- [ ] Empty and "no data" states designed, not afterthoughts.
