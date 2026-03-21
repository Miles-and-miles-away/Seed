# Art Pipeline

Generate, validate, review, and optimize SVG assets for Seed using
AI generation (Recraft API) and automated quality checks.

## Overview

```
                  config.yaml
                      |
              eco_dex_manifest.yaml
                      |
                      v
  +-------------------------------------------+
  |  Step 1: GENERATE                         |
  |  generate.py                              |
  |                                           |
  |  Calls Recraft V4 Text-to-Vector API.     |
  |  Produces N candidates per entry as SVG.  |
  |  Prompt = style prefix + category +       |
  |           subject + color hint            |
  +-------------------------------------------+
                      |
              candidates/<entry_id>/
              candidate_1.svg
              candidate_2.svg
              candidate_3.svg
                      |
                      v
  +-------------------------------------------+
  |  Step 2: VALIDATE                         |
  |  validate.py                              |
  |                                           |
  |  Checks each SVG for:                     |
  |  - Valid XML, no embedded rasters         |
  |  - Color palette adherence (CIELAB)       |
  |  - File size limits                       |
  |  - CLIP similarity (optional)             |
  +-------------------------------------------+
                      |
              PASS / FAIL per candidate
                      |
                      v
  +-------------------------------------------+
  |  Step 3: REVIEW                           |
  |  review.py                                |
  |                                           |
  |  Renders all candidates for each entry    |
  |  into a contact sheet (grid PNG) for      |
  |  side-by-side visual comparison.          |
  +-------------------------------------------+
                      |
              review_sheets/<entry_id>_review.png
              (opens in Finder on macOS)
                      |
                      v
  +-------------------------------------------+
  |  Step 4: SELECT                           |
  |  (interactive, inside run_pipeline.py)    |
  |                                           |
  |  Pick the best candidate number for each  |
  |  entry. Saves choices to selections.yaml. |
  +-------------------------------------------+
                      |
              selections.yaml
                      |
                      v
  +-------------------------------------------+
  |  Step 5: OPTIMIZE + EXPORT                |
  |  optimize.py                              |
  |                                           |
  |  Runs SVGO to strip metadata and merge    |
  |  paths. Verifies render via cairosvg.     |
  |  Copies final SVG to assets/ directory.   |
  +-------------------------------------------+
                      |
              assets/eco_dex/<id>.svg
              assets/garden/<id>.svg
              assets/mascots/<id>.svg
```

## Quick Start

```bash
conda activate seed

# Full interactive pipeline (walks you through each step)
RECRAFT_API_TOKEN=xxx python scripts/art_pipeline/generate_assets.py \
  --manifest scripts/art_pipeline/eco_dex_manifest.yaml \
  --category eco_dex

# Test with just 2 entries first
RECRAFT_API_TOKEN=xxx python scripts/art_pipeline/generate_assets.py \
  --manifest scripts/art_pipeline/eco_dex_manifest.yaml \
  --category eco_dex \
  --ids flora_01 fauna_01
```

The interactive pipeline will:
1. Show you what will be generated and the estimated cost
2. Ask before calling the API
3. Run validation on all candidates
4. Generate review contact sheets and open them
5. Let you pick the best candidate for each entry
6. Optimize and export your selections
7. Offer to clean up temporary files

## Running Steps Individually

Each step can also be run standalone:

```bash
# Generate only
RECRAFT_API_TOKEN=xxx python scripts/art_pipeline/generate.py \
  --manifest scripts/art_pipeline/eco_dex_manifest.yaml

# Test a single prompt
RECRAFT_API_TOKEN=xxx python scripts/art_pipeline/generate.py \
  --prompt "simple flat vector oak tree, minimal style" \
  --output test_oak.svg

# Validate candidates
python scripts/art_pipeline/validate.py \
  --candidates-dir scripts/art_pipeline/candidates/ --all

# Validate a single SVG
python scripts/art_pipeline/validate.py --svg path/to/file.svg

# Generate review contact sheets
python scripts/art_pipeline/review.py \
  --candidates-dir scripts/art_pipeline/candidates/

# Optimize and export a single selection
python scripts/art_pipeline/optimize.py \
  --input candidates/flora_01/candidate_2.svg \
  --category eco_dex --id flora_01

# Batch export from a selections file
python scripts/art_pipeline/optimize.py \
  --selections scripts/art_pipeline/selections.yaml
```

## Resuming a Previous Run

If you generated candidates earlier and want to resume from
the review/selection step:

```bash
python scripts/art_pipeline/generate_assets.py \
  --manifest scripts/art_pipeline/eco_dex_manifest.yaml \
  --category eco_dex \
  --skip-generate
```

## Configuration

All settings live in `config.yaml`:

- **recraft** -- API URL, candidates per asset, output format
- **style.prefix** -- Base prompt shared by all assets
- **style.categories** -- Per-category prompt additions
- **palette** -- App colors from `app_colors.dart` for validation
- **validation** -- Thresholds for pass/fail checks
- **output** -- Directory paths for candidates, reviews, exports
- **svgo** -- SVGO command

## Manifests

A manifest YAML defines the entries to generate. Each entry has:

```yaml
entries:
  - id: flora_01          # Unique ID (becomes filename)
    category: flora       # Maps to style.categories in config
    subject: "oak tree"   # What to draw
    color_hint: "greens"  # Optional color guidance
```

Existing manifests:
- `eco_dex_manifest.yaml` -- All 56 Eco-Dex entries

To create a new manifest (e.g., for garden plants), copy the
format and add entries with appropriate categories.

## Validation Checks

| Check | What it does | Threshold |
|-------|-------------|-----------|
| Structure | Valid SVG XML, no embedded rasters, has viewBox | Pass/fail |
| File size | Raw file size before optimization | < 100KB |
| Color palette | CIELAB distance from app palette colors | < 5 off-palette colors |
| CLIP similarity | Embedding similarity vs reference images | > 0.75 (optional) |

### CLIP Validation (Optional)

For style consistency across a batch, provide reference images:

```bash
pip install open_clip_torch torch

python scripts/art_pipeline/validate.py \
  --candidates-dir candidates/ --all \
  --references approved/flora_01.svg approved/fauna_01.svg
```

This compares each candidate's visual embedding against the
references. Useful after you have a few approved assets to
enforce consistency for the rest.

## Cost

Recraft API charges $0.08 per vector SVG. With 3 candidates
per entry:

| Batch | Entries | SVGs | Est. Cost |
|-------|---------|------|-----------|
| Test (2 entries) | 2 | 6 | $0.48 |
| Eco-Dex | 56 | 168 | $13.44 |
| Garden (15 plants x 3 stages) | 45 | 135 | $10.80 |
| Mascots (3 species x 4 stages) | 12 | 36 | $2.88 |
| Full project | ~113 | ~339 | ~$27.12 |

## File Structure

```
scripts/art_pipeline/
  README.md                  # This file
  config.yaml                # Pipeline configuration
  generate_assets.py         # Interactive orchestrator
  generate.py                # Step 1: Recraft API generation
  validate.py                # Step 2: Quality validation
  review.py                  # Step 3: Contact sheet rendering
  optimize.py                # Step 5: SVGO + export
  eco_dex_manifest.yaml      # Eco-Dex entry definitions
  requirements.txt           # Python dependencies
  candidates/                # (generated) Raw SVG candidates
  review_sheets/             # (generated) Contact sheet PNGs
  selections.yaml            # (generated) Human selections
```

## Dependencies

Already installed in `conda seed` env:
- `pillow`, `cairosvg`, `lxml`, `pyyaml`, `requests`

Available via npm (used by optimize.py):
- `svgo` (run as `npx svgo`)

Optional (for CLIP validation):
- `open_clip_torch`, `torch`
