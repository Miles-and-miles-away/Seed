const LOOK_RANGE = 100;
// The eyes follow the pointer inside a circle: the body plus about 2 cm.
const BODY_RADIUS = 0.3;
const GAZE_MARGIN_PX = 76;
const STATE_MACHINE = 'State Machine 1';
const WINK_MIN_MS = 30_000;
const WINK_MAX_MS = 180_000;
const REDUCED = matchMedia('(prefers-reduced-motion: reduce)').matches;
// A decode slower than the last delay leaves the body missing until a resize.
const REDRAW_MS = [100, 500, 2000, 5000];

rive.RuntimeLoader.setWasmUrl('/vendor/rive.wasm');
rive.RuntimeLoader.setWasmFallbackUrl('/vendor/rive_fallback.wasm');

const files = new Map();
const mascots = [];
const inView = new Set();

function loadFile(src) {
  if (!files.has(src)) {
    files.set(src, new Promise((resolve, reject) => {
      const file = new rive.RiveFile({
        src,
        onLoad: () => resolve(file),
        onLoadError: (e) => {
          files.delete(src);
          reject(e);
        },
      });
      file.init().catch(() => {});
    }));
  }
  return files.get(src);
}

function scheduleWink(m) {
  setTimeout(() => {
    if (inView.has(m.canvas)) m.face?.trigger('wink')?.trigger();
    scheduleWink(m);
  }, WINK_MIN_MS + Math.random() * (WINK_MAX_MS - WINK_MIN_MS));
}

async function mount(canvas) {
  const riveFile = await loadFile(canvas.dataset.riv);
  const r = new rive.Rive({
    riveFile,
    canvas,
    artboard: canvas.dataset.artboard,
    stateMachine: STATE_MACHINE,
    autoplay: !REDUCED,
    autoBind: true,
    isTouchScrollEnabled: true,
    useOffscreenRenderer: true,
    onLoad: () => {
      r.resizeDrawingSurfaceToCanvas();
      const face = r.viewModelInstance?.viewModel('face');
      const m = {canvas, r, face};
      mascots.push(m);
      if (!inView.has(canvas)) r.pause();
      if (!REDUCED) scheduleWink(m);
      // A paused rig never redraws, and the images decode after the first frame.
      else REDRAW_MS.forEach((ms) => setTimeout(() => r.drawFrame(), ms));
      canvas.classList.add('ready');
    },
  });
  canvas.addEventListener('animationend', () => canvas.classList.remove('hop'));
  canvas.addEventListener('click', () => {
    const m = mascots.find((x) => x.canvas === canvas);
    m?.face?.trigger('smile')?.trigger();
    canvas.classList.remove('hop');
    void canvas.offsetWidth;
    canvas.classList.add('hop');
  });
}

// Mount each mascot when it nears the viewport; pause it when it leaves.
const observer = new IntersectionObserver((entries) => {
  for (const e of entries) {
    if (e.isIntersecting) inView.add(e.target);
    else inView.delete(e.target);
    const m = mascots.find((x) => x.canvas === e.target);
    if (!m) {
      if (e.isIntersecting && !e.target.dataset.mounted) {
        e.target.dataset.mounted = '1';
        mount(e.target).catch(() => delete e.target.dataset.mounted);
      }
      continue;
    }
    if (REDUCED) continue;
    if (e.isIntersecting) m.r.play(STATE_MACHINE);
    else m.r.pause();
  }
}, {rootMargin: '200px'});

document.querySelectorAll('canvas.mascot').forEach((c) => observer.observe(c));

// With the look at 0 the rig looks around, faces front and winks by itself.
function steer(ev) {
  for (const m of mascots) {
    if (!inView.has(m.canvas) || !m.face) continue;
    const b = m.canvas.getBoundingClientRect();
    const reach = b.width * BODY_RADIUS + GAZE_MARGIN_PX;
    const x = ev ? (ev.clientX - (b.left + b.width / 2)) / reach : 0;
    const y = ev ? (ev.clientY - (b.top + b.height / 2)) / reach : 0;
    const scale = Math.hypot(x, y) <= 1 ? LOOK_RANGE : 0;
    m.face.number('lookX').value = x * scale;
    m.face.number('lookY').value = y * scale;
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
  for (const m of mascots) m.r.resizeDrawingSurfaceToCanvas();
});
