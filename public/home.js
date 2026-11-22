// Same gaze maths as the app: full deflection half of (3 x mascot size) away.
const LOOK_RANGE = 100;
const GAZE_REACH = 3;
const STATE_MACHINE = 'State Machine 1';
const WINK_MIN_MS = 30_000;
const WINK_MAX_MS = 180_000;
const REDUCED = matchMedia('(prefers-reduced-motion: reduce)').matches;

rive.RuntimeLoader.setWasmUrl('/vendor/rive.wasm');
rive.RuntimeLoader.setWasmFallbackUrl('/vendor/rive_fallback.wasm');

const files = new Map();
const mascots = [];

function loadFile(src) {
  if (!files.has(src)) {
    files.set(src, new Promise((resolve, reject) => {
      const file = new rive.RiveFile({
        src,
        onLoad: () => resolve(file),
        onLoadError: reject,
      });
      file.init();
    }));
  }
  return files.get(src);
}

function scheduleWink(m) {
  setTimeout(() => {
    if (m.visible) m.face?.trigger('wink')?.trigger();
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
    onLoad: () => {
      r.resizeDrawingSurfaceToCanvas();
      const face = r.viewModelInstance?.viewModel('face');
      const m = {canvas, r, face, visible: true};
      mascots.push(m);
      if (!REDUCED) scheduleWink(m);
      canvas.classList.add('ready');
    },
  });
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
    const m = mascots.find((x) => x.canvas === e.target);
    if (!m) {
      if (e.isIntersecting && !e.target.dataset.mounted) {
        e.target.dataset.mounted = '1';
        mount(e.target);
      }
      continue;
    }
    m.visible = e.isIntersecting;
    if (REDUCED) continue;
    if (m.visible) m.r.play(STATE_MACHINE);
    else m.r.pause();
  }
}, {rootMargin: '200px'});

document.querySelectorAll('canvas.mascot').forEach((c) => observer.observe(c));

const clamp = (v) => Math.max(-1, Math.min(1, v));

addEventListener('pointermove', (ev) => {
  for (const m of mascots) {
    if (!m.visible || !m.face) continue;
    const b = m.canvas.getBoundingClientRect();
    const half = (b.width * GAZE_REACH) / 2;
    const x = clamp((ev.clientX - (b.left + b.width / 2)) / half);
    const y = clamp((ev.clientY - (b.top + b.height / 2)) / half);
    m.face.number('lookX').value = x * LOOK_RANGE;
    m.face.number('lookY').value = y * LOOK_RANGE;
  }
}, {passive: true});

addEventListener('resize', () => {
  for (const m of mascots) m.r.resizeDrawingSurfaceToCanvas();
});
