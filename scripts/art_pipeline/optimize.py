#!/usr/bin/env python3
"""Optimize selected SVGs with SVGO and export to asset dirs.

After human review, run this on selected candidates to optimize
and copy them to the correct Flutter asset directory.

Usage:
    python optimize.py --input candidates/flora_01/candidate_2.svg --category eco_dex --id flora_01
    python optimize.py --selections selections.yaml
"""

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

import yaml
from lxml import etree

from _common import PROJECT_ROOT, load_config, render_svg


def run_svgo(input_path, output_path, config):
    """Run SVGO on an SVG file."""
    svgo_parts = config["svgo"]["command"].split()
    cmd = [*svgo_parts, str(input_path), "-o", str(output_path)]

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30,
        )
        if result.returncode != 0:
            print(f"  SVGO error: {result.stderr.strip()}")
            return False
        return True
    except subprocess.TimeoutExpired:
        print("  SVGO timed out")
        return False


def verify_render(svg_path):
    """Verify SVG renders correctly via cairosvg."""
    try:
        render_svg(svg_path, 512)
        return True
    except Exception as e:
        print(f"  Render failed: {e}")
        return False


def fix_dark_mode_colors(svg_path):
    """Fix colors for dark mode compatibility.

    - Remove white background rects
    - Replace pure white (#FFFFFF) fills with off-white (#FAFAFA)
    - Replace pure black (#000000) fills with dark grey (#212121)
    """
    content = svg_path.read_text()
    ns = {"svg": "http://www.w3.org/2000/svg"}
    changes = []

    try:
        tree = etree.fromstring(content.encode())
    except etree.XMLSyntaxError:
        return 0

    # Remove background rects (first rect child of svg that
    # fills the entire canvas with white/near-white)
    root_rects = tree.findall("svg:rect", ns)
    if not root_rects:
        # Also check without namespace (bare SVG)
        root_rects = tree.findall("rect")
    for rect in root_rects:
        fill = (rect.get("fill") or "").upper()
        if fill in ("#FFFFFF", "#FFF", "WHITE"):
            w = rect.get("width", "")
            h = rect.get("height", "")
            is_fullsize = w == "100%" or h == "100%"
            if not is_fullsize:
                try:
                    w_num = float(w.rstrip("px"))
                    h_num = float(h.rstrip("px"))
                    is_fullsize = (
                        w_num == h_num and w_num >= 512
                    )
                except (ValueError, TypeError):
                    pass
            if is_fullsize:
                rect.getparent().remove(rect)
                changes.append("removed background rect")
                break

    # Serialize back to string for regex replacements
    svg_str = etree.tostring(
        tree, encoding="unicode", xml_declaration=False
    )

    # Replace pure white fills/strokes with off-white
    white_re = re.compile(
        r'(fill|stroke)\s*[=:]\s*["\']?#(?:FFFFFF|FFF|ffffff|fff)\b'
    )
    if white_re.search(svg_str):
        svg_str = re.sub(
            r'((?:fill|stroke)\s*[=:]\s*["\']?)#(?:FFFFFF|FFF|ffffff|fff)\b',
            r'\g<1>#FAFAFA',
            svg_str,
        )
        changes.append("#FFFFFF -> #FAFAFA")

    # Replace pure black fills/strokes with dark grey
    black_re = re.compile(
        r'(fill|stroke)\s*[=:]\s*["\']?#(?:000000|000)\b'
    )
    if black_re.search(svg_str):
        svg_str = re.sub(
            r'((?:fill|stroke)\s*[=:]\s*["\']?)#(?:000000|000)\b',
            r'\g<1>#212121',
            svg_str,
        )
        changes.append("#000000 -> #212121")

    if changes:
        svg_path.write_text(svg_str)
        print(f"  Dark mode fixes: {', '.join(changes)}")

    return len(changes)


def optimize_and_export(
    input_path, category, asset_id, config
):
    """Optimize one SVG and export to the correct asset dir."""
    output_dir = PROJECT_ROOT / config["output"][category]
    output_dir.mkdir(parents=True, exist_ok=True)

    output_path = output_dir / f"{asset_id}.svg"
    temp_path = input_path.with_suffix(".optimized.svg")

    print(f"[{asset_id}] {input_path.name}")

    # Original size
    orig_size = input_path.stat().st_size
    print(f"  Original: {orig_size / 1024:.1f}KB")

    # Run SVGO
    print("  Optimizing with SVGO...", end=" ")
    if run_svgo(input_path, temp_path, config):
        opt_size = temp_path.stat().st_size
        reduction = (1 - opt_size / orig_size) * 100
        print(
            f"{opt_size / 1024:.1f}KB "
            f"(-{reduction:.0f}%)"
        )
    else:
        # Fallback: copy without optimization
        print("FAILED, copying unoptimized")
        shutil.copy2(input_path, temp_path)

    # Fix colors for dark mode compatibility
    fix_dark_mode_colors(temp_path)

    # Verify render
    print("  Verifying render...", end=" ")
    if verify_render(temp_path):
        print("OK")
    else:
        print("WARN: render issues detected")

    # Check size limit
    max_size = config["validation"]["max_optimized_size_bytes"]
    final_size = temp_path.stat().st_size
    if final_size > max_size:
        print(
            f"  WARN: {final_size / 1024:.1f}KB "
            f"exceeds {max_size / 1024:.1f}KB target"
        )

    # Move to final location
    shutil.move(str(temp_path), str(output_path))
    print(f"  -> {output_path}")

    return True


def process_selections(selections_path, config):
    """Process a selections YAML file.

    Format:
        selections:
          - id: flora_01
            category: eco_dex
            candidate: candidates/flora_01/candidate_2.svg
          - id: oak_seedling
            category: garden
            candidate: candidates/oak_seedling/candidate_1.svg
    """
    with open(selections_path) as f:
        data = yaml.safe_load(f)

    selections = data.get("selections", [])
    if not selections:
        print("No selections found in file.")
        return

    print(f"Processing {len(selections)} selections\n")

    success = 0
    for sel in selections:
        input_path = Path(sel["candidate"])
        if not input_path.is_absolute():
            input_path = PROJECT_ROOT / input_path

        if not input_path.exists():
            print(f"[{sel['id']}] NOT FOUND: {input_path}")
            continue

        if optimize_and_export(
            input_path, sel["category"], sel["id"], config
        ):
            success += 1
        print()

    print(f"\n--- {success}/{len(selections)} exported ---")


def main():
    parser = argparse.ArgumentParser(
        description="Optimize SVGs and export to asset dirs"
    )
    parser.add_argument(
        "--input", help="Single SVG file to optimize"
    )
    parser.add_argument(
        "--category",
        choices=["eco_dex", "garden", "mascots"],
        help="Asset category for output directory",
    )
    parser.add_argument(
        "--id", help="Asset ID (becomes filename)"
    )
    parser.add_argument(
        "--selections",
        help="YAML file mapping selections to assets",
    )
    args = parser.parse_args()

    config = load_config()

    if args.selections:
        process_selections(args.selections, config)
    elif args.input and args.category and args.id:
        input_path = Path(args.input)
        if not input_path.exists():
            print(f"File not found: {input_path}")
            sys.exit(1)
        optimize_and_export(
            input_path, args.category, args.id, config
        )
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
