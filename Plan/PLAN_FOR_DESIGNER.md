# Designer Brief: Mascots, Garden & Cosmetics

## Table of Contents

1. [The Vision](#1-the-vision)
2. [Inspiration & References](#2-inspiration--references)
3. [Art Direction](#3-art-direction)
4. [Mascot Characters](#4-mascot-characters)
5. [Growing Ecosystem (Garden)](#5-growing-ecosystem-garden)
6. [Cosmetic Items](#6-cosmetic-items)
7. [Animation Catalogue](#7-animation-catalogue)
8. [Rive Technical Guide](#8-rive-technical-guide)
9. [Deliverables & Checklists](#9-deliverables--checklists)
10. [Rive Resources & Links](#10-rive-resources--links)

---

## 1. The Vision

Seed is a sustainability habit-tracking app for iOS and Android. Users
log eco-friendly actions in their daily life — cycling to work, eating
plant-based, recycling, learning about climate — and earn points that
level up a virtual mascot companion. The mascot evolves through 4
stages as the user grows, and the user's actions literally grow a
garden around it.

The emotional core of the app is **watching your impact come to life.**
Every action a user logs makes something grow — a plant appears in the
garden, the mascot gets happier, progress becomes visible and tangible.
The mascot is the user's companion on their sustainability journey.
Users name it, dress it up, and feel connected to it.

**What we need from you:**
- 3+ mascot species, each with 4 evolution stages (cute characters
  that grow from tiny to majestic as the user levels up)
- A garden scene that fills with plants and wildlife as the user
  takes real-world eco-actions
- Cosmetic items (hats, accessories, backgrounds) users can earn and
  equip on their mascot

Everything is built in **Rive** so the characters and garden are
interactive and animated in the app, not static images.

---

## 2. Inspiration & References

### The Feeling We're Going For

- **Duolingo's Duo** — a single character with rich personality
  expressed through animation. Duo celebrates with you, looks sad when
  you miss a day, reacts when you tap. Built in Rive. This is the
  gold standard for what we want our mascots to feel like.
- **Tamagotchi / Neko Atsume** — the joy of nurturing a virtual
  creature. Low-stakes, cozy, rewarding.
- **Animal Crossing (Pocket Camp)** — decorating a personal space with
  items you've earned. The garden should give this same feeling of
  "I built this."
- **Forest App** — growing a tree by staying focused. Simple
  evolution from seed to tree. Our Sprout species follows this arc.

### What Makes It Work

The characters need to be **expressive at small sizes**. On the home
screen, the mascot displays at just 160px. At that size, personality
comes from silhouette, large eyes, and animation — not from fine
detail. Think bold shapes, clear expressions, readable emotions.

The garden needs to feel **alive and growing**. When the user opens
the app and sees a new plant has appeared, or an existing one has
grown taller, that's the reward. The empty garden at the start should
feel inviting (not barren), and the full garden should feel lush and
satisfying.

---

## 3. Art Direction

**Style:** Cute, friendly, approachable. Kawaii-influenced but not
overly childish — the app targets environmentally-conscious adults and
teens. Characters should feel warm and motivating.

**Readability:** Expressions and silhouettes must read clearly at 80px.
Avoid thin lines and small details that disappear at small sizes. Bold
shapes, large expressive features, minimal outlines.

**Palette:** Earth tones and nature-inspired colours. Each species has
its own colour family (see species section below). The garden uses a
unified natural palette that works with any species combination.

**Consistency:** All species should feel like they belong in the same
world — same level of detail, same emotional expressiveness, compatible
proportions so cosmetic items work across them.

### Sizing Reference

| Context | Display Size |
|---------|-------------|
| Home screen mascot card | 160px |
| Mascot detail / garden view | ~300px |
| Notification icon | 80px |
| Garden scene | Full screen width (~375pt) |

Design at higher resolution for crispness on retina displays (see
artboard sizes in Section 8).

---

## 4. Mascot Characters

### 4.1 How Species Work

Each species has **4 evolution stages** tied to the user's level:

| Stage | Level Threshold | What Happens |
|-------|----------------|--------------|
| 1 | Level 1 (start) | The mascot's initial tiny form. |
| 2 | Level 10 | First evolution — growing, more defined. |
| 3 | Level 25 | Second evolution — complex, confident. |
| 4 | Level 50 | Final form — majestic, fully realised. |

The user **names** their mascot, so every stage must be recognisably
the same character. The personality, face, and core silhouette should
carry through — each stage adds complexity and grandeur, not a
completely different design.

When a mascot reaches stage 4 (max), the user can receive an **egg**
that hatches into a new species after 30 days of activity. The stage 1
form should work as a curled-up / enclosed egg shape.

### 4.2 Species Candidates

We need **minimum 3 species** to ship. Sprout is confirmed as the
free starter. The rest are candidates — **pick whichever concepts
inspire the best character designs.** Skip any that don't feel right.
Propose your own if you have a concept that fits the sustainability
theme. Deliver in whatever order works for your creative process.
We can always add more species later.

#### Sprout (Plant Theme) — CONFIRMED, Free Starter

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Seed | A tiny round seed with sleepy eyes, just beginning. |
| 2 | Sprout | Small green shoot with a leaf or two, expressive eyes. |
| 3 | Sapling | Young tree with branches, more defined face, foliage. |
| 4 | Tree | Majestic tree with full canopy, wise expression. |

Colour family: Greens, warm browns, leaf gold.

#### Coral (Ocean Theme)

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Polyp | Tiny coral polyp, blobby and cute. |
| 2 | Colony | Small branching coral form, developing features. |
| 3 | Reef | Complex reef structure with vibrant character. |
| 4 | Ecosystem | Full reef ecosystem, majestic and alive. |

Colour family: Ocean blues, teals, coral pink.

#### Funghi (Mycelium Theme)

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Spore | Tiny floating spore, round and curious. |
| 2 | Cap | Small mushroom with a rounded cap, friendly face. |
| 3 | Colony | Cluster of mushrooms, interconnected, glowing softly. |
| 4 | Network | Sprawling mycelium web with fruiting bodies — the wood wide web. |

Colour family: Earthy browns, bioluminescent blues/greens, cream.
Why it fits: Fungi are the planet's recyclers and connectors —
the mycelium network mirrors how small actions connect to form
big impact.

#### Breeze (Wind / Air Theme)

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Wisp | A tiny puff of air with a gentle face. |
| 2 | Gust | Swirling wind form with leaf-like features. |
| 3 | Cloud | Friendly cumulus shape with a defined personality. |
| 4 | Sky | Vast, serene sky spirit with flowing forms. |

Colour family: Soft whites, sky blues, silver, pale green.
Why it fits: Clean air, wind energy, the atmosphere we're
protecting.

#### Terra (Earth / Soil Theme)

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Pebble | A small round stone with curious eyes. |
| 2 | Rock | A mossy boulder with character. |
| 3 | Mountain | A mini mountain with trees and a face in the cliff. |
| 4 | Continent | A living landmass, lush and thriving. |

Colour family: Stone greys, rich browns, moss green, terracotta.
Why it fits: Grounding, land conservation, soil health — the
foundation everything grows on.

#### Bloom (Pollinator Theme)

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Bud | A tiny closed flower bud, sleepy. |
| 2 | Flower | An open bloom with petals framing a face. |
| 3 | Bee | A flower-bee hybrid, buzzing and busy. |
| 4 | Meadow | A living meadow creature, flowers and pollinators in harmony. |

Colour family: Bright yellows, wildflower purples, petal pinks,
honey gold.
Why it fits: Biodiversity, pollination, the interconnection of
species.

#### Dewdrop (Freshwater Theme)

| Stage | Name | Description |
|-------|------|-------------|
| 1 | Drop | A single water droplet with a shimmering surface. |
| 2 | Stream | A flowing water form, playful and quick. |
| 3 | River | A wider, calmer water body with aquatic life hints. |
| 4 | Lake | A serene lake spirit, reflecting the sky. |

Colour family: Crystal blues, aquamarine, gentle greens, white foam.
Why it fits: Water conservation, freshwater ecosystems, the water
cycle.

### 4.3 Design Constraints

- Every stage must be **recognisably the same character.** The user
  named it — visual continuity matters.
- Silhouette should grow more complex with each stage but the core
  face and personality stay consistent.
- All stages share the **same bone rig structure** so cosmetic items
  (hats, accessories) attach to the same anchor points across stages.
  Provide a hat anchor bone at the top of the head and an accessory
  anchor bone at the body centre.
- The stage 1 form doubles as an **egg** — design it to work
  curled up or enclosed.
- Translations (JA / ES names) will be handled by the developer —
  don't worry about naming in other languages.

---

## 5. Growing Ecosystem (Garden)

### 5.1 The Concept

The garden is the user's personal ecosystem. The mascot lives here,
and plants appear and grow as the user takes real-world eco-actions.
Each plant is tied to a category of action — transport actions grow an
oak tree, food actions grow an herb garden, and so on. The garden
starts nearly empty and gradually fills up, giving the user a visual
representation of their cumulative impact.

### 5.2 Scene Layout

```
┌─────────────────────────────────────────────┐
│  Sky / background gradient                  │
│                                             │
│   [Birdhouse]          [Bird]               │
│        [Oak]     [Bamboo]    [Sunflower]    │
│   [Fern]    [MASCOT]    [Herb Garden]       │
│     [Mushrooms]   [Pond]   [Wildflowers]    │
│  [Coral]  [Vine]  [Bench]  [Cactus]        │
│                                             │
│  ─────── Ground / grass ───────             │
│   [Butterfly]                               │
└─────────────────────────────────────────────┘
```

The mascot sits at a fixed central position. Plants populate around it
as they unlock. Empty slots show a faint outline or bare soil patch to
hint at what can grow there.

### 5.3 Plant & Element Catalogue

Each element has **4 visual states**: empty/locked (bare soil or faint
outline), and 3 visible growth stages (sprout, growing, full). The app
drives which state is active via a number input per plant.

| # | Element | What Unlocks It | Visual Progression |
|---|---------|-----------------|-------------------|
| 1 | Oak Tree | Transport actions | Tiny sapling > young tree > full oak |
| 2 | Sunflower | Energy actions | Seed > stem with bud > tall sunflower |
| 3 | Herb Garden | Food actions | Bare soil > small herbs > lush herb patch |
| 4 | Coral | Water actions | Tiny polyp > small coral > branching reef |
| 5 | Fern | Waste/Recycling actions | Fiddlehead > unfurling fronds > full fern |
| 6 | Wildflowers | Community actions | Single bud > small cluster > field of flowers |
| 7 | Bamboo | Advocacy actions | Short stalk > growing cane > tall bamboo grove |
| 8 | Mushrooms | Learning actions | Single cap > small cluster > fairy ring |
| 9 | Vine | Shopping actions | Tendril > climbing vine > flowering vine wall |
| 10 | Cactus | Streak milestones | Small round cactus > taller > flowering cactus |
| 11 | Pond | Total action count | Puddle > small pond > pond with lily pads |
| 12 | Butterfly | User level | Caterpillar > cocoon > butterfly in flight |
| 13 | Bird | Eco-Dex entries | Egg in nest > chick > bird hopping/flying |
| 14 | Bench | Challenges completed | Logs > simple bench > bench with cushion |
| 15 | Birdhouse | SDG coverage | Post > simple box > painted birdhouse |

### 5.4 Architecture: One .riv, Nested Components

The entire garden lives in **one file: `garden_scene.riv`**. Each
plant is a separate **Component artboard** nested inside the main
garden artboard. This means:

- Each plant is its own self-contained artboard with a Solo for its
  4 states (empty + 3 growth stages) and a number input (`stage`,
  0-3) exposed to the parent.
- The parent garden artboard positions all 15 plant instances on the
  scene, plus the mascot slot and the ground/sky layers.
- The parent's state machine wires to each plant's exposed `stage`
  input — the app sets one number per plant to control what's visible.
- Ambient animations (leaf sway, water ripple, butterfly flutter)
  run on a separate layer in the parent state machine.

This approach keeps everything in one file for easy handoff while
staying modular — individual plants can be edited independently
without breaking the scene.

### 5.5 Garden Design Requirements

- **Cohesive scene:** All elements must feel like they belong in the
  same garden. Unified ground plane, consistent lighting direction
  (top-left), consistent level of detail.
- **Layered depth:** Front elements overlap rear. Use subtle size
  scaling for depth (back ~80%, front ~110%).
- **Empty state:** A bare garden with just the mascot and soil patches
  is the starting state. It should feel inviting, not desolate — the
  mascot's presence makes it feel alive.
- **Growth transitions:** When a plant advances a stage, play a brief
  grow animation (0.3-0.5s scale + sprouting effect).
- **Ambient animations:** Gentle leaf sway, butterfly flutter, water
  ripple, bird hopping. These loop continuously and bring the scene
  to life.
- **Tap regions:** Each plant and the mascot need invisible hit areas
  (Rive Listeners) so the app can detect taps and show info overlays.

---

## 6. Cosmetic Items

Items the user earns with points and equips on their mascot.

### 6.1 Item Types

| Type | Where It Goes | Notes |
|------|--------------|-------|
| Hat | Top of head | Sits on the hat anchor bone, follows head rotation |
| Accessory | Body/face region | Glasses, scarves, badges — on the accessory anchor bone |
| Background | Behind mascot | Replaces the default background in the mascot detail view |

### 6.2 Items to Design

**Initial items:**

| Item | Type | Visual Description |
|------|------|--------------------|
| Party Hat | Hat | Colourful cone hat with a pom-pom |
| Leaf Crown | Hat | Woven crown of green leaves |
| Tiny Sunglasses | Accessory | Cool round shades |
| Forest Background | Background | Lush forest with dappled light |
| Ocean Background | Background | Calm ocean with gentle waves |

**Premium items (lower priority):**

| Item | Type | Visual Description |
|------|------|--------------------|
| Golden Crown | Hat | Sparkling golden crown |
| Rainbow Trail | Accessory | Colourful particle trail |
| Aurora Background | Background | Northern lights |
| Starfield Background | Background | Night sky with shooting stars |
| Diamond Badge | Accessory | Glowing diamond emblem |

### 6.3 Cosmetic Design Requirements

- Hats and accessories attach to anchor bones on the mascot rig.
  They must look right on every species and every evolution stage.
- Items scale proportionally — a hat designed for stage 1 should
  still feel right on stage 4.
  - Set per-stage scale values on the `hatAnchor` and
    `accessoryAnchor` bones (see §8.3) so cosmetics scale
    automatically with each evolution stage — no need to redraw
    or rescale items per stage.
- Backgrounds are separate .riv files with subtle ambient animation
  loops (swaying trees, drifting clouds, twinkling stars).
- Each item needs a **static 256x256px SVG thumbnail** for the shop
  catalogue in the app.

---

## 7. Animation Catalogue

### 7.1 Mascot Animations

| Animation | Type | Duration | When It Plays |
|-----------|------|----------|---------------|
| Idle | Loop | 2-4s cycle | Default state — always playing |
| Blink | One-shot (layered) | 0.3s | Random interval, every 3-8s |
| Happy bounce | One-shot | 0.5s | User logs an eco-action |
| Tap wiggle | One-shot | 0.4s | User taps the mascot |
| Sad/sleepy | Loop | 3s cycle | User's streak is broken |
| Celebrating | One-shot | 1.5s | Level up or challenge complete |
| Evolution | One-shot | 2-3s | Mascot reaches a new stage |
| Egg rock | Loop | 2s cycle | While the mascot is in egg form |
| Egg hatch | One-shot | 2s | Egg hatching into a new mascot |

### 7.2 Garden Animations

| Animation | Type | Duration | When It Plays |
|-----------|------|----------|---------------|
| Leaf sway | Loop | 3-5s | Ambient — always, on trees/plants |
| Water ripple | Loop | 4s | Ambient — while pond exists |
| Butterfly flutter | Loop | 2s | Ambient — while butterfly exists |
| Bird hop | Loop | 5s | Ambient — while bird exists |
| Plant grow | One-shot | 0.5s | Plant advances a growth stage |
| Plant appear | One-shot | 0.4s | Plant unlocks for the first time |

### 7.3 Background Animations

| Animation | Type | Duration |
|-----------|------|----------|
| Forest sway | Loop | 5s |
| Ocean waves | Loop | 4s |
| Aurora shimmer | Loop | 6s |
| Star twinkle | Loop | 3s |

---

## 8. Rive Technical Guide

Detailed reference for building these assets in Rive. Read alongside
the official docs linked in each subsection.

### 8.1 Artboard Sizes

| Content | Artboard Size | Display Size |
|---------|---------------|--------------|
| Mascot (each stage) | 512x512 | 80-300px |
| Garden scene | 1024x768 | Full screen width |
| Plant components | 128x128 to 256x256 | Varies by position in garden |
| Background cosmetics | 512x512 | 300px |
| Cosmetic items (hats, accessories) | 256x256 | Proportional to mascot |

### 8.2 Solos for Stage Switching

Solos act like a radio group — only one child renders at a time. The
runtime **skips computing and rendering** deactivated children
entirely, which is a big performance win over animating opacity to 0%.

**How to set up 4 evolution stages in one artboard:**

1. Build all 4 stage groups (each with its own shapes/rig).
2. Select all 4 groups in the Hierarchy.
3. Right-click > "Wrap in Solo."
4. In the state machine, add a **number input** (`evolutionStage`,
   1-4) and drive which Solo child is active via timelines keyed
   to each input value. (The radio buttons on the Solo in a
   timeline row are how you pick the active child per keyframe.)

Use Solos for:
- Mascot evolution stages (4 children per Solo).
- Plant growth stages (4 children per Solo: empty + 3 growth stages).
- Cosmetic item variants.

Docs: https://rive.app/docs/editor/manipulating-shapes/solos

### 8.3 Bones, Constraints & Rigs

Bones reduce keyframe count dramatically. A bone hierarchy where
moving a parent affects children is the foundation of character
animation in Rive.

**Setting up IK (Inverse Kinematics):**

1. Create a bone chain with the Bone tool (`B`).
2. Create a target group (`G`), set Style to Target in the Inspector.
3. Select the last bone, add an IK Constraint, assign the target.
4. Move the target to verify the chain follows.
5. "Bone Count" controls how far up the chain IK reaches.
6. "Invert Direction" flips the solve angle.
7. Strength (0-100%) is animatable for FK/IK blending.

**Sharing rigs across evolution stages:**

Build one bone hierarchy and duplicate it inside a Solo for each
stage variant. This ensures:
- Cosmetic items (hats, accessories) are children of the appropriate
  bone and inherit transforms automatically.
- The same bone names exist in every stage, so accessories always
  attach to the same point.
- The **hat anchor** is a bone at the top of the head.
- The **accessory anchor** is a bone at the body centre.

**Performance:** Keep rigs simple. Use parent-child relationships
for shapes driven by a single bone. Only use explicit skinning
(binding a mesh to multiple bones so vertices blend between them)
where a shape genuinely needs to deform across joints. Test on
real devices early.

Docs: https://rive.app/docs/editor/constraints/ik-constraint

### 8.4 Mesh Deformation

Meshes add vertex-level deformation to shapes (squash-and-stretch,
fabric ripple, facial expressions).

| Use Case | Approach |
|----------|----------|
| Limb articulation, rigid motion | Bones only |
| Organic deformation (face, body squash) | Mesh bound to bones |
| Cloth, hair, tentacles | Mesh with bone chain |
| Simple position/rotation/scale | Parent-child (no mesh) |

Start sparse — add mesh vertices only where deformation quality
demands it. Most mascot shapes should need 10-30 vertices at most.

Docs: https://rive.app/docs/editor/manipulating-shapes/meshes

### 8.5 Nested Artboards (Components)

Components are how the garden scene contains individual plants and
a mascot — each is a separate artboard nested inside the parent.

**Setup:**

1. Mark an artboard as a Component (`Shift+N` or toggle in Inspector).
2. Place instances with the Component Tool (`N`).
3. Only Component-flagged artboards export to the .riv file.

**Exposing inputs to the parent:** Select an input on the component's
state machine, check "expose to main artboard." The parent can then
drive the input from its own state machine. This is how the garden
scene controls each plant's growth stage.

**Instance modes:**

| Mode | Behaviour | Use For |
|------|-----------|---------|
| Node | Scales with parent via Scale property | Default |
| Leaf | Positions/resizes with Fit options (Contain, Cover, Fill) | Plants — use `Fit: Contain` |
| Layout | Artboard resizes to reflow internal Layouts | Not needed for us |

Docs: https://rive.app/docs/editor/fundamentals/nested-artboards
Blog: https://rive.app/blog/components-are-here-nested-artboards-done-right

### 8.6 State Machine Patterns

**Layers:** Each layer plays one animation state at a time. Use
multiple layers for simultaneous tracks (e.g., body movement + facial
expression + mood overlay). Rightmost layers override leftmost when
both affect the same properties.

**Inputs:**

| Type | Behaviour | Example |
|------|-----------|---------|
| Boolean | On/off toggle, stays at value | `isStreakBroken` |
| Number | Continuous value, stays at value | `evolutionStage` (1-4) |
| Trigger | One-shot fire-and-forget, auto-resets | `onTapped` |

**Blend States** (special state types that mix multiple timelines
at once instead of playing just one):

- **1D Blend State:** Mixes N timelines driven by a single number
  input. Great for smooth transitions between stages.
- **Additive Blend State:** Mixes N timelines each with its own
  number input. Use for facial rigs where brow, mouth, eyes are
  independent.

**Special states:**

- **Any State:** Fires regardless of current state — use for global
  interrupts (tap reactions, skin switching).
- **Entry State:** Starting point when the state machine loads.
- **Exit State:** Stops the layer.

Docs: https://rive.app/docs/editor/state-machine
Blog: https://rive.app/blog/how-state-machines-work-in-rive

### 8.7 Listeners & Hit Regions

Listeners define tappable areas. Each Listener has:

1. **Target:** The shape(s) defining the hit area.
2. **User Action:** Pointer Down, Pointer Up, Click, etc.
3. **Listener Action:** Fire a trigger, set a boolean/number, etc.

**Best practices:**

- Use a dedicated rectangle/ellipse at **0% opacity** as the hit
  target — this gives precise tap regions independent of the art.
- Set **Opaque Target ON** so events don't pass through to elements
  behind.
- Each garden plant needs a Listener firing a named trigger
  (e.g., `plant01Tapped`). The mascot slot needs `mascotTapped`.

Docs: https://rive.app/docs/editor/state-machine/listeners

### 8.8 Data Binding (Optional)

Rive's newer system for connecting design to runtime data. Instead
of raw inputs, you define a View Model with typed Properties
(number, string, colour, boolean, image) and bind them to design
values. Converters can transform values (number-to-string, etc.).

Good for: mascot name display, points counter, streak count, plant
names. Not required for animation state machines — inputs are fine
for those.

Docs: https://rive.app/blog/getting-started-with-data-binding

### 8.9 Performance Guidelines

**File size budgets.** Export and check the file size after each
major addition. If the absolute cap is exceeded, simplify (fewer
mesh vertices, fewer keyframes, swap blend modes for colour
changes, Solos over opacity) before continuing.

| File | Target | Absolute cap |
|------|--------|-------------|
| Mascot .riv (4 stages + all animations) | ≤300KB | ≤500KB |
| Garden scene .riv (full scene + 15 nested plants + ambient) | ≤1.5MB | ≤2MB |
| Background .riv (each) | ≤150KB | ≤300KB |
| Cosmetic items .riv (all items combined) | ≤500KB | ≤1MB |

These budgets are generous for Rive — typical character .riv files
land between 50–200KB. If you're well under, great. If you're
brushing the cap, apply the optimisations below.

- **Vectors:** Minimise vertex counts. Redraw in Rive's native tools
  rather than importing complex SVGs.
- **Blend modes:** Use sparingly — expensive on mobile. Prefer colour
  changes or opacity.
- **Clipping:** Apply to specific objects, not entire artboards.
- **Images:** Match dimensions to display size. Use WebP. Consider
  out-of-band loading for large images.
- **Solos over opacity:** Always. The runtime skips deactivated Solo
  children entirely.
- **Unused artboards:** Remove before export — they still get parsed.
- **Font subsetting:** Only include needed glyph ranges.
- **Test early:** Run a file-size baseline after importing assets.
  Test on real low-end devices at 60fps.

Docs: https://rive.app/docs/getting-started/best-practices
Blog: https://rive.app/blog/a-designer-s-guide-to-optimizing-files-and-workflows

### 8.10 Libraries (Cross-File Reuse)

Rive Libraries let you publish a Component once and reuse it across
multiple .riv files. Changes to the source propagate everywhere.

Use case: if the mascot needs to appear in both its own .riv and the
garden scene, publish it as a Library rather than duplicating.

Blog: https://rive.app/blog/libraries-publish-once-reuse-everywhere-in-your-project

### 8.11 Export

- Export as **.riv** (binary): Export > Download >
  **"For newest runtime."**
- **Object names are NOT exported by default.** Right-click objects
  in the Hierarchy and toggle "Export name" for anything the
  developer needs to reference (artboards, inputs, state machines).
- Remove unused artboards before exporting.
- Run a file-size baseline after importing assets, before animating.

Docs: https://rive.app/docs/editor/exporting/exporting-for-runtime

---

## 9. Deliverables & Checklists

### 9.1 Overview

| File | Contents |
|------|----------|
| `mascot_{species}.riv` (x3+) | One per species — 4 evolution stages + all animations |
| `garden_scene.riv` (x1) | Full garden with 15 nested plant components + mascot slot |
| `cosmetic_items.riv` (x1) | All hats and accessories as component artboards |
| `bg_{name}.riv` (x4-5) | One per animated background |
| Thumbnails (x10 SVG) | 256x256 shop catalogue images |
| Source files (x1 set) | .rev editor files for future edits |

### 9.2 Checklist: mascot_{species}.riv

One file per species. All species use the same structure so the app
code is species-agnostic.

**Artboards & structure:**
- [ ] Single main artboard (512x512)
- [ ] Solo group containing 4 stage variants (stage 1-4)
- [ ] Each stage variant shares the same bone hierarchy and naming
- [ ] Hat anchor bone at top of head (same name in all stages)
- [ ] Accessory anchor bone at body centre (same name in all stages)
- [ ] Egg variant (stage 1 curled up / enclosed)

**State machine (`mascot_sm`):**
- [ ] Layer 1 — Body: Idle (loop) + transitions to Happy, Tap,
      Celebrate, Evolve, each returning to Idle automatically
- [ ] Layer 2 — Face: Neutral (loop) + Blink at random intervals
- [ ] Layer 3 — Mood: Normal + Sad/Sleepy toggle

**Inputs (use these exact names):**
- [ ] `evolutionStage` — Number (1-4), controls which Solo child
      is active
- [ ] `onActionLogged` — Trigger, plays Happy bounce
- [ ] `onTapped` — Trigger, plays Tap wiggle
- [ ] `onLevelUp` — Trigger, plays Celebrating
- [ ] `onEvolve` — Trigger, plays Evolution transition
- [ ] `isStreakBroken` — Boolean, toggles Sad/Sleepy mood

**Animations:**
- [ ] `idle` — 2-4s breathing/swaying loop (1 per stage, or shared)
- [ ] `blink` — 0.3s one-shot, layered on Face
- [ ] `happy` — 0.5s bounce + sparkle one-shot
- [ ] `tap` — 0.4s wiggle one-shot
- [ ] `sad` — 3s sleepy/droopy loop
- [ ] `celebrate` — 1.5s celebration one-shot
- [ ] `evolve_1to2`, `evolve_2to3`, `evolve_3to4` — 2-3s morph
      transitions
- [ ] `egg_idle` — 2s gentle rocking loop
- [ ] `egg_hatch` — 2s cracking and emerging one-shot

**Export:**
- [ ] Export names enabled on: main artboard, state machine,
      all inputs
- [ ] Unused artboards removed
- [ ] File-size baseline checked

### 9.3 Checklist: garden_scene.riv

One file containing the full garden scene with all plants as nested
Components.

**Artboards & structure:**
- [ ] Main garden artboard (1024x768)
- [ ] Ground/grass base layer
- [ ] Sky/background gradient layer
- [ ] 15 plant Component artboards (see plant checklist below)
- [ ] 15 plant instances positioned in the garden layout
- [ ] 1 mascot slot (nested Component, or placeholder for runtime
      nesting via Library)

**Per-plant Component artboard:**
- [ ] Solo group with 4 states: empty (bare soil/outline), stage 1
      (sprout), stage 2 (growing), stage 3 (full)
- [ ] `stage` number input (0-3), exposed to parent
- [ ] Growth animation: 0.3-0.5s one-shot played on stage change
- [ ] Appear animation: 0.4s one-shot played on first unlock
- [ ] Ambient animation where applicable (leaf sway, water ripple)
- [ ] Invisible hit shape (0% opacity rectangle) for tap Listener
- [ ] Listener: `pointerDown` fires `{plantName}Tapped` trigger

**Parent state machine (`garden_sm`):**
- [ ] Per-plant input wired to each component's exposed `stage`
      input (`plant01Stage` through `plant15Stage`, Number 0-3)
- [ ] Ambient layer running continuous loops for all existing
      ambient elements
- [ ] `mascotTapped` trigger from the mascot slot Listener

**Plants to include (15 total):**
- [ ] Oak Tree (transport)
- [ ] Sunflower (energy)
- [ ] Herb Garden (food)
- [ ] Coral (water)
- [ ] Fern (waste/recycling)
- [ ] Wildflowers (community)
- [ ] Bamboo (advocacy)
- [ ] Mushrooms (learning)
- [ ] Vine (shopping)
- [ ] Cactus (streaks)
- [ ] Pond (total actions)
- [ ] Butterfly (level)
- [ ] Bird (eco-dex)
- [ ] Bench (challenges)
- [ ] Birdhouse (SDG coverage)

**Export:**
- [ ] Export names enabled on: main artboard, state machine, all
      inputs, all per-plant trigger names
- [ ] Unused artboards removed
- [ ] File-size baseline checked

### 9.4 Checklist: cosmetic_items.riv

All hats and accessories in one file as Component artboards.

- [ ] Each item is a separate Component artboard (256x256)
- [ ] Items designed to attach to the mascot's hat/accessory anchor
      bones
- [ ] Items tested visually against all species and evolution stages
      for proportion and fit
- [ ] Export names enabled on all artboards

### 9.5 Checklist: bg_{name}.riv

One file per animated background (Forest, Ocean, Aurora, Starfield,
plus any additional).

- [ ] Single artboard (512x512)
- [ ] Ambient animation loop (3-6s depending on content)
- [ ] State machine with entry to loop state
- [ ] Export names enabled on artboard and state machine

### 9.6 Checklist: Thumbnails

- [ ] 256x256px SVG for every cosmetic item (hats, accessories,
      backgrounds)
- [ ] Clean, centered, transparent background
- [ ] Consistent framing and lighting across all thumbnails

### 9.7 Checklist: Handoff Manifest

For each .riv file, include a short text file or section listing:
- [ ] All artboard names
- [ ] All state machine names
- [ ] All input names with their types and valid value ranges
- [ ] All trigger names and what they do
- [ ] Any notes on what "Export name" was enabled for

This lets the developer wire up the app integration without needing
to open the Rive editor.

---

## 10. Additional Rive Resources

Topic-specific docs and blog posts are linked inline in §8 next to
the concept they cover — start there. The resources below are extra
jumping-off points not already cited.

### Entry points

| Resource | URL |
|----------|-----|
| Rive Editor (main app) | https://rive.app |
| Full docs index | https://rive.app/docs |
| State machine states (sub-page) | https://rive.app/docs/editor/state-machine/states |
| State machine layers (sub-page) | https://rive.app/docs/editor/state-machine/layers |
| Data Binding for designer/developer handoff | https://rive.app/blog/data-binding-in-rive-a-shared-language-for-designers-and-developers |

### Community & Learning

| Resource | URL |
|----------|-----|
| Community file marketplace | https://rive.app/community/files/latest/ |
| Community forum | https://community.rive.app/ |
| Discord (19k+ members) | https://discord.com/invite/FGjmaTr |
| YouTube tutorials | https://www.youtube.com/@rive-app |
| Blog (all posts) | https://rive.app/blog |

### Key Caveat

Rive works well for discrete character states (idle, happy, evolution)
and ambient scene animations. Some production teams have reported
friction with deeply nested artboard rigs and complex input wiring.
For this project, keep the state machine architecture flat and use
Solos for variant switching. Test .riv file sizes and runtime
performance on real devices early.

---

## Summary

| Category | Files | Key Contents |
|----------|-------|-------------|
| Mascots | 3+ .riv | 4 stages each, ~8 animations per species |
| Garden | 1 .riv | 15 nested plant components + mascot slot + ambient |
| Cosmetic items | 1 .riv | All hats + accessories as components |
| Backgrounds | 4+ .riv | Animated loops |
| Thumbnails | 10+ .svg | 256x256 shop images |
| **Minimum total** | **9+ .riv, 10+ .svg** | |
