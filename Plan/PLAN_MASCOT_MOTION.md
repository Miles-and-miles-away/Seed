# Plan: Mascot idle motion v2

**Created:** 2026-11-07
**Status:** Planned. Implementation runs in `SeedResources/Rive/Mascots/`
(outside this repo); nothing in `assets/animations/` changes until the
owner approves the v2 captures.
**Purpose:** Feature plan for the second pass over the mascot idle
animations: Sprout at every stage, Coral at stages 3 and 4. Says what
is built, in what order, and how it is verified.
**Companion docs:** [PDR_MASCOT_MOTION.md](./PDR_MASCOT_MOTION.md)
holds the motion specification, the decisions and the standing rules;
this plan does not restate them. [PLAN_PHASE_7.md](./PLAN_PHASE_7.md)
section 7.1 is the art pipeline the rigs came from.

---

## 1. Goal

Every stage of both species has an authored idle loop that reads as the
character's own motion language: Coral floats (a vertical bob the arms,
legs and crown react to), Sprout sways in a breeze (a rotation about the
ground contact that the leaves and arms react to, with the base fixed).

## 2. Where the rigs stand

Both species are Rive CLI (RML) projects. The `scene.rml` is the source
of truth, the cloud editor files are mirrors made by `rive push`, and
the shipped `.riv` is `build/<name>.riv` copied into `assets/animations/`.

| Artboard | Parts in the rig | Idle timeline today |
|---|---|---|
| `Sprout_stage1` | body | empty |
| `Sprout_stage2` | body, arm_L, arm_R, leaves, leg_L, leg_R | empty |
| `Sprout_stage3` | body (trunk), arm_L, arm_R, leaves (canopy) | empty |
| `Sprout_stage4` | body (trunk), arm_L, arm_R, leaves (canopy) | empty |
| `Coral_stage1` | body, crown | body rock, crown drift, root bob |
| `Coral_stage2` | body, upper/lower arms, crown, feet | root bob, arm swing with lag, crown wobble, feet |
| `Coral_stage3` | body, head, crown, ArmL/ArmR (upper + lower), legs | root bob only; arms, legs and crown frozen |
| `Coral_stage4` | body, Head_all (head + crowns), ArmL/ArmR, legs, tutu | root bob only; arms, legs and head frozen |

Two defects ride along with the frozen limbs: the Coral stage 3 and 4
root bob keys `y` at 250 while the artboards place the root at 298 and
281, so the character jumps up on the first frame of playback; and the
stage 3 right arm's lower node is named `LowerL`.

## 3. Deliverables

1. `SeedResources/Rive/Mascots/Sprout_v2/rml/` and
   `Coral_v2/rml/`: copies of the two RML projects with the v2 idle
   timelines. The original `Sprout/rml` and `Coral/rml` are not edited.
2. Cloud files `sprout_v2` and `coral_v2` in Rive project 1849424,
   created by the first `rive push` of each copy, so the owner can open
   and scrub them in the editor. The original cloud files are untouched.
3. A review pack in the scratch area: a contact sheet of every stage at
   0, 25, 50 and 75 percent of the loop, and one GIF per stage.
4. After owner approval only: `build/sprout_v2.riv` and
   `build/coral_v2.riv` copied over `assets/animations/sprout_mascot.riv`
   and `coral_mascot.riv`, with `flutter test test/features/mascot`
   green. Artboard names do not change, so `mascot_species.json` and the
   app code need no edit.

## 4. Implementation order

1. Copy each `rml` directory to its `_v2` sibling. In the copy's
   `rive.yaml` set `name:` to `sprout_v2` or `coral_v2` and delete
   `push.fileId` (keep `push.projectId`). Confirm `rive <dir> --verify`
   is clean before any edit.
2. Capture every stage at frame 0 before touching the rig. These are
   the reference frames for the pivot identity check in section 5.
3. Sprout: move each stage's pivot to the ground contact (see PDR D2
   and its arithmetic), wrap each arm in a joint node at its shoulder,
   then key the sway tracks from the PDR tables.
4. Coral stages 3 and 4: fix the root bob base value, wrap each leg in a
   hip node, give the stage 3 crown and the stage 4 head a base or neck
   pivot, rename `LowerL` under `ArmR`, then key the float tracks.
5. Run the verification in section 5 after each stage, not at the end.
6. Build the review pack and stop for owner review. Tune amplitudes and
   periods on request; the PDR values are starting points.
7. On approval: owner runs `rive login`; then `rive <dir> --publish`
   (signed scripts, the app refuses unsigned ones), `rive push <dir>
   --project=1849424` (creates the cloud copy), copy the `.riv` files,
   run the Flutter tests, and the owner checks both species in the app.

While iterating, `--screenshot`, `--commands` and `inspect` build in
memory, so no `.riv` is written until `--publish` (the CLI no longer
has `--once`). Only the Flutter app needs the signed build.

## 5. Verification

Every check is a command, so it runs after every edit.

| Check | How | Pass |
|---|---|---|
| Project compiles | `rive <dir> --verify` | 0 errors, 0 warnings |
| Re-pivot changed nothing visible | `--screenshot --advance=0 --compare=<reference frame 0>` on each stage after moving a pivot and before keying | at most 2 pixels differing by one level (face wander is seeded and identical at frame 0) |
| Nothing leaves the artboard | capture every 3 frames of the loop with `--commands`; scan the border rows and columns for opaque pixels | no opaque pixel on any border row or column in any frame |
| No halt at upright | sample each wave track from `inspect --json` at every frame; the frame-to-frame velocity at the zero crossings is at least half the peak velocity | no track stalls |
| Base stays put (Sprout) | Alpha-scan the captures at 0, 25, 50, 75 percent: lowest opaque row, and the opaque-run centre on that row where the base is flat (stages 2 and 4) | row within 2 px; centre within 1 px where measured. A round seed (stage 1) or a spread of root tips (stage 3) changes which pixel is lowest as it turns, so the centre is not a valid measure there; the pivot identity check covers the pivot itself |
| Seamless loop | `rive inspect <dir> --json`: for every KeyedProperty the first and last key values are equal and the last key sits at `frame == duration` | no exceptions |
| Follow-through lags are real | same JSON: the extreme-value frames of each secondary track sit after the driver's by the PDR offset | matches the table |
| Face untouched | diff the `Face` artboard, both ViewModels and every `dataBindPathIds` against the original `scene.rml` | identical |
| App still binds the face | after copying the `.riv`: `flutter test test/features/mascot` | all pass |

## 6. Acceptance criteria

- Sprout: at every stage the character leans left and right once per
  loop with the base fixed; leaves and arms visibly trail the trunk.
- Coral stages 3 and 4: the body bobs, and the arms, legs and crown
  visibly trail it in a way that reads as drag through water. No jump
  on the first frame of playback.
- Coral stages 1 and 2, the Face rig, gaze and smile behave exactly as
  before.
- Original RML projects, original cloud files and the shipped `.riv`
  files are byte-identical until the owner approves.

## 7. Open items

One live list for this workstream; the PDR points here.

- [ ] Owner review of the v2 captures and GIFs; amplitudes and loop
      periods are tuned from that review.
- [x] Coral rest height: decided, PDR D12 (centre the loop's extent;
      stages 1 and 2 unchanged).
- [x] Stage 4 room, both species: decided, PDR D11 (shrink the root
      scale until the full spec motion clears every edge by 3 px).
- [ ] Decide whether Coral stages 1 and 2 get the same arm and leg
      treatment for consistency (out of scope for this pass).
- [ ] Decide whether Sprout stage 1 keeps the small rock the PDR
      specifies or stays still.

---

## 8. Phase 2: excited jump

Specification and decisions: PDR section 6. This section is the build
order and the checks.

### 8.1 Deliverables

1. In `Sprout_v2/rml` and `Coral_v2/rml`: a `JumpRoot` node, the
   `jump_rest`, `jump_prep` and `jump_air` timelines, the `Jump` state
   machine layer and the `jump` view model trigger, on all 8 stage
   artboards.
2. Review pack: a contact sheet of every stage at prep frames 0, 10,
   20, 30 and air frames 6, 12, 20, 24, 30 (with the idle visibly still
   running), and one GIF per stage covering the whole gesture with a
   second of idle either side.
3. After owner approval, with the Phase 1 publish: the same `.riv`
   copy step. App wiring is deferred (PDR J7).

### 8.2 Order

1. Add the `jump` trigger to `ViewModel1` and the `Jump` layer with its
   three states and transitions on one artboard; prove with
   `--data=jump --data-dump-every=1` or a capture sequence that the
   layer leaves `rest`, reaches `jump_air`, and that the Face mouth
   shows `mouth_happy` in a capture 10 frames into the air phase and
   `mouth_rest` 5 frames after landing.
2. Insert `JumpRoot` on that artboard with the D2 arithmetic; frame-0
   capture diff within rule 4 tolerance.
3. Key the two timelines from the PDR tables; run the checks in 8.3.
4. Repeat for the other seven artboards, measuring `lift` per stage.
5. Build the review pack and stop for owner review.

### 8.3 Checks

| Check | How | Pass |
|---|---|---|
| Compiles | `rive <dir> --verify` | 0 errors, 0 warnings |
| JumpRoot insert changed nothing | frame-0 compare before and after the insert | at most 2 pixels, one level |
| Layer runs | captures at air frames 6 and 12 differ from rest; capture at 40 frames after landing equals a plain idle capture at the same frame | as stated |
| Smile fires and ends | mouth region of the capture at air frame 10 matches a smile capture; at landing plus 5 frames matches rest | as stated |
| Idle keeps running | root `y` (Coral) or rotation (Sprout) sampled during the jump follows the idle curve | matches `inspect` idle values |
| Nothing leaves the artboard | border scan every 2 frames across prep and air | no opaque border pixel |
| Scale ceilings | from `inspect`: min scaleY 0.84, max 1.16, lift at most 12 percent of rest height | all within |
| Face untouched | diff of the Face artboard against the original | identical; `ViewModel1` differs only by the new `jump` property |
| Re-trigger | fire `jump` at frame 0 and again at frame 30; the second restarts prep | capture at frame 40 shows the crouch |

### 8.4 Acceptance

- Every stage crouches, jiggles, springs with a stretch and a visible
  rise, smiles from takeoff to landing, and settles to its exact rest
  pose and size; idle motion continues throughout.
- The originals, Coral stages 1 and 2 idle, and the Face rig are
  unchanged beyond the new trigger on `ViewModel1`.

### 8.5 Open items (jump)

- [x] Owner review of rounds 1 to 3: longer crouch, stage 4 shrink,
      legs under body, launch from upright (J8), landing felt like a
      thud (J6 rebuilt, round 4).
- [ ] Owner review of the round 4 landing; the contact squash depth
      and the 12 frame settle are the first knobs.
- [x] Headroom, Sprout 4: root shrunk to 0.82 (D11), full spec
      crouch, wiggle and stretch, lift 36 px.
- [ ] Headroom, Coral 4: still reduced values and no rise. Same
      shrink, taller artboard, or accept; owner decision. Sprout 3
      keeps a 14 px lift at full crouch and wiggle.
- [ ] Re-trigger: J2 only allows rest to prep on `jump`, so a fire
      during prep or air is dropped and the 8.3 re-trigger check
      cannot pass as written. Restarting mid-jump needs an AnyState to
      `jump_prep` transition, which snaps from the air pose.
- [ ] When and where the app fires `jump`: deferred by the owner until
      the movement is approved (PDR J7).

## 9. Phase 3: turn gesture

Spec and decisions in `PDR_MASCOT_MOTION.md` section 7.

### 9.1 Deliverables (prototype)

- `turn` number on `ViewModel1` in both projects, -1 to 1.
- Turn layer and `Turn*` wrappers on Sprout stage 2 and Coral stage 3.
- Review pack: `turn_contact.png` (both stages at -1, -0.5, 0, 0.5, 1)
  and `turn_<species>_s<N>.gif` (a 2 s sweep -1 to 1 and back over the
  idle).

### 9.2 Acceptance

- At value 1 the character reads as turned about 45 degrees to its
  right, at -1 to its left; the sweep is smooth apart from the arm
  reorder at 0; idle and jump keep running at any turn value.

### 9.3 Open items (turn)

- [x] Owner review of round 1: "not bad"; arms go in front of the
      body with the far arm dropping behind (T5), crown and leaves
      follow the face (T7).
- [x] Owner review of round 2: "generally look good"; lookX capped
      at 60 (T10), stalk and crown rotate without sliding (T7), Coral
      upper arms lower at rest (T9).
- [ ] Coral T9 residual: at |turn| 0.8 to 1 the near upper arm still
      crosses the neck on the highest idle swing. Options: cap the
      app's turn range at 0.7, trim the near-arm outward rotation, or
      accept it.
- [ ] Owner review of round 3; then roll out to the other six stages
      or commission 3/4 body art for stages that read flat. Knobs if
      it still reads short of 45: narrower face (scaleX 0.70) for a
      larger shift, body 0.88.
- [ ] Sign convention: at turn 1 the mascot faces screen right, its
      own left. Decide which direction 1 means before app wiring.
- [ ] App side: set `lookX` = 60 x `turn` so the pupils lead the
      turn, and ease `turn` itself; the rig blend is linear.
- [ ] Coral arm PNG retouch (rounded, fringe-free shoulder ends)
      would remove the four seam shapes and possibly the caps. Owner
      art task, optional.
