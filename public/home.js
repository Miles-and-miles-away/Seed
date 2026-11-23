import {
  BLINK_SECONDS, WAVE_SECONDS, blinkEyeOpen, breathe, draw, restPose, wave,
} from './mascots.js';

// The eyes follow the pointer inside a circle: the body plus about 2 cm.
const BODY_RADIUS = 0.3;
const GAZE_MARGIN_PX = 76;
const GAZE_JUMP = 1.1;
const FOLLOW_RATE = 9;
const MAX_FRAME_SECONDS = 0.1;
const BLINK_MIN_GAP = 2.5;
const BLINK_MAX_GAP = 7;
const WINK_SECONDS = 0.6;
const WINK_MIN_MS = 30_000;
const WINK_MAX_MS = 180_000;
const REDUCED = matchMedia('(prefers-reduced-motion: reduce)').matches;

const mascots = new Map();
const inView = new Set();
let now = 0;
let last = 0;
let running = false;

function paint(m, pose = restPose()) {
  const ctx = m.canvas.getContext('2d');
  ctx.clearRect(0, 0, m.canvas.width, m.canvas.height);
  draw(ctx, m.canvas.dataset.species, +m.canvas.dataset.stage, pose,
    m.canvas.width);
}

function resize(m) {
  m.canvas.width = m.canvas.height =
    Math.round(m.canvas.clientWidth * devicePixelRatio);
  paint(m);
}

function frame(time) {
  const dt = Math.min((time - last) / 1000, MAX_FRAME_SECONDS);
  last = time;
  now += dt;
  const follow = 1 - Math.exp(-dt * FOLLOW_RATE);
  for (const m of inView) {
    m.gaze = m.gaze.map((g, k) => g + (m.target[k] - g) * follow);
    if (now - m.blinkAt >= BLINK_SECONDS) {
      m.blinkAt = now + BLINK_MIN_GAP
        + Math.random() * (BLINK_MAX_GAP - BLINK_MIN_GAP);
    }
    const wink = (now - m.winkAt) / WINK_SECONDS;
    let pose = breathe({
      ...restPose(),
      gaze: m.gaze,
      eyeOpen: blinkEyeOpen(now - m.blinkAt),
      wink: wink < 1 ? Math.sin(wink * Math.PI) : 0,
    }, now);
    const waved = (now - m.waveAt) / WAVE_SECONDS;
    if (waved < 1) pose = wave(pose, waved);
    paint(m, pose);
  }
  running = inView.size > 0;
  if (running) requestAnimationFrame(frame);
}

function scheduleWink(m) {
  setTimeout(() => {
    m.winkAt = now;
    scheduleWink(m);
  }, WINK_MIN_MS + Math.random() * (WINK_MAX_MS - WINK_MIN_MS));
}

// Only a mascot in view animates.
const observer = new IntersectionObserver((entries) => {
  if (REDUCED) return;
  for (const e of entries) {
    const m = mascots.get(e.target);
    if (e.isIntersecting) inView.add(m);
    else inView.delete(m);
  }
  if (inView.size > 0 && !running) {
    running = true;
    last = performance.now();
    requestAnimationFrame(frame);
  }
});

for (const canvas of document.querySelectorAll('canvas.mascot')) {
  const m = {
    canvas, gaze: [0, 0], target: [0, 0],
    blinkAt: BLINK_MIN_GAP, waveAt: -Infinity, winkAt: -Infinity,
  };
  mascots.set(canvas, m);
  resize(m);
  canvas.classList.add('ready');
  observer.observe(canvas);
  if (REDUCED) continue;
  scheduleWink(m);
  canvas.addEventListener('animationend', () => canvas.classList.remove('hop'));
  canvas.addEventListener('click', () => {
    if (now - m.waveAt >= WAVE_SECONDS) m.waveAt = now;
    canvas.classList.remove('hop');
    void canvas.offsetWidth;
    canvas.classList.add('hop');
  });
}

function steer(ev) {
  for (const m of inView) {
    const b = m.canvas.getBoundingClientRect();
    const reach = b.width * BODY_RADIUS + GAZE_MARGIN_PX;
    const x = ev ? (ev.clientX - (b.left + b.width / 2)) / reach : 0;
    const y = ev ? (ev.clientY - (b.top + b.height / 2)) / reach : 0;
    const target = Math.hypot(x, y) <= 1 ? [x, y] : [0, 0];
    // A blink covers a large jump of the eyes.
    const jump = Math.hypot(target[0] - m.target[0], target[1] - m.target[1]);
    if (jump > GAZE_JUMP && now - m.blinkAt >= BLINK_SECONDS) m.blinkAt = now;
    m.target = target;
  }
}

addEventListener('pointermove', steer, {passive: true});
document.documentElement.addEventListener('pointerleave', () => steer());

// Only the width and the pixel ratio set the canvas sizes.
const viewport = () => `${innerWidth}@${devicePixelRatio}`;
let sized = viewport();
addEventListener('resize', () => {
  if (sized === viewport()) return;
  sized = viewport();
  mascots.forEach(resize);
});
