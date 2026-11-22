const LOOK_RANGE = 100;
// The eyes follow the pointer inside a circle: the body plus about 2 cm.
const BODY_RADIUS = 0.3;
const GAZE_MARGIN_PX = 76;
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

// With the look at 0 the rig looks around, faces front and winks by itself.
function steer(ev) {
  for (const m of mascots) {
    if (!m.visible || !m.face) continue;
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

addEventListener('resize', () => {
  for (const m of mascots) m.r.resizeDrawingSurfaceToCanvas();
});
