-- FaceRig (numeric-blink build): gaze damping, idle wander, and auto-blink
-- for the Face artboard.
--
-- REPO REFERENCE COPY. This is the source of truth for the FaceRig script that
-- lives *inside* the binary `assets/animations/coral_mascot.riv`. It is not
-- compiled or bundled by Flutter -- edit here for review/history, then paste
-- into the Rive editor's Script asset to apply. Keep the two in sync.
--
-- Blink is driven as a NUMBER (eye Scale-Y) instead of a trigger. That removes
-- the dependency on a blink timeline + state-machine transition, and matches
-- the documented design recipe ("blink by scale-Y"). pupilX/pupilY gaze output
-- and idle wander are unchanged.
--
-- View model properties READ (driven by the Seed app):
--   lookX, lookY : number, -100..100, 0 at rest
--   smileHold    : number, 1 while the app holds the smile, else 0. Its rising
--                  edge defers the next blink so the eyes stay open through the
--                  held smile (a blink mid-hold reads as a pause on shut eyes).
-- View model properties WRITTEN (bind artwork to these in the editor):
--   pupilX, pupilY : number, gaze group offset in artboard px  (identity binding)
--   blink          : number, 1.0 open -> 0.05 shut -> 1.0       (bind BOTH eye
--                    groups' Scale Y to this, identity; origin at eye BOTTOM)
--
-- The smile trigger is consumed by the state machine directly. The script only
-- observes `smileHold` (a number the app sets alongside the trigger) -- reading
-- a number can't disturb the trigger the way probing the trigger itself might.

type FaceRig = {
  -- Editor-tunable inputs
  travel: Input<number>, -- max pupil offset (px) at full look
  speed: Input<number>, -- gaze follow speed; higher = snappier
  wanderRadius: Input<number>, -- idle wander size, fraction of travel
  blinkMin: Input<number>, -- min seconds between blinks
  blinkMax: Input<number>, -- max seconds between blinks

  -- View model property refs (resolved in init)
  lookX: Property<number>?,
  lookY: Property<number>?,
  pupilX: Property<number>?,
  pupilY: Property<number>?,
  blink: Property<number>?, -- number, not PropertyTrigger
  smileHold: Property<number>?, -- app-driven; 1 while holding the smile

  -- Internal state
  gazeX: number,
  gazeY: number,
  wanderX: number,
  wanderY: number,
  idleTime: number,
  wanderTimer: number,
  blinkTimer: number, -- countdown to the next spontaneous blink
  blinkT: number, -- seconds into current blink; >= BLINK_TOTAL means "not blinking"
  smileHoldPrev: number, -- previous frame's smileHold, for rising-edge detection
}

-- Blink envelope (seconds): squash to SHUT_SCALE and back. Open is ~1.7x the
-- close, per the perceptual research in FACE_DESIGN_REPORT (never symmetric).
local SHUT_SCALE = 0.05
local CLOSE_DUR = 0.07
local SHUT_DUR = 0.03
local OPEN_DUR = 0.12
local BLINK_TOTAL = CLOSE_DUR + SHUT_DUR + OPEN_DUR
-- Point in the envelope where the eyes start opening again.
local OPEN_START = CLOSE_DUR + SHUT_DUR

local function randomRange(min: number, max: number): number
  return min + math.random() * (max - min)
end

-- Smoothstep ease, 0..1.
local function smooth(x: number): number
  return x * x * (3 - 2 * x)
end

-- Eye Y-scale for a given time into the blink: 1.0 open -> SHUT_SCALE -> 1.0.
local function blinkScale(t: number): number
  if t < CLOSE_DUR then
    return 1.0 - (1.0 - SHUT_SCALE) * smooth(t / CLOSE_DUR)
  elseif t < OPEN_START then
    return SHUT_SCALE
  elseif t < BLINK_TOTAL then
    return SHUT_SCALE + (1.0 - SHUT_SCALE) * smooth((t - OPEN_START) / OPEN_DUR)
  end
  return 1.0
end

function init(self: FaceRig, context: Context): boolean
  local vmi = context:viewModel()
  if vmi == nil then
    return false
  end
  self.lookX = vmi:getNumber('lookX')
  self.lookY = vmi:getNumber('lookY')
  self.pupilX = vmi:getNumber('pupilX')
  self.pupilY = vmi:getNumber('pupilY')
  self.blink = vmi:getNumber('blink')
  self.smileHold = vmi:getNumber('smileHold')
  self.blinkTimer = randomRange(self.blinkMin, self.blinkMax)
  self.blinkT = BLINK_TOTAL -- start with eyes open (not mid-blink)
  self.smileHoldPrev = 0
  return true
end

function advance(self: FaceRig, seconds: number): boolean
  -- Normalized gaze target from the app.
  local tx = if self.lookX then self.lookX.value / 100 else 0
  local ty = if self.lookY then self.lookY.value / 100 else 0

  -- Keep the target inside the unit circle so corner gazes are no
  -- stronger than side gazes.
  local len = math.sqrt(tx * tx + ty * ty)
  if len > 1 then
    tx /= len
    ty /= len
  end

  -- Idle wander: when the app is not steering, look around casually.
  if len < 0.01 then
    self.idleTime += seconds
    self.wanderTimer -= seconds
    if self.idleTime > 1 and self.wanderTimer <= 0 then
      self.wanderX = randomRange(-1, 1) * self.wanderRadius
      self.wanderY = randomRange(-0.5, 0.5) * self.wanderRadius
      self.wanderTimer = randomRange(1.5, 4)
    end
    tx = self.wanderX
    ty = self.wanderY
  else
    self.idleTime = 0
    self.wanderX = 0
    self.wanderY = 0
  end

  -- Frame-rate independent exponential follow (unconditionally stable for any
  -- dt: k stays in [0,1), so no timestep clamp is needed here).
  local k = 1 - math.exp(-self.speed * seconds)
  self.gazeX += (tx - self.gazeX) * k
  self.gazeY += (ty - self.gazeY) * k

  if self.pupilX then
    self.pupilX.value = self.gazeX * self.travel
  end
  if self.pupilY then
    self.pupilY.value = self.gazeY * self.travel
  end

  -- Smile hold: on the rising edge (app just raised smileHold) push the next
  -- blink well past the held smile, and if a blink is already closing/shut,
  -- skip it to the opening phase so the eyes ease back up instead of holding
  -- shut through the pause.
  local holding = if self.smileHold then self.smileHold.value else 0
  if holding > 0.5 and self.smileHoldPrev <= 0.5 then
    self.blinkTimer = randomRange(self.blinkMin, self.blinkMax)
    if self.blinkT < OPEN_START then
      self.blinkT = OPEN_START
    end
  end
  self.smileHoldPrev = holding

  -- Auto-blink on a random cadence, driven as a Scale-Y number envelope.
  if self.blinkT < BLINK_TOTAL then
    self.blinkT += seconds -- a blink is in progress; play it out
  else
    self.blinkTimer -= seconds
    if self.blinkTimer <= 0 then
      self.blinkT = 0 -- start a new blink
      self.blinkTimer = randomRange(self.blinkMin, self.blinkMax)
    end
  end

  if self.blink then
    self.blink.value = blinkScale(self.blinkT)
  end

  return true
end

return function(): Node<FaceRig>
  return {
    init = init,
    advance = advance,
    travel = 8, -- design report suggests ~20px, tune in inspector
    speed = 8,
    wanderRadius = 0.4,
    blinkMin = 2.5,
    blinkMax = 6,
    gazeX = 0,
    gazeY = 0,
    wanderX = 0,
    wanderY = 0,
    idleTime = 0,
    wanderTimer = 0,
    blinkTimer = 3,
    blinkT = BLINK_TOTAL, -- start open
    smileHoldPrev = 0,
  }
end
