# PDR: Mascot Redesign -- Code-Drawn Characters

**Created:** 2026-11-21
**Status:** APPROVED for rollout step R1. Owner answered the
section 9 questions on 2026-11-21. The R1 prototype is in code. The
owner chose the outlined variant (Q4). The code-drawn generation is
named **v3**. It follows the Rive files `sprout_v2` and `coral_v2`,
which are its design baseline. The rest look of all 12 v3 characters
(4 stages each of Sprout, Coral and Funghi) is in code for owner
review.
**Purpose:** Research brief (DOCUMENT_TYPES 4b). Decide whether
Seed replaces its image-based Rive mascots with characters drawn
and animated from Dart code, and define the style, rig, gestures,
and rollout if it does.
**Companion docs:** [PLAN_PHASE_7.md](./PLAN_PHASE_7.md) (7.1 art,
7.2 integration, 7.3 shop), [STYLE_GUIDE.md](./STYLE_GUIDE.md)
(sections 1, 2.1, 6.3), [PLAN_MASTER.md](./PLAN_MASTER.md) ("Art
Assets Decision"), [PLAN_FOR_DESIGNER.md](./PLAN_FOR_DESIGNER.md)
(species 3 candidates).
**Not held here:** stage level thresholds and species names live in
`data/app/mascot_species.json`. Brand colours live in
`lib/core/theme/app_colors.dart`. This document cites them and does
not restate them.

---

## 1. Why this exists

Each mascot stage today is a painted image in a Rive artboard. The
pipeline for one stage is: generate a painting, split it into PNG
parts with an image model, rig the parts in the Rive editor, then
keyframe each motion by hand. This has three costs.

1. **Gestures are slow to add.** The Sprout artboards hold one
   raster body image and no bones. A wave or a hop has nothing to
   move except the whole image. Every new gesture is manual
   keyframe work in the editor, per stage, per species.
2. **Edits are slow and opaque.** A change to an arm or a colour
   means a new image round and a re-rig. A reviewer cannot read the
   change in a diff.
3. **Cosmetics do not fit.** Each evolution stage has a different
   silhouette, so a hat or scarf drawn for one stage does not fit
   the next. The October 2026 exploration preferred environment
   items for this reason.

With 3 species x 4 stages, these costs repeat twelve times.

## 2. What we learned

### 2.1 The procedural horse

A public demo showed a 3D horse built by Claude with no image or
model files. The body is built from signed-distance fields, meshed
and rigged when the page loads, then animated in code with inverse
kinematics for the hooves. The model screenshotted its own output,
criticised it, and fixed it in several rounds.

- **Transferable:** the shape and the motion are functions of
  parameters. A new gait is new code, not new keyframes. The
  render-criticise-fix loop works.
- **Not transferable:** the look. A meshed signed-distance field
  gives a smooth, glossy 3D look, which is not the Seed look. The
  demo also runs in a browser on Three.js, not in Flutter.

### 2.2 Authored vector bodies (rejected July 2026)

A pilot drew the Sprout stage 1 body as hand-authored vectors that
traced the painting. The result never matched the painted style,
and each fix took several rounds. **The lesson is about tracing,
not about code.** Code art fails when it imitates a painting. It
works when the character is designed for code from the start.

### 2.3 Rendering cost

Profiling on the Pixel 8 showed that every live Rive instance pays
advance and paint costs each frame. The face rig script keeps the
state machine active all the time. Non-hero instances (thumbnails,
timeline, previews) are paused to save frame time. The Rive GPU
renderer was slower than the Flutter renderer on Android. The
replacement must match or beat the current build on the same
device and screens (section 7).

### 2.4 How Claude checks visual work

Claude perceives a drawing only through an image. The loop is made
fast with:

- golden tests that render to PNG headless in seconds,
- contact sheets that put every stage and pose in one image,
- number checks that need no image (feet on the ground line,
  anchors inside bounds, left and right sides symmetric),
- the iOS Simulator for motion feel and touch.

The Dart and Flutter MCP server (`dart mcp-server`) ships with the
installed SDK. It offers hot reload, runtime errors and the widget
inspector. It is not configured for this project, and it is
optional.

## 3. Options considered

| Option | Look | Edit speed | Fit with Flutter | Verdict |
|---|---|---|---|---|
| A. Keep Rive, add bones to PNG parts, write gestures in Luau | Keeps the painted look | Better, but every stage still needs a rig and image work | Current path | Fallback if B fails review |
| B. 2D characters drawn with `CustomPainter` | Soft flat (section 4.1) | Best. Shape, colour and motion are all code | Native. No new dependency | **Recommended** |
| C. Fragment shader (GLSL) with signed-distance fields | Soft lit, near 3D | Good | Native (`FragmentProgram`), but shader tests are fragile | Deferred (M10) |
| D. Real 3D (`flutter_scene`, or a WebView with Three.js) | Glossy 3D | Good | Experimental or a second render stack | Rejected |
| E. Pixel art | Retro | Medium | Native | Rejected again: off-brand per PLAN_MASTER |

## 4. Proposed decisions

Decision ids are permanent (DOCUMENT_TYPES rule 10).

### M1. Draw mascots with `CustomPainter`

Each species is Dart code that paints with `Canvas`. Use no new
package. Hot reload shows each edit at once.

### M2. Style: "soft flat"

Keep the rules in STYLE_GUIDE section 1: warm, hopeful, cute but
not childish. Change section 2.1 as follows:

| Property | Current rule | Proposed rule |
|---|---|---|
| Fills | Solid colour only | Solid colour, plus at most one shade shape and one highlight shape per part, as flat shapes. No blur, no gradients |
| Outlines | None | One thin dark outline on every body part. Owner's choice from the R1 contact sheet (Q4) |
| Shadows | None | Unchanged: none. No ground shadow (Q5) |
| Geometry | Soft rounded shapes | Unchanged. Every shape is built from circles, ellipses and smooth curves |

The shade and highlight shapes give volume without leaving the
flat style that the Eco-Dex art and the app UI use.

### M3. One shared rig of named joints

Every species uses the same small skeleton:

```
root -> body -> head -> faceAnchor, topAnchor
             -> armL, armR -> handL, handR
             -> footL, footR
```

- A **pose** is a set of joint offsets and angles.
- A **gesture** is a function from time to pose.
- The painter draws each part relative to its joint, so one gesture
  works on every species and every stage.
- A species with no visible arms (for example a stage 1 seed)
  still has the joints. Its gestures move the body instead.

### M4. Evolution is a set of parameters

A stage is a parameter set: body size, proportions, leaf or branch
count, colour accents. It is not a separate drawing. Benefits:

- The evolution celebration can morph one stage into the next.
- A new stage is a new parameter set, not a new art round.
- The four stages and their level thresholds in
  `mascot_species.json` do not change.

### M5. One shared face for all species

A shared `FacePainter` draws the eyes and mouth for every species.
It ports the face rules already decided for the Rive face (eye
design "G, ButtonPupil"):

- vertical oval eyes with a visible pupil, never cut at the top and
  bottom (no sanpaku),
- one large and one or two small highlights, on the same side in
  both eyes,
- dark navy for eyes, never black,
- the eyes keep a minimum clear space from the body outline
  (`STYLE_GUIDE.md`, "Face placement minimum"),
- a soft, round-capped crescent for the smile, not a pointed arc,
- the blink open phase is longer than the close phase,
- a blink hides large jumps in gaze.

The full face report is outside this repo, in the SeedResources
folder. These rules are the part the code needs.

### M6. Cosmetics attach to anchors

Every stage exposes `topAnchor`, `handL`, `handR` and a neck point,
with a scale value. A shop item draws at the anchor and scales with
it, so one hat fits every stage. Environment items (the preferred
shop direction) need no anchors. This supports PLAN_PHASE_7 7.3
but does not change its item list.

### M7. Keep the interaction contract

The behaviour users see today stays:

- the eyes follow the finger anywhere on screen (gaze x and y),
- the mascot smiles when the action button is pressed,
- non-hero instances do not animate.

`MascotImage` stays the single entry point for every render site.
It chooses the code-drawn path by species id. The Rive path stays
for any species that has not migrated yet. The existing
`mascotSmileTriggerProvider` drives the smile.

### M8. One ticker, only for the hero

Only the hero mascot on Home and the Mascot tab owns a `Ticker`.
Thumbnails, the evolution timeline and previews paint one static
frame and never tick. The hero ticker stops when the screen is not
visible.

### M9. Golden contact sheets are the review artefact

Each species has:

- one golden test that renders all 4 stages x the key poses into a
  single contact sheet image,
- one golden test that renders all 4 stages x the rest, smile, wave
  and wink poses at portrait size into a single 4 x 4 sheet image,
- geometry tests for the number checks in section 2.4.

The owner approves style from the contact sheet. The simulator is
for motion feel only.

### M10. Shaders and 3D are deferred

Use a fragment shader only if soft flat cannot reach the agreed
look for a specific effect (for example water shimmer on Coral).
Real 3D stays rejected.

### M11. Retire Rive per species, then remove it

A species switches to code after it passes the section 7 criteria.
After the last species moves:

- remove `coral_mascot.riv` and `sprout_mascot.riv`,
- remove the `rive` dependency and the `rive_native` setup step in
  CI and in CLAUDE.md,
- remove `assetPath` and `artboardName` from `mascot_species.json`.

## 5. Character design brief

### 5.1 Shared body language

- Large head-to-body ratio, small rounded limbs, a low centre of
  mass. The character must read clearly at 48 dp.
- A bean or teardrop base body that every stage grows from.
- Motion is soft: ease in and out, small overshoot, never snappy.
- **No guilt.** The mascot never looks sad, sick or disappointed
  at the user (STYLE_GUIDE section 1). Low activity shows as calm
  or sleepy, never as unhappy.

### 5.2 Gesture set, first version

| Gesture | Trigger | Notes |
|---|---|---|
| Breathe | Always (hero only) | Slow scale on the body |
| Blink | Random interval | Face rules in M5 |
| Gaze | Finger position | Existing contract |
| Smile | Action button | Existing contract |
| Wave | Tap on mascot | Hand joint, or a body sway on armless stages |
| Hop | Action logged | Squash and stretch on landing |
| Nod | Challenge complete | Head joint |
| Sleep | Night-time or idle | Eyes closed, slower breathing |
| Celebrate | Evolution | Plays over the stage morph (M4) |

### 5.3 Species

Colours start from the brand palette and the species colours in
`app_colors.dart`. Final values are set from the contact sheet.

The body of each stage is wider and taller than the body of the
stage before it, so the character visibly grows. A test checks this.

**Sprout (data id `seed`).** Brand greens and earth browns. The four
stages must read as seed to tree, not as four seeds: stages 1 and 2
have an egg-shaped seed body, stages 3 and 4 have a tall trunk.

| Stage | Form |
|---|---|
| Seed | Small egg-shaped seed body with a tiny leaf nub on top. No arms. |
| Sprout | Taller seed body, two round seed leaves, round arms and feet. |
| Sapling | Tall trunk with almost straight sides and a shallow hem that flares only a little, round feet, a tuft of five leaves, twig arms. |
| Tree | Taller and wider trunk with a flared hem of three root toes, round feet, a round leafy canopy with small blossoms, twig arms. |

**Coral.** Periwinkle body, an aqua fringe along the base of the
body, and a coral-orange crown. The body is not ocean blue, because
the Coral theme background is ocean blue. The fringe stays well below
the eyes. The look must stay clear of existing commercial coral
characters: no pink body, no pale belly patches, no branch arms, no
tall thin branches.

| Stage | Form |
|---|---|
| Polyp | Soft round body with a short crown of tentacles. |
| Colony | One chunky coral sprig on the head, round fin arms. |
| Reef | Chunky branching coral crown, a small fish friend nearby. |
| Ecosystem | A reef garden as the crown: branching coral, tube sponges and a bubble coral. Sea grass at the feet and two fish. |

Coral is redesigned in code like every other species (Q2).

**Funghi (data id `fungi`).** Species 3 (Q3), from
PLAN_FOR_DESIGNER. A cap reads as a head, and the theme (fungi as
the planet's recyclers) fits Seed. It is the last species in the
rollout (R4). Cream stem body with the face on it, a tan cap, and a
mint glow that grows at every stage. Funghi has no Rive file, so the
drawings in the designer brief are its only baseline. The mouth is
a little smaller than the mouth of the other species, and a blush
shows at rest. From the Cap stage the eyes sit near the widest part
of the stem, at least two thirds of an eye height below the cap, so
that the cap reads as a hat and not as a brow. The eyes are set close
together, with a clear space between the eyes and the mouth. The
lower glow of the iris is the mint of the gills. Draw no pale
scalloped shape near the mouth, because it reads as teeth. The look
must stay clear of existing commercial mushroom characters: no red
cap, no round spots on the cap, always visible gills, always arms and
feet from stage 2.

| Stage | Form |
|---|---|
| Spore | Round cream ball with a glowing lower rim and one curled glowing thread on top. No arms. |
| Cap | Egg-shaped stem with a small tan dome cap, glowing gills under the cap, round arms and feet. |
| Colony | Larger cap with a glowing patch on top. One baby mushroom at each side, on short glowing threads. |
| Network | Wide cap with a glowing patch that drips, two baby mushrooms at each side on a longer thread network. |

## 6. Rollout

| Step | Work | Exit criteria |
|---|---|---|
| R1. Prototype | Sprout stage 2 in code with breathe, blink, gaze, smile and wave, on a debug-only route next to the current Rive Sprout. Contact sheet golden test with an outlined and an outline-free variant. | Owner approves the look and picks the outline variant (Q4) |
| R2. Sprout | All 4 stages, the full gesture set, stage morph, anchors. `MascotImage` dispatch by species id. | Section 7 criteria |
| R3. Coral | All 4 stages on the same rig | Section 7 criteria |
| R4. Funghi | Designed for code from the start | Section 7 criteria |
| R5. Remove Rive | M11 | `flutter analyze` and `flutter test` pass with no Rive code |

Production does not change until R2 ends.

The owner asked for the stage looks of all three species before
the gesture work. The v3 rest look of every stage is therefore
drawn first, with a cast line-up golden and one contact sheet golden
per species (M9). R2, R3 and R4 keep the rest of their scope: the
full gesture set, the stage morph, the anchors and the `MascotImage`
dispatch.

## 7. Acceptance criteria

1. The contact sheet for every species is approved by the owner.
2. The character reads clearly at 48 dp and at hero size.
3. The character looks correct in light and dark mode.
4. Gaze, smile and the pause behaviour of non-hero instances work
   as they do today (M7, M8).
5. Frame cost on the Pixel 8 in profile mode, on Home and on the
   Mascot tab, is equal to or lower than the current Rive build on
   the same screens. Measure on the device, never on the emulator.
6. Geometry tests pass for every stage: feet on the ground line,
   anchors inside bounds, symmetry where the design is symmetric.
7. `flutter analyze` and `flutter test` pass.

## 8. Risks

| Risk | Level | Mitigation |
|---|---|---|
| The code look is less charming than the paintings | High | R1 is a cheap gate. Option A stays as the fallback. |
| Existing users dislike a changed Coral | Medium | Coral moves after Sprout (R3), so the Sprout result informs the Coral design. |
| Style drifts between species | Medium | Shared rig, shared face, shared shade rules, one contact sheet per species |
| Frame cost on low-end Android | Low | One ticker, static non-hero frames, criterion 5 |
| Painter code grows hard to read | Medium | One file per species. Parts are small named functions. |

## 9. Owner decisions

Answered by the owner on 2026-11-21.

| Id | Question | Answer |
|---|---|---|
| Q1 | Move all mascots from the painted look to soft flat? | Yes. Every species moves eventually. |
| Q2 | Redesign Coral too? | Yes, same as Q1. |
| Q3 | Is Funghi species 3? | Yes, eventually. |
| Q4 | Outlines or outline-free? | Outlines. R1 rendered both variants and the owner picked the outlined one. |
| Q5 | Ground-contact shadow? | No. It adds complexity for jumps and for walking in the garden. |

## 10. Documents to update after approval

- `PLAN_MASTER.md` "Art Assets Decision": record the change from
  Rive to code-drawn characters.
- `PLAN_PHASE_7.md` 7.1 and 7.2: replace the AI art workflow and
  the integration steps, and record Funghi as species 3.
- `STYLE_GUIDE.md` 2.1 and 6.3: the soft flat rules (M2).
- `APP_PAGES.md`: the R1 debug route.
- `CLAUDE.md`: remove the Rive test setup note at R5.
