# PDR: Mascot idle motion

**Created:** 2026-11-07
**Status:** Round 1 open. Post-design review (type 4a): the standing
decisions and the motion specification for the mascot idle loops.
**Purpose:** The one place that says how a Seed mascot is supposed to
move at rest, why the rigs pivot where they do, and what a new stage
must satisfy before its `.riv` ships. The build order and the live open
list are in [PLAN_MASCOT_MOTION.md](./PLAN_MASCOT_MOTION.md); the
wiring facts for the Face rig and the view models are recorded in the
project memory and in `SeedResources/Rive/Mascots/*/rml/scene.rml`,
not restated here.

---

## 1. Decisions

**D1. The RML project is the source of truth.** Each species is a Rive
CLI project (`scene.rml` plus parts). The cloud editor file is a mirror
that `rive push` writes; the editor is where the owner reviews and
scrubs, not where the idle is authored. The v2 work is a copy of each
project directory, pushed as a new cloud file (`sprout_v2`,
`coral_v2`) so the originals stay intact on disk and in the cloud.

**D2. Sprout sways about the ground contact.** A rooted plant is a
cantilever fixed at the ground: the base does not translate, and lateral
displacement grows with height. The pivot is therefore the point where
the trunk or body meets the ground, implemented by moving the stage's
root node to that point and offsetting its children by the same amount,
never by keying a translation to fake it.

Alternatives considered: rotating about the node's current position
(mid-trunk at stages 3 and 4) makes the roots slide sideways on the
ground, which reads as the whole tree tipping; pairing that rotation
with a counter-translation needs two coupled tracks per stage and
breaks the moment the amplitude is tuned. Both rejected.

Re-pivot arithmetic, for a root node at `(x0, y0)` with uniform scale
`s` and a measured ground point at artboard `(bx, by)`: set the root to
`(bx, by)` and add `(x0 - bx) / s` to every direct child's `x` and
`(y0 - by) / s` to every direct child's `y`. The ground point is
measured from the frame-0 capture: the lowest row with opaque pixels
and the centre of the opaque run on that row. The capture after the
move must be pixel-identical to the one before it.

**D3. Secondary parts trail the driver.** Leaves, canopy, arms, legs and
crowns are keyed with the same shape as the driving track, offset later
in time. Offsets are fractions of the loop (section 2). The precedent
is the owner-authored `Coral_stage2` idle, whose lower arms trail the
uppers by 8 frames of 240.

**D4. Wind is one-directional, water is symmetric.** In the Sprout sway
every part leans the same way, so arm and leaf rotations carry the same
sign as the trunk. In the Coral float the left and right limbs mirror
each other, as `Coral_stage2` already does.

**D5. Loop lengths.** Coral keeps the existing 240-frame loop (4 s at
60 fps) so stages 3 and 4 match 1 and 2. Sprout uses 300 frames (5 s),
slower because a breeze reads slower than a bob. Both are starting
values for the owner's review.

**D6. Joints are nodes, not image origins.** A part that rotates about a
joint is wrapped in a `Node` placed at the joint, with the image as its
child, the pattern `Coral_stage2` already uses. Setting `originX` and
`originY` on the image would need a rotation-aware position correction
to keep the part where it is; a wrapping node is a pure re-parent.

**D7. The Face is never keyed by an idle.** Pupils, blink and mouth are
owned by the FaceRig script and the view model bindings. The nested
Face rides whichever parent carries the motion (Body or Head), so the
idle must move that parent, not the Face.

**D8. CLI, not the editor MCP, drives the work.** The editor MCP needs
a file tab active in the desktop app and cannot select one itself, and
it cannot screenshot a headless frame sequence. The CLI builds, captures
and inspects from a shell, which is what makes section 3 enforceable.

**D9. Coral stages 1 and 2 are unchanged in v2.** They are owner-authored
and the request is scoped to the frozen stages. Consistency work is an
open item in the plan.

**D10. Coral rest height is one convention for all four stages.** Every
shipped stage keys the root to `y = 250` at rest regardless of its
design position (337, 300, 298, 281), so the artboard layout and the
played position differ at every stage, not only 3 and 4. Which value is
the convention is an open owner decision in the plan; until then the
v2 stages 3 and 4 rest at their design values, which is what the first
build measured against. The stray single-key `x` tracks are deleted.

**D11. Stage 4 roots shrink to fit the motion (owner, round 2).**
Both stage 4 artboards were too full for the specified motion. The
root node's scale is reduced in 0.01 steps until the full spec
amplitudes clear every artboard edge by at least 3 px in every frame
of the loop. The pivot and rest position do not move.

**D12. Coral stage 3 and 4 rest height centres the loop (owner,
round 2).** The root rest `y` is chosen so the content's vertical
extent over the whole loop is centred in the artboard, giving the
upward bob the same room above as the limbs have below; the root `x`
is corrected the same way if the loop's horizontal extent is more than
4 px off centre. Stages 1 and 2 keep their shipped rest values (D9).
This replaces the open question left by D10.

## 2. Motion specification

All rotations are written in radians in RML (1 degree = 0.0174533).
Every key uses `cubic` interpolation with the default ease curve
(`x1 0.42, y1 0, x2 0.58, y2 1`) unless stated. The first key of every
track equals its last key, and the last key sits at `frame == duration`.
A wave track has keys only at its extremes, `+A` at 25 percent and
`-A` at 75 percent, with the `-A` to `+A` segment split across the loop
seam by exact cubic subdivision so the seam carries velocity. It must
not have a key at the zero crossing: the ease curve has zero slope at
every key, so a `0` key makes the part halt at upright once per loop
(round 1 finding). A lagged track is the same two extremes shifted
later by its offset, wrapped within the loop the same way.

### 2.1 Sprout: breeze sway, 300 frames

| Stage | Track | Pivot | Amplitude A | Lag |
|---|---|---|---|---|
| 1 | `Body` rotation | ground contact under the seed | 2 deg | driver |
| 2 | `Body` rotation | ground contact between the feet | 3 deg | driver |
| 2 | `Leaves` rotation | leaf stem base | 2 deg | 8 percent (24 f) |
| 2 | arm joint nodes rotation | shoulder, each side | 4 deg | 12 percent (36 f) |
| 2 | `Legs` | child of `Body`, sways with it | 0 of its own | none |
| 3, 4 | `Sprout` (root) rotation | ground contact under the trunk | 2.5 deg | driver |
| 3, 4 | `Leaves` rotation | canopy base on the trunk | 1.5 deg | 8 percent (24 f) |
| 3, 4 | arm joint nodes rotation | shoulder, each side | 4 deg | 12 percent (36 f) |

Stage 2 rotates `Body`, moved to the ground point with the D2
arithmetic. `Legs` was first left planted as the root's other child,
but the owner found the sway slid the body's lower edge off the leg
images and exposed their unlined tops; `Legs` is now the last child of
`Body` (still drawn beneath it) and sways with it. The legs sit within
40 px of the pivot, so they move under 2 px and the base still reads
as planted. Stage 1 has only `Body`; the same move applies.

Amplitude ceiling: the root or body never exceeds 3 degrees, and no
frame of the loop may leave the 500 px artboard. Stage 4 spans x 16 to
492 at rest, so its root takes the largest amplitude in 0.25 degree
steps that keeps every frame inside (2.5 degrees clipped the right
edge by 5 px in round 1).

### 2.2 Coral: float, 240 frames

| Stage | Track | Pivot | Amplitude A | Lag |
|---|---|---|---|---|
| 3, 4 | `Coral` (root) `y` | n/a | 20 px ABOVE rest at 50 percent (`y0, y0 - 20, y0`), the direction every shipped stage uses; stage 4 takes the largest value that stays inside the artboard | driver |
| 3, 4 | new shoulder joint nodes wrapping `ArmL` / `ArmR` | where the arm meets the body outline | 6 deg, mirrored | 25 percent (60 f) |
| 3, 4 | upper and lower arm sub-nodes rotation | existing nodes | 4 deg, same sign as their arm | 33 percent (80 f) |
| 3, 4 | leg joint nodes rotation | where the leg emerges from under the body or tutu, on the visible outline | 5 deg, mirrored | 30 percent (72 f) |
| 3 | crown joint node rotation | crown base on the head | 3 deg | 15 percent (36 f) |
| 4 | `Head_all` rotation | neck (bottom of the head image) | 2 deg | 15 percent (36 f) |

The bob track keeps the three-key shape the existing stages use
(`y0, y0 - 20, y0` at 0, 120, 240: up at mid-loop). Lagged limb tracks
use the two-extreme wave from the preamble. The existing `ArmL` and
`ArmR` nodes on stages 3 and 4 sit at the outer tips of the arms, not
at the body, so rotating them slides the arm root along the body; they
are wrapped in new joint nodes at the body edge, the same way the
Sprout arms got shoulder nodes (round 1 finding). The lag is what makes the limbs read as dragged
through water: when the body is at the top of the bob the limbs are
still rising.

`Head_all` on stage 4 had its origin above the head, so the rotation
would swing the head from the crown; the node is moved to the neck with
the D2 arithmetic before keying. The nested Face moves from `Body` into
`Head_all` at the same time (D7: the Face rides the head), with its
position and scale recomputed so the frame-0 capture is unchanged.

## 3. Standing rules

1. First key equals last key on every track, and the last key is at
   `frame == duration`. Checked from `rive inspect --json`.
2. No keys on anything inside the `Face` artboard, and no change to
   the view models or `dataBindPathIds`. Checked by diff.
3. Idle motion is keyframes only. No new scripts, bones or constraints
   for an idle; the FaceRig already keeps every instance advancing each
   frame, so added logic is pure cost.
4. A pivot move is proven by a frame-0 capture diff before and after
   the move, before any key is added: at most 2 pixels differing by
   one level (float rounding), nothing more.
5. Rotation amplitudes stay under the ceilings in section 2; a stage
   that needs more is a design conversation, not a bigger number.
6. Artboard names, the `idle` animation name and the state machine do
   not change, so `data/app/mascot_species.json` and the app stay as
   they are.
7. The shipped `.riv` comes from `--publish`, never `--once`: unsigned
   scripts are silently refused by the app and the face goes inert.
8. New cloud files take their name from `name:` in `rive.yaml`; the
   original file ids in the original projects' `rive.yaml` are never
   reused for a v2 push.

## 4. Review record

Round 1 (build complete, owner review pending). Measured: pivot moves
gave 0 differing pixels on all 8 stages; every track's first key equals
its last at `frame == duration`; lags measured from `inspect` match the
tables (Sprout 24 and 36 frames, Coral 60, 80, 72 and 36); the Face
artboard, both view models and all bind paths are byte-identical to
the originals. Deviations: Coral bob amplitude reduced at stages 3 and
4 for artboard room, Face re-parented under `Head_all` at stage 4, and
the Coral rest-height convention reopened. Both are open items in the
plan.

Red-team review of round 1 found six defects, fixed in round 2: the
wave shape halted at upright (preamble rewritten); the Coral bob ran
downward while every shipped stage bobs up (table corrected); Coral 3
and 4 arms pivoted at the hand tips (new joint nodes at the body edge);
stage 3 legs hinged at a point hidden behind the body (hip moved to the
visible leg root); Sprout stage 4 left the artboard by 5 px (amplitude
rule added); and the stage 3 pivot diff was 2 pixels, not 0 (rule 4
tolerance stated).

Round 2 (build complete, owner review pending). All six fixed and the
full section 5 table re-measured: every wave track's velocity at the
zero crossings equals its peak-segment velocity (no halt); the border
scan every 3 frames finds no opaque pixel on any artboard edge at any
stage; pivot identity 0 pixels on all 8 stages; lags and seam keys as
before; Face artboard, view models and bind paths still identical.
Values reduced to stay inside the 500 px artboard: Sprout stage 4 root
sway 1.25 deg (spec 2.5), Coral stage 4 bob 9 px up (spec 20) and
shoulder swing 4 deg (spec 6). Each is an open item in the plan.

Round 3 (D11 and D12 applied, owner review pending). All values back at
spec. Sprout stage 4 root scale 1.0 to 0.96 (pivot unchanged at the
ground point); Coral stage 4 root scale 1.34 to 1.31, rest (250, 281)
to (265.4, 287.8); Coral stage 3 rest (250, 298) to (258.5, 272.5). The
every-3-frames border scan passes on all 8 stages with at least 3 px
to spare; pivot identity 0 pixels except one single-level pixel each on
Coral 3 and 4 (within rule 4); no halt at upright on all 31 wave
tracks; Face artboard, view models and bind paths identical.

Jump round 1 (build complete, owner review pending). All 8 artboards
carry the `Jump` layer, the `jump` trigger on `ViewModel1` and the
JumpRoot node; the Face artboard, view model and bind paths are
identical, the idle timelines are byte-identical to round 3, and the
JumpRoot insert changed 0 pixels at frame 0 on every stage. Smile fires
at takeoff and is gone by landing plus 5 frames on all 8. Values sized
so the jump stays inside the artboard whenever it fires during the
idle, not only at frame 0: Sprout 1 and 2 and Coral 1 at spec; Coral 2
and 3 at spec lift with the stretch trimmed; Sprout 3 lift 14 px (spec
46), Sprout 4 lift 24 px with the crouch almost removed, Coral 4 no
rise at all. Acceptance 8.4 therefore fails on Coral 4 and is weak on
Sprout 3 and 4; the headroom decision is an open item. Coral stages
use a counter node under JumpRoot instead of child offsets because
Coral 1 idle keys child x/y.

## 5. Completed work

- v2 RML projects built: `Sprout_v2/rml` (all four stages keyed) and
  `Coral_v2/rml` (stages 3 and 4 keyed, 1 and 2 untouched). Not yet
  published, pushed or shipped.

---

## 6. Excited jump gesture

The second gesture after idle: the mascot crouches, jiggles with
anticipation, springs up with a stretch and a smile, and settles back
to its rest pose with the smile gone. Classic anticipation plus squash
and stretch.

### 6.1 Decisions

**J1. One timeline pair per stage artboard, on its own state machine
layer.** Each of the 8 stage artboards gets `jump_prep` and `jump_air`
timelines and a second layer `Jump` in its existing state machine, so
the idle in layer 1 keeps running underneath and the jump stacks on
top. The two layers never key the same property: idle keys the stage
root (bob, sway) and its limbs; the jump keys only a new `JumpRoot`
node.

**J2. Trigger is a view model property.** `ViewModel1` gains
`ViewModelPropertyTrigger name="jump"`, bound to every stage. Layer
`Jump`: Entry to `rest` (an empty `jump_rest` timeline), `rest` to
`jump_prep` on a `TransitionViewModelCondition` for `jump` (the same
pattern the Face uses for `smile`), `jump_prep` to `jump_air` on exit
time 100 percent, `jump_air` to `rest` on exit time 100 percent. Both
jump states carry `reset="true"` so a second trigger restarts cleanly.

**J3. The smile is fired from inside the file, at takeoff.**
`jump_air` carries `StateMachineFireTrigger` with `occursValue="atStart"`
on the path `ViewModel1 > face > smile`, so the existing Face smile
timeline plays unchanged (happy mouth from frame 3 to 27 of 30). The
air phase is 30 frames so the smile ends as the mascot lands. The Face
artboard is not edited (D7). The app fires only `jump`; it does not
fire `smile` alongside it.

**J4. The jump pivots at the ground contact.** A new `JumpRoot` node is
inserted between the stage root and all of its children, placed at the
ground point with the D2 arithmetic, so squash, stretch and lift read
as pushing off the ground. At Sprout stages 3 and 4 the root already
sits there, so `JumpRoot` is at local (0, 0). At Sprout stages 1 and 2
it is the `Body` pivot point and `Legs` moves under it too. At Coral it
is the lowest opaque row's centre at rest.

**J5. Squash and stretch preserve apparent volume.** `scaleX` moves
opposite to `scaleY` at roughly half the magnitude. The spec values are
in 6.2; ceilings: squash no lower than 0.84, stretch no higher than
1.16, lift no more than 12 percent of the stage's rest height, and no
frame leaves the artboard (rule 3 border scan). Stage 4 artboards are
tight, so their lift takes the largest value that passes.

**J6. The landing absorbs over 16 frames.** Owner review of round 3
found every stage "hit the ground with a thud". Three causes, all in
the air timeline: the fall had two ease-in segments, so the character
paused mid-fall and re-accelerated into the ground over 4 frames; the
contact squash landed on the same frame the feet touched; and the
recovery was a 6 frame ease-out, so the squash popped back at full
speed. Now the fall is one ease-in from apex to ground (gravity, no
hitch), the feet touch while the body is still in its falling stretch,
the body compresses to its deepest squash over the next 4 frames
(ease-out, deceleration highest at impact), then rises through a small
overshoot to rest over 12 more frames with ease in and out. The
overshoot is a fifth of the squash and never exceeds the launch
stretch, so a stage whose stretch was cut for headroom (Coral 4) gets
no overshoot. Alternatives rejected: slowing the fall before contact
(a body under gravity cannot), a second small hop (reads as a ball,
not a character), follow-through on arms and leaves (needs per-stage
keys on frozen nodes; revisit if the squash alone is not enough).

**J7. App integration is deferred (owner, round 2).** The file exposes
the `jump` trigger; when and where the app fires it is a later
decision. Until then the Flutter scale bounce after an action is
logged stays as it is, and nothing in the Seed repo references `jump`.

- **J8. Sprout jumps from upright.** Owner review of round 2: a
  jump fired mid-sway launched along the tilted axis, which in reality
  would send the character sideways. Gating on the upright pass was
  rejected (the state machine cannot read the idle's phase without a
  script, and a tap could wait 2.5 s). Instead the crouch straightens
  the character: on the Sprout stages the Jump layer's rest state
  plays the idle itself (reset on entry), `jump_prep` and `jump_air`
  hold every idle-keyed property at its frame-0 value, and the rest to
  prep transition blends over 333 ms, so the sway eases to upright
  during the crouch. Landing restarts the idle from frame 0, which is
  the pose the air ends in, so the sway resumes from upright with no
  step. A return blend was tried first and does not work: Rive holds a
  property keyed only in the outgoing state until the transition ends,
  then snaps. Coral keeps its bob running underneath (vertical only,
  measured: the lift adds to the bob and landing follows it).

### 6.2 Specification

All keys on `JumpRoot`. Frames at 60 fps. Ease is cubic ease-out
(`x1 0.25, y1 0.1, x2 0.25, y2 1`) on the way into a pose and ease-in
(`x1 0.42, y1 0, x2 1, y2 1`) into the ground, unless stated. `lift` is
10 percent of the stage's rest height in artboard pixels, measured from
the frame-0 extent.

`jump_prep`, 46 frames (0.77 s). Owner review of round 1 found a
10 frame crouch too abrupt; it now eases in and out over 20 frames:

| Frame | scaleX | scaleY | rotation | Note |
|---|---|---|---|---|
| 0 | 1.00 | 1.00 | 0 | rest |
| 20 | 1.10 | 0.86 | 0 | crouch, ease in and out (0.42, 0, 0.58, 1) |
| 20 to 40 | hold | hold | 0, +2.5, -2.5, +2.5, -2.5, 0 deg at 20, 24, 28, 32, 36, 40 | wiggle, linear between keys |
| 46 | 1.10 | 0.86 | 0 | hold the crouch, ready |

`jump_air`, 40 frames (0.67 s), `face/smile` fired at its start:

| Frame | scaleX | scaleY | y | Note |
|---|---|---|---|---|
| 0 | 1.10 | 0.86 | 0 | leaving the crouch |
| 6 | 0.90 | 1.14 | -0.6 lift | launch stretch, ease-out |
| 12 | 1.00 | 1.00 | -lift | apex, ease-out; y falls in one ease-in from here to 24 |
| 24 | 0.97 | 1.06 | 0 | feet touch, still in the falling stretch |
| 28 | 1.06 | 0.92 | 0 | deepest squash, ease-out from touch (J6) |
| 36 | 0.99 | 1.016 | 0 | settle overshoot, ease in and out, capped at the launch stretch |
| 40 | 1.00 | 1.00 | 0 | rest |

`jump_rest` is an empty timeline; the layer idles in it.

### 6.3 Standing rules for gestures

1. A gesture lives on its own state machine layer and keys only nodes
   the idle never keys, except where the gesture must take the idle
   over (J8): then it holds the idle's frame-0 values, blends in via
   the entry transition, and hands back by restarting the idle.
2. A gesture that needs the face uses `StateMachineFireTrigger` on the
   Face's view model path; it never keys inside the Face artboard.
3. Every gesture state has `reset="true"` and returns to its layer's
   rest state on exit time 100 percent, so the layer is always
   re-triggerable and never holds a pose.
4. Gesture captures are taken with `--data=jump` (fires the trigger
   before the scene runs) and `--advance=<frame>`, and the border scan
   in rule 3 runs over the whole gesture, not only the idle loop.
5. The trigger names (`jump`, `smile`) and the view model layout are
   the app contract; a rename is an app change too.

## 7. Turn gesture

Owner request: the character turns about 45 degrees left or right. A
smooth turn is preferred; a separate facing-45 setup is acceptable.

### 7.1 Decisions

- **T1. Layered 2.5D turn, no new art.** Every stage is already split
  into body, arms, legs or feet, leaves or crown and a nested Face.
  A turn is faked by sliding and narrowing those layers, the standard
  paper-doll head turn. Mesh deformation with bones is rejected: not
  authorable by hand in RML and buys little at 45 degrees.
- **T2. One number drives it.** `turn` on `ViewModel1`, -1 (left) to 1
  (right), read by a `BlendState1DViewModel` layer that mixes
  `turn_left` (-1), `turn_rest` (0) and `turn_right` (1). The app sets
  or animates the number; the rig never decides when to turn.
- **T3. Own layer, own nodes.** Per rule 1 in 6.3 the turn keys only
  new `Turn*` wrapper nodes (one per moving part) that the idle and
  jump never key. The Face artboard is never keyed; pupils follow via
  the existing `lookX` number, set by the app alongside `turn`.
- **T4. Left mirrors right.** `turn_left` is `turn_right` with every
  x offset and x shift negated and the arm roles swapped. The art is
  symmetric enough; stage 4 fruit and crown asymmetry is accepted.
- **T5. Arms draw in front of the body at rest; the far arm drops
  behind on a turn.** Owner decision after prototype round 1. The
  rest draw order puts both arms over the body so the near arm can
  come forward. A `DrawRules` swap sends the far arm behind the body
  once |turn| passes 0.1, driven from its own threshold layer
  (`TurnOrder`: rest, right and left states playing one-frame order
  timelines), never from the blend, because a blended `DrawRules` key
  ignores the blend weight. The reorder area grows with |turn| as the
  far arm tucks in, so the swap is least visible early; 0.1 keeps a
  dead zone around rest.
- **T7. Crown and leaves follow the face by rotating, not sliding.**
  Owner decision after rounds 1 and 2. They pivot at their attachment
  point and rotate toward the turn; the Sprout stalk stays at the
  centre of the head top with no shift, the Coral crown base may
  shift a little (about 0.2 of the face shift) since the head is
  wider. Round 2's 0.6 shift moved the stalk base visibly off centre.
- **T9. Arms sit lower at rest now that they draw in front.** Owner
  decision after round 2. Coral: the upper arms are lowered on the
  Turn wrappers (which the idle never keys) so the body's narrowing
  and the arm swing never overlap the head or neck at any turn value.
  Sprout: the arms are lowered by the distance between where the
  shoulder top emerged from behind the body in the old order and the
  arm image's own top edge now, so the visible arm base sits at the
  level it always had.
- **T10. Pupils lead at 60, not 100.** `lookX` = 60 x turn; the full
  range looked unnatural at a 45 degree turn.
- **T8. Shoulder caps where an arm image has a flat cut end.** Coral
  arms were cut for drawing behind the body; in front, the flat
  shoulder end shows. A small vector ellipse in the arm's fill and
  outline colours, drawn under the arm root and over the body, rounds
  it off without new raster art. Coral 3 needs four (upper and lower,
  both sides); the lower-arm cut ends are two-tone so those caps use
  a hard-stop gradient, and each cap carries a fill-only seam ellipse
  over the image to hide the PNG's 1 px dark fringe. Sprout 2 needs
  none: its arm colour matches the body. A retouch of the Coral arm
  PNGs (rounded, fringe-free shoulder ends) would let the seams and
  possibly the caps go.
- **T6. Prototype first.** Sprout stage 2 and Coral stage 3 only;
  the other six wait for owner review. A stage that reads flat gets
  one 3/4 body image in a Solo as a fallback, not a redesign.

### 7.2 Specification, `turn_right` pose at value 1

Offsets are fractions of the stage's rest width (w) or rest height (h)
measured at frame 0, applied on the Turn wrapper of each part.

| Part | x shift | scaleX | Other |
|---|---|---|---|
| Face | +0.14 w | 0.85 | y unchanged |
| Body | 0 | 0.92 | pivot at ground centre |
| Near arm (R) | +0.06 w | 1.05 | rotate 8 deg outward |
| Far arm (L) | -0.10 w | 0.80 | rotate 10 deg inward, behind body |
| Near leg or foot (R) | +0.04 w | 1.0 | |
| Far leg or foot (L) | -0.06 w | 0.85 | |
| Leaves or crown | 0 (crown about 0.2 of face shift) | 1.0 | rotate 10 to 15 deg toward the turn at the attachment point (T7) |

`turn_rest` holds every Turn wrapper at identity. Values are the start
point; the worker tunes each until the capture at value 1 reads as a
45 degree turn and the sweep from -1 to 1 has no pop other than the
arm reorder at 0.

### 7.3 Checks

| Check | Pass |
|---|---|
| Compiles | `--verify` 0 errors, 0 warnings |
| Wrapper insert changed nothing | frame 0 at `turn=0` vs baseline: at most 2 px one level |
| Idle and jump untouched | idle timelines and jump timelines byte-identical to baseline |
| Nothing leaves the artboard | border scan every 3 frames of the idle at `turn=1` and `turn=-1` |
| Mirror | capture at -1 equals the horizontal flip of the capture at 1 within 2 px, face excluded |
| Sweep | captures at -1, -0.5, 0, 0.5, 1; a sweep GIF over the idle |

### 7.4 Review record

Prototype round 1 (Sprout 2 and Coral 3 built, owner review pending).
Compiles clean on both projects; frame 0 at turn 0 is 0 pixels from
the baseline; idle, jump and Face timelines byte-identical; border
scans at turn 1 and -1 over the full idle and over a fired jump find
no edge pixel; the jump fired at turn 1 returns to plain idle at the
same frame. Final values: face shift 0.12 w (Sprout) and 0.09 w
(Coral) at scaleX 0.85, body 0.92, near arm +0.06 w at 1.05 and 8 deg,
far arm -0.07 w (Sprout) and -0.10 w (Coral) at 0.80 and 10 deg, legs
+0.04 w and -0.06 w at 0.85, leaves or crown -0.05 w at 0.95. The 7.2
table's R and L are the character's own sides; the art names parts by
screen side. Findings that change the design: (a) both arms already
draw behind the body, so no DrawRules are needed and the arm-in-front
variant exposed the cut end on Coral (owner then chose arms in
front anyway, see T5 and T8); (b) a blended
DrawRules key ignores the blend weight; (c) the runtime applies 1D
blend children in sequence from the property's current value, which
made the negative side non-linear, fixed with a `TurnBase` layer that
plays `turn_rest` for turn >= 0 and `turn_left` for turn < 0 under
the blend, a pattern any future blend gesture needs; (d) the pixel
mirror check cannot pass because the rest art is itself asymmetric
(Sprout 33k px against its own flip), the keys mirror exactly, so the
check is replaced by a key-level mirror check. The result reads as a
glance of roughly 20 to 25 degrees rather than 45: the face shift is
capped where the eye meets the body edge, and the captures do not set
`lookX`.

Round 2 (T5, T7, T8 built, owner review pending). Both arms draw in
front at rest with a `TurnOrder` layer swapping the far arm behind at
|turn| 0.1; the swap frame changes about 5 to 10 percent more pixels
than a neighbouring sweep frame. Leaves and crown pivot at their
attachment point, shift 0.6 of the face shift and rotate 10 degrees
toward the turn. Four Coral caps match at 12x zoom. Captures set
`lookX` = 100 x turn (FaceRig reads -100 to 100, positive toward
screen right, the same side turn 1 faces). All 7.3 checks re-measured:
compiles clean; frame 0 at turn 0 differs from the pre-turn baseline
only inside the arm-over-body overlap (about 680 Sprout and 2800
Coral pixels over 32 levels, 0 outside it); idle, jump and Face
byte-identical; border scans at turn 1 and -1 over the idle and a
fired jump find no edge pixel; keys mirror to 4e-8; sweep linear to
0.01 on Sprout and 0.05 on Coral's leg centroid. Coral arms now draw
above the Face and crown at rest; no overlap at any turn value here,
but a later stage with raised arms could clip the face.

Round 3 (T7 revised, T9, T10 built, owner review pending). Diff
against round 2 is only the arm wrapper rest y per artboard and the
leaves and crown keys. Sprout leaves: shift 0, rotation 15 degrees at
the stalk entry; the stalk now sits within 0.5 px of its rest offset
from the head-top centre at turn -1, 0 and 1 (round 2 was 16.5 and
12.5 px off). Coral crown: shift 0.2 of the face shift (6.7 px),
rotation 12 degrees; the base reads 13 to 16 px off centre at the
extremes, nearly all from the tilt of a wide crown on a curved head.
Sprout arms lowered 3 px, the measured gap between where the shoulder
emerged from behind the body and the arm image's top edge. Coral arms
lowered 41 px: the 62 px that clears head and neck at every turn and
idle frame hangs the lower arms among the legs and was rejected; at
41 px the head is clear up to |turn| 0.5 and the neck band up to 0.2,
with a residual overlap of up to 89 head pixels at |turn| 1 on the
highest idle swing. Captures use lookX = 60 x turn. All 7.3 checks
re-measured and passing as in round 2; frame 0 at turn 0 differs
from round 2 only inside the arm footprints.

Jump round 2 (owner review in the previewer). Prep lengthened to a 20
frame eased crouch (6.2 table). Owner found the Sprout stage 4 jump
unlike the others because its crouch, wiggle and stretch had been cut
to fit the artboard; per D11 the stage 4 root is shrunk again, 0.96
to 0.82, and the stage now runs the full spec crouch, wiggle and
stretch with a 36 px lift. Scan of the jump fired at every idle phase:
no edge pixel, margins at least 12 px left and right and 19 px top.
Sprout stage 2 legs reparented under Body (section 2.1). Coral stage 4
still carries reduced values and no rise; owner to decide whether it
gets the same shrink. Measured on Coral 3 that the jump lift adds to
the live bob (silhouette bottom matches plain idle to 1 px before and
from landing, with the bob moving throughout), so the landing follows
the bob and needs no compensation.

Jump round 3 (J8 built on all Sprout stages, owner review pending).
Trunk-only measurement on stage 4 with the jump fired at the sway
peak: lean eases to upright by crouch frame 20, holds through the air
within 1 px, lands on the ground point, and the restarted sway builds
from upright with frame-to-frame change no larger than ordinary sway
on every stage. Edge scan of the jump at all 25 idle phases: no edge
pixel on stages 3 and 4; stage 3 top margin 4 px at the launch
stretch, stage 4 margins 30, 21, 19 and 7 px.

Jump round 4 (landing, owner review pending). Owner review of round 3:
"looks much better", but every stage "hit the ground with a thud".
Rebuilt the air timeline per J6: one ease-in fall, touch in the falling
stretch, 4 frame compression to 1.06 by 0.92, 12 frame settle through
a capped overshoot; air now 40 frames. Border scan over the full
86 frame jump: stages Sprout 3 and 4, Coral 3 and 4 unchanged from
round 3 (no edge pixel; Coral 4 margins 3, 3, 6, 4 px, identical to
the previous build once the overshoot was capped at the stretch,
which on that stage is 1.0).
