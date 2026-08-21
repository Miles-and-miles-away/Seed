# Firestore security-rules tests

These verify `firestore.rules` itself — the one artifact that the Dart
suite cannot cover (`fake_cloud_firestore` ignores rules) and the
functions Jest mocks never touch. They run against the real Firestore
emulator.

## Prerequisites

- Node deps: `npm install` (root) — pulls in `@firebase/rules-unit-testing`,
  `firebase`, and `jest`.
- A JDK (the emulator is Java). It lives in the `seed` conda env:

  ```bash
  conda install -n seed -c conda-forge openjdk=21
  ```

## Running

Activate the env so `java` is on `PATH`, then run the script — it boots
the Firestore emulator via `firebase emulators:exec` and runs Jest:

```bash
conda activate seed
npm run test:rules
```

The emulator uses the `demo-seed` project id (no real credentials) and
the ports in `firebase.json` (Firestore on 8080).

## CI

The `rules` job in `.github/workflows/ci.yml` runs this suite on every
push and PR. It needs `firebase.json` (emulator ports and the rules
path) and `.firebaserc`, so both are committed. Neither holds secrets:
the project and app ids are client identifiers already shipped in the
app binary.

## Layout

- `firestore.rules.test.js` — the cases (reads/writes, ownership, the
  mascots cap, `egg` shape, language enum,
  `displayName`/`personalGoal` bounds,
  `actionLog` create/immutability — including the points cap, `note`
  and `relatedSdgs` size limits, and the 5s rate limit — and read-only
  collections).
- `jest.config.js` — scoped Jest config (`*.rules.test.js`, Node env).
