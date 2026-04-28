#!/usr/bin/env python3
"""Interactive art asset pipeline.

Walks through the full generate -> validate -> review -> select ->
optimize flow step by step, prompting for input at each stage.

Usage:
    python scripts/art_pipeline/generate_assets.py eco_dex_entries.json
    python scripts/art_pipeline/generate_assets.py eco_dex_entries.json \
        --ids flora_01 flora_02
    python scripts/art_pipeline/generate_assets.py garden.json --category garden
"""

import argparse
import json
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path
import yaml

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CONFIG_PATH = SCRIPT_DIR / "config.yaml"
DATA_DIR = PROJECT_ROOT / "data" / "app"
VALID_CATEGORIES = ("eco_dex", "garden", "mascots")


def load_config():
    with open(CONFIG_PATH) as f:
        return yaml.safe_load(f)


def infer_category(json_path, config):
    """Infer asset category from JSON filename via config map."""
    filename = Path(json_path).name
    mapping = config.get("file_category_map", {})
    return mapping.get(filename)


def banner(title):
    width = 56
    print()
    print("=" * width)
    print(f"  {title}")
    print("=" * width)
    print()


def confirm(prompt, default=True):
    """Ask y/n, return bool."""
    suffix = " [Y/n] " if default else " [y/N] "
    answer = input(prompt + suffix).strip().lower()
    if not answer:
        return default
    return answer in ("y", "yes")


def pick_number(prompt, low, high):
    """Ask for an integer in range."""
    while True:
        answer = input(prompt).strip()
        if not answer:
            return None
        try:
            n = int(answer)
            if low <= n <= high:
                return n
            print(f"  Enter a number between {low} and {high}.")
        except ValueError:
            print("  Enter a valid number.")


def run_step(cmd, label):
    """Run a subprocess command, stream output."""
    print(f"\n> {label}")
    print(f"  $ {' '.join(str(c) for c in cmd)}\n")
    result = subprocess.run(cmd)
    return result.returncode == 0


def step_generate(config, json_path, ids=None):
    """Step 1: Generate SVG candidates via Recraft API."""
    banner("Step 1: Generate SVG Candidates")

    with open(json_path) as f:
        data = json.load(f)
    entries = data.get("entries", [])

    if ids:
        entries = [e for e in entries if e["id"] in ids]

    n_candidates = config["recraft"]["candidates_per_asset"]
    total_svgs = len(entries) * n_candidates
    units = total_svgs * config["recraft"]["units_per_svg"]
    budget = config["recraft"]["monthly_unit_budget"]

    print(f"JSON:        {json_path}")
    print(f"Entries:     {len(entries)}")
    print(f"Candidates:  {n_candidates} per entry")
    print(f"Total SVGs:  {total_svgs}")
    print(f"This run:    {units} units (cap: {budget}/mo)")
    print()

    # Show first few entries
    print("Entries to generate:")
    for entry in entries[:5]:
        print(
            f"  - {entry['id']}: "
            f"{entry['artPrompt'][:60]}"
        )
    if len(entries) > 5:
        print(f"  ... and {len(entries) - 5} more")
    print()

    if not confirm("Proceed with generation?"):
        print("Skipped generation.")
        return False

    cmd = [
        sys.executable,
        str(SCRIPT_DIR / "generate.py"),
        "--json", str(json_path),
    ]
    if ids:
        cmd += ["--ids"] + list(ids)

    return run_step(cmd, "Generating SVGs via Recraft API")


def step_validate(config):
    """Step 2: Validate all candidates."""
    banner("Step 2: Validate Candidates")

    candidates_dir = PROJECT_ROOT / config["output"]["candidates"]
    if not candidates_dir.exists():
        print(f"No candidates found at {candidates_dir}")
        return False

    entry_dirs = sorted(
        d for d in candidates_dir.iterdir() if d.is_dir()
    )
    svg_count = sum(
        len(list(d.glob("*.svg"))) for d in entry_dirs
    )

    print(f"Candidates dir: {candidates_dir}")
    print(f"Entry dirs:     {len(entry_dirs)}")
    print(f"Total SVGs:     {svg_count}")
    print()

    if not confirm("Run validation on all candidates?"):
        print("Skipped validation.")
        return False

    cmd = [
        sys.executable,
        str(SCRIPT_DIR / "validate.py"),
        "--candidates-dir", str(candidates_dir), "--all",
    ]
    return run_step(cmd, "Validating SVGs")


def step_review(config):
    """Step 3: Generate contact sheets for visual review."""
    banner("Step 3: Generate Review Sheets")

    candidates_dir = PROJECT_ROOT / config["output"]["candidates"]
    review_dir = PROJECT_ROOT / config["output"]["review"]

    print(f"Candidates: {candidates_dir}")
    print(f"Output:     {review_dir}")
    print()
    print(
        "This renders each entry's candidates into a side-by-"
        "side grid image so you can visually compare them."
    )
    print()

    if not confirm("Generate review sheets?"):
        print("Skipped review sheet generation.")
        return False

    cmd = [
        sys.executable,
        str(SCRIPT_DIR / "review.py"),
        "--candidates-dir", str(candidates_dir),
    ]
    success = run_step(cmd, "Rendering contact sheets")

    if success:
        print(f"\nReview sheets saved to: {review_dir}")
        print(
            "Open the PNG files to compare candidates, then "
            "continue to the selection step."
        )

        # Try to open the folder
        if sys.platform == "darwin":
            subprocess.run(
                ["open", str(review_dir)],
                capture_output=True,
            )

    return success


def step_select(config, category):
    """Step 4: Interactive candidate selection."""
    banner("Step 4: Select Best Candidates")

    candidates_dir = PROJECT_ROOT / config["output"]["candidates"]
    entry_dirs = sorted(
        d for d in candidates_dir.iterdir() if d.is_dir()
    )

    if not entry_dirs:
        print("No candidate directories found.")
        return None

    print(
        "For each entry, pick the best candidate number "
        "(1, 2, 3, etc.)."
    )
    print("Press Enter to skip an entry.")
    print()

    selections = []
    skipped = []

    for entry_dir in entry_dirs:
        svgs = sorted(entry_dir.glob("*.svg"))
        if not svgs:
            continue

        entry_id = entry_dir.name
        print(f"[{entry_id}] {len(svgs)} candidates:")
        for i, svg in enumerate(svgs, 1):
            size_kb = svg.stat().st_size / 1024
            print(f"  {i}. {svg.name} ({size_kb:.1f}KB)")

        choice = pick_number(
            f"  Pick candidate (1-{len(svgs)}): ",
            1, len(svgs),
        )
        if choice is not None:
            selected = svgs[choice - 1]
            try:
                rel_path = selected.relative_to(
                    PROJECT_ROOT
                )
            except ValueError:
                rel_path = selected
            selections.append({
                "id": entry_id,
                "category": category,
                "candidate": str(rel_path),
            })
            print(f"  -> Selected #{choice}")
        else:
            skipped.append(entry_id)
            print("  -> Skipped")

    if not selections:
        print("\nNo selections made.")
        return None, skipped

    # Save selections with timestamp to avoid overwriting
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    selections_path = SCRIPT_DIR / f"selections_{ts}.yaml"
    with open(selections_path, "w") as f:
        yaml.dump(
            {"selections": selections}, f,
            default_flow_style=False,
        )

    print(f"\n{len(selections)} selections saved to:")
    print(f"  {selections_path}")

    return selections_path, skipped


def step_optimize(config, selections_path):
    """Step 5: Optimize and export selected SVGs."""
    banner("Step 5: Optimize and Export")

    with open(selections_path) as f:
        data = yaml.safe_load(f)

    selections = data.get("selections", [])
    categories = sorted(
        {s["category"] for s in selections}
    ) if selections else []

    print(f"Selections:  {len(selections)}")
    for cat in categories:
        out = PROJECT_ROOT / config["output"].get(
            cat, "assets/unknown"
        )
        print(f"  {cat} -> {out}")
    print()
    print("Each SVG will be:")
    print("  1. Optimized with SVGO (strip metadata, merge paths)")
    print("  2. Verified renderable via cairosvg")
    print("  3. Copied to the Flutter assets directory")
    print()

    if not confirm("Optimize and export?"):
        print("Skipped optimization.")
        return False

    cmd = [
        sys.executable,
        str(SCRIPT_DIR / "optimize.py"),
        "--selections", str(selections_path),
    ]
    return run_step(cmd, "Optimizing and exporting SVGs")


def step_cleanup(config):
    """Optional: Clean up candidates and review sheets."""
    banner("Cleanup")

    candidates_dir = PROJECT_ROOT / config["output"]["candidates"]
    review_dir = PROJECT_ROOT / config["output"]["review"]

    print("Temporary files from this pipeline run:")
    if candidates_dir.exists():
        svg_count = len(list(candidates_dir.rglob("*.svg")))
        print(f"  Candidates: {candidates_dir} ({svg_count} SVGs)")
    if review_dir.exists():
        png_count = len(list(review_dir.glob("*.png")))
        print(f"  Reviews:    {review_dir} ({png_count} PNGs)")

    print()

    if confirm("Delete temporary files?", default=False):
        if candidates_dir.exists():
            shutil.rmtree(candidates_dir)
            print(f"  Deleted {candidates_dir}")
        if review_dir.exists():
            shutil.rmtree(review_dir)
            print(f"  Deleted {review_dir}")
    else:
        print("Kept temporary files.")


def main():
    parser = argparse.ArgumentParser(
        description="Interactive art asset pipeline",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Example:\n"
            "  python generate_assets.py "
            "eco_dex_entries.json\n"
            "  python generate_assets.py "
            "eco_dex_entries.json "
            "--ids flora_01 flora_02\n"
            "  python generate_assets.py "
            "garden.json --category garden\n"
        ),
    )
    parser.add_argument(
        "json_file",
        help="JSON file with entries to generate",
    )
    parser.add_argument(
        "--category",
        choices=VALID_CATEGORIES,
        help=(
            "Asset category (determines output directory). "
            "Auto-detected from filename via config if omitted"
        ),
    )
    parser.add_argument(
        "--subcategory",
        help=(
            "Filter entries by ID prefix "
            "(e.g. 'climate', 'flora')"
        ),
    )
    parser.add_argument(
        "--ids",
        nargs="+",
        help="Only process specific entry IDs",
    )
    parser.add_argument(
        "--skip-generate",
        action="store_true",
        help="Skip generation (use existing candidates)",
    )
    parser.add_argument(
        "--skip-validate",
        action="store_true",
        help="Skip validation step",
    )
    args = parser.parse_args()

    config = load_config()

    # Resolve JSON path: check as-is, then in data/app/
    json_path = Path(args.json_file)
    if not json_path.exists():
        fallback = DATA_DIR / json_path.name
        if fallback.exists():
            json_path = fallback
        else:
            parser.error(f"File not found: {args.json_file}")
    json_path = str(json_path)

    # Resolve --subcategory to --ids, or validate raw --ids
    if args.subcategory or args.ids:
        with open(json_path) as f:
            data = json.load(f)
        all_ids = {e["id"] for e in data.get("entries", [])}

        if args.subcategory:
            if args.ids:
                parser.error(
                    "--subcategory and --ids are "
                    "mutually exclusive"
                )
            prefix = args.subcategory.rstrip("_") + "_"
            matched = sorted(i for i in all_ids if i.startswith(prefix))
            if not matched:
                parser.error(
                    f"No entries match subcategory "
                    f"'{args.subcategory}'"
                )
            args.ids = matched
        else:
            unknown = [i for i in args.ids if i not in all_ids]
            if unknown:
                hint = ""
                for u in unknown:
                    padded = (
                        f"{u.rsplit('_', 1)[0]}_"
                        f"{int(u.rsplit('_', 1)[1]):02d}"
                        if "_" in u and u.rsplit("_", 1)[1].isdigit()
                        else None
                    )
                    if padded and padded in all_ids:
                        hint += f"\n  did you mean '{padded}'?"
                parser.error(
                    f"Unknown ID(s): {', '.join(unknown)}{hint}"
                )

    category = args.category or infer_category(
        json_path, config,
    )
    if not category:
        parser.error(
            f"Cannot infer category from "
            f"'{Path(args.json_file).name}'. "
            f"Use --category ({', '.join(VALID_CATEGORIES)})"
        )

    banner("Seed Art Pipeline")
    print(f"JSON:      {json_path}")
    print(f"Category:  {category}")
    if args.ids:
        print(f"IDs:       {', '.join(args.ids)}")
    print()

    # Step 1: Generate
    if not args.skip_generate:
        step_generate(config, json_path, args.ids)
    else:
        print("(Skipping generation -- using existing candidates)")

    # Step 2: Validate
    if not args.skip_validate:
        step_validate(config)
    else:
        print("(Skipping validation)")

    # Step 3: Review sheets
    step_review(config)

    # Wait for human review
    if not confirm("\nDone reviewing? Ready to select?"):
        print(
            "\nRe-run with --skip-generate to resume from "
            "here later."
        )
        return

    # Step 4: Select
    selections_path, skipped = step_select(config, category)
    if not selections_path:
        print("\nNo selections made. Exiting.")
        return

    # Step 5: Optimize and export
    step_optimize(config, selections_path)

    # Optional cleanup
    step_cleanup(config)

    banner("Done")
    output_dir = (
        PROJECT_ROOT / config["output"][category]
    )
    print(f"Assets exported to: {output_dir}")
    print()
    print("Next steps:")
    print("  1. Add assets to pubspec.yaml")
    print("  2. Update code to reference new asset paths")
    print("  3. Run: flutter analyze && flutter test")

    if skipped:
        print()
        print(f"Skipped {len(skipped)} entries. "
              "To regenerate them:")
        ids_str = " ".join(skipped)
        print(
            f"  python scripts/art_pipeline/"
            f"generate_assets.py "
            f"{Path(json_path).name} "
            f"--ids {ids_str}"
        )


if __name__ == "__main__":
    main()
