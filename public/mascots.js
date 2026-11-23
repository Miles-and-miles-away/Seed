// Web port of the code-drawn mascots in lib/features/mascot/presentation/drawn.
// Every number mirrors the Dart painters, so change both together.

const TAU = Math.PI * 2;
const SIZE = 100;
const X = SIZE / 2;
const GROUND = 96;
const OUTLINE = 1.5;
const SEED_SHADE = 0.3;
const LIT = [-3.5, -5];
const FAR = [-500, -500, 1100, 1100];

export const BLINK_CLOSE = 0.083;
export const BLINK_HOLD = 0.05;
export const BLINK_OPEN = 0.133;
export const BLINK_SECONDS = BLINK_CLOSE + BLINK_HOLD + BLINK_OPEN;
export const WAVE_SECONDS = 1.6;
const BREATHE_SECONDS = 3.6;

const REST = {
  squash: 0, lean: 0, armL: 0, armR: 0, topSway: 0,
  gaze: [0, 0], eyeOpen: 1, smile: 0, wink: 0,
};

// Canvas state for the draw call in progress.
let c, sp, i, rig, pose;

function cubic(x1, y1, x2, y2) {
  const at = (t, a, b) => 3 * (1 - t) * (1 - t) * t * a
    + 3 * (1 - t) * t * t * b + t * t * t;
  return (x) => {
    let lo = 0;
    let hi = 1;
    for (let n = 0; n < 24; n++) {
      const t = (lo + hi) / 2;
      if (at(t, x1, x2) < x) lo = t;
      else hi = t;
    }
    return at((lo + hi) / 2, y1, y2);
  };
}
const easeInOut = cubic(0.42, 0, 0.58, 1);
const easeIn = cubic(0.42, 0, 1, 1);
const easeOut = cubic(0, 0, 0.58, 1);
const clamp01 = (v) => Math.min(1, Math.max(0, v));
const lerp = (a, b, t) => a + (b - a) * t;

export function breathe(p, seconds) {
  const phase = seconds / BREATHE_SECONDS * TAU;
  const arms = 0.06 * Math.sin(phase);
  return {
    ...p,
    squash: p.squash + 0.016 * Math.sin(phase),
    topSway: p.topSway + 0.05 * Math.sin(phase - 0.9),
    armL: p.armL + arms,
    armR: p.armR + arms,
  };
}

// Waves with the screen-right hand; progress runs 0..1.
export function wave(p, progress) {
  const t = clamp01(progress);
  const amount = easeInOut(clamp01(Math.min(t, 1 - t) / 0.22));
  const swing = Math.sin(t * TAU * 3);
  return {
    ...p,
    armR: p.armR + amount * (1.68 + 0.3 * swing),
    armL: p.armL + amount * 0.25,
    lean: p.lean + amount * -0.045,
    topSway: p.topSway - amount * 0.12 * swing,
    smile: Math.max(p.smile, amount),
  };
}

export function blinkEyeOpen(seconds) {
  if (seconds < 0 || seconds >= BLINK_SECONDS) return 1;
  if (seconds < BLINK_CLOSE) return 1 - easeIn(seconds / BLINK_CLOSE);
  const opening = seconds - BLINK_CLOSE - BLINK_HOLD;
  return opening < 0 ? 0 : easeOut(opening / BLINK_OPEN);
}

export const restPose = () => ({...REST});

const path = (build) => {
  const p = new Path2D();
  build(p);
  return p;
};
const oval = (cx, cy, w, h) =>
  path((p) => p.ellipse(cx, cy, w / 2, h / 2, 0, 0, TAU));
const circle = (cx, cy, r) => oval(cx, cy, r * 2, r * 2);
const pill = (x, y, w, h, r) => path((p) => p.roundRect(x, y, w, h, r));
// Everything except the shape, for an even-odd clip.
const beyond = (p, dx = 0, dy = 0) => path((o) => {
  o.rect(...FAR);
  o.addPath(p, new DOMMatrix([1, 0, 0, 1, dx, dy]));
});

// A shape is one Path2D, or a list of clockwise paths that form a union.
function fill(shape, color, alpha = 1) {
  c.fillStyle = color;
  c.globalAlpha = alpha;
  for (const p of [].concat(shape)) c.fill(p);
  c.globalAlpha = 1;
}

function stroke(p, color, width) {
  c.strokeStyle = color;
  c.lineWidth = width;
  c.stroke(p);
}

// Canvas has no path union, so each member draws its edge outside the others.
function outline(shape) {
  const members = [].concat(shape);
  for (const p of members) {
    c.save();
    for (const q of members) if (q !== p) c.clip(beyond(q), 'evenodd');
    stroke(p, sp.outline, OUTLINE);
    c.restore();
  }
}

// The single shade shape of a part: a crescent on its lower right.
function shade(shape, color, lit = LIT, alpha = 1) {
  const members = [].concat(shape);
  c.save();
  c.clip(path((u) => members.forEach((p) => u.addPath(p))));
  for (const p of members) c.clip(beyond(p, ...lit), 'evenodd');
  c.fillStyle = color;
  c.globalAlpha = alpha;
  c.fillRect(...FAR);
  c.restore();
}

function part(shape, color) {
  fill(shape, color);
  outline(shape);
}

function branch(p, color, width) {
  stroke(p, sp.outline, width + OUTLINE * 2);
  stroke(p, color, width);
}

function highlight(cx, cy, color) {
  c.save();
  c.translate(cx, cy);
  c.rotate(-0.75);
  fill(oval(0, 0, 9, 4.6), color);
  c.restore();
}

function bodyHighlight(color) {
  const [top, mid, , w] = sp.bodies[i];
  highlight(X - w * 0.4, top + (mid - top) * 0.38, color);
}

function feet(draw) {
  for (const side of [-1, 1]) {
    c.save();
    c.translate(X + side * rig.footX, GROUND);
    c.scale(side, 1);
    draw();
    c.restore();
  }
}

// The origin is on the shoulder and the arm lies along +y.
function arms(draw) {
  if (rig.armLength === 0) return;
  for (const [side, raise] of [[-1, pose.armL], [1, pose.armR]]) {
    c.save();
    c.translate(X + side * rig.shoulderX, rig.shoulderY);
    c.scale(side, 1);
    c.rotate(-(rig.armRest + raise));
    draw();
    c.restore();
  }
}

function top(draw) {
  c.save();
  c.translate(X, rig.topY);
  c.rotate(pose.topSway);
  c.translate(-X, -rig.topY);
  draw();
  c.restore();
}

const rigOf = ([
  pivotY, faceY, topY, shoulderX, shoulderY, armLength, armRest, footX,
  faceSize, eyeSize, eyeGap,
]) => ({
  pivotY, faceY, topY, shoulderX, shoulderY, armLength, armRest, footX,
  faceSize, eyeSize, eyeGap,
});

// point near 0.35 gives a seed tip, near 0.6 a round dome.
function bodyPath([t, mid, bottom, w], point = 0.35) {
  const upper = t + (mid - t) * 0.49;
  const lower = mid + (bottom - mid) * 0.67;
  return path((p) => {
    p.moveTo(X, t);
    p.bezierCurveTo(X + w * point, t + 1, X + w, upper, X + w, mid);
    p.bezierCurveTo(X + w, lower, X + w * 0.58, bottom, X, bottom);
    p.bezierCurveTo(X - w * 0.58, bottom, X - w, lower, X - w, mid);
    p.bezierCurveTo(X - w, upper, X - w * point, t + 1, X, t);
    p.closePath();
  });
}

function bodyFill(shape, color, shadeColor, shadeLit, shadeAlpha) {
  fill(shape, color);
  shade(shape, shadeColor, shadeLit, shadeAlpha);
}

// ---- Face ----

const EYE_WHITE = '#FFFBF5';
const BLUSH = '#FC9078';
const BLUSH_ALPHA = 0x59 / 255;

function openEye(open, side) {
  const [gx, gy] = pose.gaze;
  const d = Math.hypot(gx, gy);
  const k = d > 1 ? 1 / d : 1;
  const opening = oval(100, 122, 164, 176);
  c.save();
  c.translate(0, 122);
  c.scale(1, open);
  c.translate(0, -122);
  fill(opening, EYE_WHITE);
  c.save();
  c.clip(opening);
  // The beads rest turned slightly inward, towards the mouth.
  c.translate(gx * k * 20 - side * 5, gy * k * 20);
  fill(oval(100, 122, 152, 172), sp.face.bead);
  fill(oval(100, 180.5, 82, 28), sp.face.glow, 0.55);
  fill(circle(72, 92, 28), EYE_WHITE);
  fill(circle(126, 154, 14), EYE_WHITE);
  c.restore();
  stroke(opening, sp.face.line, 10);
  c.restore();
}

// A blink rests as a soft downward curve; a smile lifts it into an arch.
function shutEye(smile, width) {
  const ends = lerp(126, 138, smile);
  stroke(path((p) => {
    p.moveTo(26, ends);
    p.quadraticCurveTo(100, lerp(150, 52, smile), 174, ends);
  }), sp.face.line, width);
}

// At rest the floor lies on the lip, so the stroke reads as a crescent.
function mouth(smile, width) {
  const sideX = lerp(180, 216, smile);
  const sideY = lerp(83, 158, smile);
  const floor = lerp(83, 166, smile);
  const cavity = path((p) => {
    p.moveTo(30, 60);
    p.quadraticCurveTo(130, lerp(106, 90, smile), 230, 60);
    p.quadraticCurveTo(sideX, sideY, 130, floor);
    p.quadraticCurveTo(260 - sideX, sideY, 30, 60);
    p.closePath();
  });
  fill(cavity, sp.face.mouthInside);
  if (smile > 0.45) {
    c.save();
    c.clip(cavity);
    c.translate(0, floor - 166);
    fill(path((p) => {
      p.moveTo(82, 148);
      p.quadraticCurveTo(130, 118, 178, 148);
      p.quadraticCurveTo(154, 164, 130, 164);
      p.quadraticCurveTo(106, 164, 82, 148);
      p.closePath();
    }), sp.face.tongue);
    c.restore();
  }
  stroke(cavity, sp.face.line, width);
}

function face() {
  c.translate(X + pose.gaze[0] * 1.8, rig.faceY + pose.gaze[1] * 1.8);
  const blush = BLUSH_ALPHA * Math.max(pose.smile, pose.wink, 0.9);
  for (const side of [-1, 1]) {
    fill(oval(side * (rig.eyeGap / 2 + 1.5), 5.5, 6.5, 4), BLUSH, blush);
  }
  const scale = rig.eyeSize / 176;
  const share = rig.faceSize / rig.eyeSize;
  const lineWidth = 22.4 * share;
  c.scale(scale, scale);
  for (const side of [-1, 1]) {
    const squeeze = side > 0
      ? Math.max(pose.smile, pose.wink)
      : pose.smile * (1 - pose.wink);
    const open = pose.eyeOpen * (1 - squeeze);
    c.save();
    c.translate(side * rig.eyeGap / scale / 2 - 100, -122);
    if (open < 0.14) shutEye(squeeze, lineWidth);
    else openEye(open, side);
    c.restore();
  }
  c.save();
  c.translate(0, 62 * share);
  c.scale(0.5 * share, 0.5 * share);
  c.translate(-130, -60);
  mouth(pose.smile, lineWidth);
  c.restore();
}

// ---- Sprout: Seed, Sprout, Sapling, Tree ----

const UP = -Math.PI / 2;
const SPROUT = {
  body: '#B57A54', bodyShade: '#9A5F42', bodyLight: '#D9A47C',
  limb: '#A2664A', leaf: '#82B85A', leafShade: '#62993F',
  leafLight: '#A9D67C', petal: '#F8A9C8', pollen: '#FFE08A',
};
const SPROUT_BODIES = [
  [56, 79, 96, 18], [40, 70, 90, 20.5], [36, 62, 90, 21.5], [30, 62, 90, 27.5],
];

// A domed top, straight sides and a flared hem, with root toes if any.
function trunkPath([t, mid, toeTip, w], waist, toeHeight) {
  const s = w * waist;
  const b = toeTip - toeHeight / 2;
  const trunk = path((p) => {
    p.moveTo(X, t);
    p.bezierCurveTo(X + s * 0.55, t, X + s, t + s * 0.45, X + s, t + s);
    p.bezierCurveTo(X + s * 0.93, mid, X + s * 0.98, b - 9, X + w, b - 3);
    p.bezierCurveTo(X + w * 0.9, b, X + w * 0.4, b, X, b);
    p.bezierCurveTo(X - w * 0.4, b, X - w * 0.9, b, X - w, b - 3);
    p.bezierCurveTo(X - s * 0.98, b - 9, X - s * 0.93, mid, X - s, t + s);
    p.bezierCurveTo(X - s, t + s * 0.45, X - s * 0.55, t, X, t);
    p.closePath();
  });
  if (toeHeight === 0) return trunk;
  return [
    trunk,
    ...[-1, 0, 1].map((k) => oval(X + k * w * 0.66, b, w * 0.7, toeHeight)),
  ];
}

const SPROUT_SHAPES = [
  bodyPath(SPROUT_BODIES[0]),
  bodyPath(SPROUT_BODIES[1]),
  trunkPath(SPROUT_BODIES[2], 0.91, 0),
  trunkPath(SPROUT_BODIES[3], 0.8, 8),
];
// The tree's canopy replaces the stem, so it has no tip and no leaves.
const STEM_TIPS = [[50.4, 52.5], [50.6, 32], [50, 30], null];
const LEAVES = [
  [[-0.9, 8, 3.4]],
  [[-2.5, 16.5, 6.2], [-0.8, 19.5, 7.2]],
  [
    [UP - 1.3, 17, 5.2], [UP + 1.3, 17, 5.2],
    [UP - 0.65, 20, 5.6], [UP + 0.65, 20, 5.6], [UP, 22, 5.8],
  ],
  [],
];
const CANOPY = [
  [50, 24, 20], [27, 32, 15], [73, 32, 15], [36, 16, 13], [64, 16, 13],
].map((l) => circle(...l));
const BLOSSOMS = [[24, 33], [42, 14], [62, 26], [77, 35]];
const ROUND_FOOT = oval(0, -5.75, 15, 11.5);

function leaf(x, y, [angle, length, width]) {
  const lower = (p) =>
    p.bezierCurveTo(length, width * 1.1, length * 0.3, width * 1.25, 0, 0);
  const blade = path((p) => {
    p.moveTo(0, 0);
    p.bezierCurveTo(
      length * 0.3, -width * 1.25, length, -width * 1.1, length, 0,
    );
    lower(p);
  });
  const leafShade = path((p) => {
    p.moveTo(0, 0);
    p.quadraticCurveTo(length / 2, -width * 0.2, length, 0);
    lower(p);
  });
  c.save();
  c.translate(x, y);
  c.rotate(angle);
  // The shade stays on the lower side of a leaf that points left.
  c.scale(1, Math.cos(angle) < 0 ? -1 : 1);
  fill(blade, SPROUT.leaf);
  fill(leafShade, SPROUT.leafShade);
  outline(blade);
  c.restore();
}

function sproutArm() {
  const length = rig.armLength;
  if (i === 1) {
    part(oval(0, length / 2, 7.8, length), SPROUT.limb);
    return;
  }
  branch(path((p) => {
    p.moveTo(0, 0);
    p.lineTo(0, length);
  }), SPROUT.limb, 3.2);
  leaf(0, length - 3.5, [-0.25, 8.5, 3.6]);
}

function sproutStem() {
  const tip = STEM_TIPS[i];
  if (!tip) return;
  const stem = path((p) => {
    p.moveTo(X, rig.topY + 1.5);
    p.quadraticCurveTo(X - 0.6, (rig.topY + tip[1]) / 2, ...tip);
  });
  stroke(stem, sp.outline, 2.4 + OUTLINE * 2);
  for (const l of LEAVES[i]) leaf(...tip, l);
  stroke(stem, SPROUT.leafShade, 2.4);
}

function sproutCanopy() {
  bodyFill(CANOPY, SPROUT.leaf, SPROUT.leafShade);
  highlight(34, 14, SPROUT.leafLight);
  outline(CANOPY);
  for (const [x, y] of BLOSSOMS) {
    part(circle(x, y, 2.8), SPROUT.petal);
    fill(circle(x, y, 1.1), SPROUT.pollen);
  }
}

const sprout = {
  outline: '#3A1408',
  face: {
    line: '#300C00', bead: '#321406', glow: '#7FB350',
    mouthInside: '#2A0E04', tongue: '#FC9078',
  },
  bodies: SPROUT_BODIES,
  rigs: [
    [96, 79.5, 56.5, 16, 80, 0, 0.62, 7, 8.25, 6.16, 14.9],
    [90, 70, 40.5, 19, 69, 14, 0.62, 9.5, 9.375, 6.5, 16.2],
    [90, 61, 36.5, 18, 64, 16, 0.95, 10.5, 9.375, 6.25, 14.5],
    [90, 62, 32, 20.5, 66, 16, 0.95, 11.5, 9.75, 6.24, 15.3],
  ].map(rigOf),
  ground() {
    if (i > 0) feet(() => part(ROUND_FOOT, SPROUT.limb));
  },
  body() {
    const shape = SPROUT_SHAPES[i];
    arms(sproutArm);
    top(sproutStem);
    bodyFill(
      shape, SPROUT.body, SPROUT.bodyShade, LIT, i === 0 ? SEED_SHADE : 1,
    );
    bodyHighlight(SPROUT.bodyLight);
    outline(shape);
    if (i === 3) top(sproutCanopy);
  },
};

// ---- Coral: Polyp, Colony, Reef, Ecosystem ----

const CORAL = {
  body: '#B3A4F5', bodyShade: '#9685E3', bodyLight: '#DDD5FD',
  limb: '#9F8EEA', fringe: '#6FD6DC', fringeShade: '#48B9C4',
  coral: '#FF8F6E', sponge: '#FFD166', spongeShade: '#EBA83C',
  grass: '#5DBB6E',
};
const CORAL_BODIES = [
  [62, 81, 96, 22], [50, 71, 90, 25], [44, 68, 90, 27.5], [38, 65, 90, 30],
];
const CORAL_SHAPES = CORAL_BODIES.map((b) => bodyPath(b, 0.6));
// A scalloped fringe of the second colour along the base of the body.
const SCALLOPS = CORAL_BODIES.map(([, mid, bottom, w]) => {
  const h = (bottom - mid) * 0.55;
  return [[-0.62, 0.42, 1], [0.05, 0.36, 0.62], [0.66, 0.4, 0.9]].map(
    ([x, width, height]) =>
      oval(X + w * x, bottom, w * width * 2, h * height * 2),
  );
});
// Each branch: angle, length, forks, width. Angle 0 points up.
const CROWNS = [
  [[-0.75, 5.5, 0, 4.2], [0.75, 5.5, 0, 4.2], [0, 7.5, 0, 4.2]],
  [[0, 15, 1, 5]],
  [[-0.8, 14, 1, 4.4], [0.8, 14, 1, 4.4], [0, 22, 2, 4.4]],
  [[-0.75, 13, 1, 4.6], [0.75, 13, 1, 4.6], [0, 25, 2, 4.6]],
];
const FIN_WIDTHS = [0, 8, 9, 10];
// Each fish: x, y, facing.
const SHOALS = [[], [], [[18, 30, -1]], [[90, 11, 1], [10, 23, -1]]];
const FISH_BODY = oval(0, 0, 10, 6.6);
const FISH_TAIL = path((p) => {
  p.moveTo(3.5, 0);
  p.lineTo(8.5, -3.4);
  p.lineTo(8.5, 3.4);
  p.closePath();
});
const SEA_GRASS = path((p) => {
  p.moveTo(8, -3);
  p.quadraticCurveTo(8, -15, 18, -20);
  p.moveTo(14, -3);
  p.quadraticCurveTo(15, -10, 27, -12);
});
const CORAL_FOOT = oval(0, -5, 13, 10);
// Each tube sponge: x, y, width, height, turn.
const TUBES = [[28, 37, 10, 24, -0.45], [21, 45.5, 8.5, 14, -0.9]];
const BUBBLES = [[70, 40, 8.5], [79, 46, 6.5], [77.5, 33, 5.5]].map(
  (l) => circle(...l),
);

function fork(p, x, y, angle, length, forks) {
  const dx = Math.sin(angle) * length;
  const dy = -Math.cos(angle) * length;
  p.moveTo(x, y);
  p.lineTo(x + dx, y + dy);
  if (forks === 0) return;
  for (const turn of [-0.8, 0.8]) {
    fork(p, x + dx * 0.5, y + dy * 0.5, angle + turn, length * 0.6, forks - 1);
  }
}

function coralGarden() {
  for (const [x, y, w, h, turn] of TUBES) {
    c.save();
    c.translate(x, y);
    c.rotate(turn);
    part(pill(-w / 2, -h / 2, w, h, w / 2), CORAL.sponge);
    fill(oval(0, w * 0.42 - h / 2, w * 0.5, w * 0.28), CORAL.spongeShade);
    c.restore();
  }
  bodyFill(BUBBLES, CORAL.fringe, CORAL.fringeShade);
  outline(BUBBLES);
}

const coral = {
  outline: '#262058',
  face: {
    line: '#1A2348', bead: '#1C3464', glow: '#6FD0E0',
    mouthInside: '#2A1238', tongue: '#FF9C9C',
  },
  bodies: CORAL_BODIES,
  rigs: [
    [96, 79, 62.5, 20, 82, 0, 1, 9, 9.375, 7, 18.1],
    [90, 68.5, 50.5, 23.5, 70, 11, 1, 10.5, 10.125, 7.29, 19.6],
    [90, 65.5, 44.5, 26, 67.5, 13, 1.05, 11.5, 10.5, 7.28, 21.1],
    [90, 62.5, 38.5, 28.5, 65, 14, 1.1, 12.5, 10.875, 7.25, 22.4],
  ].map(rigOf),
  ground() {
    for (const [x, y, facing] of SHOALS[i]) {
      c.save();
      c.translate(x, y + pose.topSway * 14);
      c.scale(facing, 1);
      part(FISH_TAIL, CORAL.sponge);
      part(FISH_BODY, CORAL.sponge);
      fill(circle(-2.4, -0.8, 0.9), sp.outline);
      c.restore();
    }
    if (i === 0) return;
    if (i === 3) feet(() => branch(SEA_GRASS, CORAL.grass, 3.6));
    feet(() => part(CORAL_FOOT, CORAL.limb));
  },
  body() {
    const shape = CORAL_SHAPES[i];
    const length = rig.armLength;
    arms(() => part(oval(0, length / 2, FIN_WIDTHS[i], length), CORAL.limb));
    top(() => {
      for (const [angle, reach, forks, width] of CROWNS[i]) {
        const stalk = path(
          (p) => fork(p, X, rig.topY + 2, angle, reach, forks),
        );
        branch(stalk, CORAL.coral, width);
      }
      if (i === 3) coralGarden();
    });
    // The polyp is small, so its shade is a thinner crescent.
    bodyFill(
      shape, CORAL.body, CORAL.bodyShade,
      i === 0 ? [-2, -3] : LIT, i === 0 ? SEED_SHADE : 1,
    );
    c.save();
    c.clip(shape);
    fill(SCALLOPS[i], CORAL.fringe);
    c.restore();
    bodyHighlight(CORAL.bodyLight);
    outline(shape);
  },
};

// ---- Fungi: Spore, Cap, Colony, Network ----

const FUNGI = {
  stem: '#F7E6C4', stemShade: '#E6CC9E', stemLight: '#FFF8E6',
  limb: '#EDD6AB', cap: '#E5483A', capShade: '#C4332B',
  capLight: '#F8A398', pale: '#FFF3DC', paleShade: '#E6CC9E',
};
const FUNGI_BODIES = [
  [63, 80.5, 96, 18.5], [49, 73, 90, 20], [44, 71, 90, 21.5], [39, 70, 90, 22],
];
const STEMS = FUNGI_BODIES.map((b) => bodyPath(b, 0.6));
const CAPS = [
  null,
  {top: 36, rim: 54, w: 23.5, lip: 3, gills: 6},
  {top: 23, rim: 49, w: 33, lip: 3.5, gills: 8},
  {top: 14, rim: 44, w: 39, lip: 4, gills: 9},
];
// A dome with a hem that bows up in the middle to show the gills.
const CAP_PATHS = CAPS.map((cap) => cap && path((p) => {
  const {top: t, rim, w, lip} = cap;
  const shoulder = rim - (rim - t) * 0.62;
  const hem = rim + lip;
  const corner = lip * 1.5;
  p.moveTo(X - w, rim);
  p.bezierCurveTo(X - w, shoulder, X - w * 0.5, t, X, t);
  p.bezierCurveTo(X + w * 0.5, t, X + w, shoulder, X + w, rim);
  p.quadraticCurveTo(X + w, hem, X + w - corner, hem);
  p.quadraticCurveTo(X, rim - lip, X - w + corner, hem);
  p.quadraticCurveTo(X - w, hem, X - w, rim);
  p.closePath();
}));
// Cap spots: x and radius as shares of the cap half width, y as a share
// of the cap height.
const SPOTS = [
  [-0.76, 0.62, 0.09], [-0.38, 0.38, 0.13], [0.02, 0.52, 0.12],
  [0.12, 0.16, 0.1], [0.44, 0.38, 0.13], [0.76, 0.6, 0.08],
];
const ARM_WIDTHS = [0, 7, 7.5, 8];
// The spore's first thread; the network of stage 4 grows from it.
const HYPHA = path((p) => {
  p.moveTo(50, 65);
  p.bezierCurveTo(49, 58, 53, 54.5, 56, 56.5);
  p.bezierCurveTo(58, 58, 56.5, 60.5, 54.8, 59.3);
});
const THREADS = path((p) => {
  p.moveTo(4, -3);
  p.quadraticCurveTo(16, -6, 31, -3);
  p.moveTo(8, -4.4);
  p.quadraticCurveTo(8.5, -8.5, 12, -11);
  p.moveTo(22, -4.6);
  p.quadraticCurveTo(23, -8, 26.5, -10);
});
// Baby mushrooms of stage 4: offset from a foot towards the outside, size.
const BABIES = [[29.5, 0.8], [17, 1.25]];
const FUNGI_FOOT = oval(0, -5, 13, 10);

function fungiGills(cap) {
  const y = cap.rim + cap.lip / 2;
  const open = i > 1;
  const gills = oval(X, y, (cap.w - 2) * 2, cap.gills * 2);
  fill(gills, open ? FUNGI.pale : FUNGI.capShade);
  c.save();
  c.clip(gills);
  for (const reach of [0.55, 0.8, 1.05]) {
    for (const side of [-1, 1]) {
      stroke(path((p) => {
        p.moveTo(X, y - cap.gills);
        p.lineTo(X + side * cap.w * reach, y + cap.gills);
      }), open ? FUNGI.paleShade : FUNGI.cap, 0.8);
    }
  }
  c.restore();
  outline(gills);
}

function fungiCap(cap) {
  const shape = CAP_PATHS[i];
  const height = cap.rim - cap.top;
  fill(shape, FUNGI.cap);
  // A spot flattens towards the edge of the dome, which gives the cap depth.
  for (const [x, y, r] of SPOTS) {
    const dx = cap.w * x;
    const dy = height * (y - 1);
    const edge = Math.min(1, x * x + (1 - y) * (1 - y));
    const size = cap.w * r * 2;
    c.save();
    c.translate(X + dx, cap.rim + dy);
    c.rotate(Math.atan2(dy, dx));
    fill(oval(0, 0, size * (1 - 0.4 * edge), size), FUNGI.pale);
    c.restore();
  }
  shade(shape, FUNGI.capShade);
  outline(shape);
}

function fungiBaby([x, s]) {
  part(pill(x - 2.6 * s, -8.5 * s, 5.2 * s, 8.5 * s, 2.4 * s), FUNGI.stem);
  part(path((p) => {
    p.moveTo(x - 6 * s, -6.5 * s);
    p.bezierCurveTo(
      x - 6 * s, -15.5 * s, x + 6 * s, -15.5 * s, x + 6 * s, -6.5 * s,
    );
    p.quadraticCurveTo(x, -5 * s, x - 6 * s, -6.5 * s);
    p.closePath();
  }), FUNGI.cap);
  for (const side of [-1, 1]) {
    fill(circle(x + side * 1.5 * s, -3.4 * s, 0.75), sp.outline);
  }
}

const fungi = {
  outline: '#3C240C',
  face: {
    line: '#3C240C', bead: '#4A2A11', glow: '#FF9C8C',
    mouthInside: '#2A1506', tongue: '#F2A08C',
  },
  bodies: FUNGI_BODIES,
  rigs: [
    [96, 79.2, 63.5, 16, 82, 0, 0.62, 7, 7.875, 6.09, 13.1],
    [90, 71.2, 54, 19, 75, 11, 0.62, 9, 8.25, 6.05, 13.4],
    [90, 68.2, 49, 20.5, 72.5, 12.5, 0.7, 10, 8.625, 5.98, 13.9],
    [90, 64.2, 44, 21, 72, 14, 0.95, 11, 9, 6, 14.6],
  ].map(rigOf),
  ground() {
    if (i === 0) return;
    feet(() => {
      if (i === 3) {
        branch(THREADS, FUNGI.pale, 1.6);
        BABIES.forEach(fungiBaby);
      }
      part(FUNGI_FOOT, FUNGI.limb);
    });
  },
  body() {
    const stem = STEMS[i];
    const cap = CAPS[i];
    const length = rig.armLength;
    arms(() => part(oval(0, length / 2, ARM_WIDTHS[i], length), FUNGI.limb));
    top(() => {
      if (cap) fungiGills(cap);
      else branch(HYPHA, FUNGI.capLight, 1.8);
    });
    // The spore shows a trace of the cap colour along its lower rim.
    if (cap) bodyFill(stem, FUNGI.stem, FUNGI.stemShade);
    else bodyFill(stem, FUNGI.stem, FUNGI.capLight, LIT, SEED_SHADE);
    if (!cap) bodyHighlight(FUNGI.stemLight);
    outline(stem);
    if (cap) top(() => fungiCap(cap));
  },
};

const SPECIES = {seed: sprout, coral, fungi};

// Draws one mascot in a square of `size` canvas pixels at the origin.
export function draw(ctx, species, stage, p, size) {
  c = ctx;
  sp = SPECIES[species];
  i = stage - 1;
  rig = sp.rigs[i];
  pose = {...REST, ...p};
  // A stage with no arms leans its body where the others raise an arm.
  const lean = pose.lean
    + (rig.armLength === 0 ? (pose.armR - pose.armL) * -0.06 : 0);
  c.save();
  c.lineCap = 'round';
  c.lineJoin = 'round';
  c.scale(size / SIZE, size / SIZE);
  sp.ground();
  c.translate(X, rig.pivotY);
  c.rotate(lean);
  c.scale(1 - pose.squash * 0.6, 1 + pose.squash);
  c.translate(-X, -rig.pivotY);
  sp.body();
  face();
  c.restore();
}
