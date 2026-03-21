#!/usr/bin/env python3
"""Interactive art asset pipeline.

Walks through the full generate -> validate -> review -> select ->
optimize flow step by step, prompting for input at each stage.

Usage:
    python generate_assets.py --manifest eco_dex_manifest.yaml
    python generate_assets.py --manifest eco_dex_manifest.yaml \
        --category eco_dex
    python generate_assets.py --manifest eco_dex_manifest.yaml \
        --ids flora_01 flora_02 --category eco_dex
"""

import argparse
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path
import yaml

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CONFIG_PATH = SCRIPT_DIR / "config.yaml"


def load_config():
    with open(CONFIG_PATH) as f:
        return yaml.safe_load(f)


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


def step_generate(config, manifest_path, ids=None):
    """Step 1: Generate SVG candidates via Recraft API."""
    banner("Step 1: Generate SVG Candidates")

    with open(manifest_path) as f:
        manifest = yaml.safe_load(f)

    entries = manifest.get("entries", [])
    if ids:
        entries = [e for e in entries if e["id"] in ids]

    n_candidates = config["recraft"]["candidates_per_asset"]
    total_svgs = len(entries) * n_candidates
    tokens = total_svgs * config["recraft"]["tokens_per_svg"]
    budget = config["recraft"]["monthly_token_budget"]

    print(f"Manifest:    {manifest_path}")
    print(f"Entries:     {len(entries)}")
    print(f"Candidates:  {n_candidates} per entry")
    print(f"Total SVGs:  {total_svgs}")
    print(f"Tokens:      {tokens}/{budget} monthly budget")
    print()

    # Show first few entries
    print("Entries to generate:")
    for entry in entries[:5]:
        print(f"  - {entry['id']}: {entry['subject']}")
    if len(entries) > 5:
        print(f"  ... and {len(entries) - 5} more")
    print()

    if not confirm("Proceed with generation?"):
        print("Skipped generation.")
        return False

    cmd = [
        sys.executable,
        str(SCRIPT_DIR / "generate.py"),
        "--manifest", str(manifest_path),
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
            print("  -> Skipped")

    if not selections:
        print("\nNo selections made.")
        return None

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

    return selections_path


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
            "--manifest eco_dex_manifest.yaml "
            "--category eco_dex\n"
            "  python generate_assets.py "
            "--manifest eco_dex_manifest.yaml "
            "--ids flora_01 flora_02 "
            "--category eco_dex\n"
        ),
    )
    parser.add_argument(
        "--manifest",
        required=True,
        help="YAML manifest with entries to generate",
    )
    parser.add_argument(
        "--category",
        required=True,
        choices=["eco_dex", "garden", "mascots"],
        help="Asset category (determines output directory)",
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

    banner("Seed Art Pipeline")
    print(f"Manifest:  {args.manifest}")
    print(f"Category:  {args.category}")
    if args.ids:
        print(f"IDs:       {', '.join(args.ids)}")
    print()

    # Step 1: Generate
    if not args.skip_generate:
        step_generate(config, args.manifest, args.ids)
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
    selections_path = step_select(config, args.category)
    if not selections_path:
        print("\nNo selections made. Exiting.")
        return

    # Step 5: Optimize and export
    step_optimize(config, selections_path)

    # Optional cleanup
    step_cleanup(config)

    banner("Done")
    output_dir = (
        PROJECT_ROOT / config["output"][args.category]
    )
    print(f"Assets exported to: {output_dir}")
    print()
    print("Next steps:")
    print("  1. Add assets to pubspec.yaml")
    print("  2. Update code to reference new asset paths")
    print("  3. Run: flutter analyze && flutter test")


if __name__ == "__main__":
    main()
