#!/usr/bin/env python3
"""Generate contact sheets for human review of SVG candidates.

Renders all candidates for each entry into a grid image for
side-by-side comparison. Annotates with entry ID and candidate
number.

Usage:
    python review.py --candidates-dir candidates/
    python review.py --candidates-dir candidates/flora_01
    python review.py --candidates-dir candidates/ --cols 4
"""

import argparse
import sys
from io import BytesIO
from pathlib import Path

import cairosvg
import yaml
from PIL import Image, ImageDraw, ImageFont

SCRIPT_DIR = Path(__file__).parent
CONFIG_PATH = SCRIPT_DIR / "config.yaml"
PROJECT_ROOT = SCRIPT_DIR.parent.parent

THUMB_SIZE = 256
PADDING = 16
LABEL_HEIGHT = 28
BG_COLOR = (245, 245, 245)
LABEL_BG = (66, 66, 66)
LABEL_FG = (255, 255, 255)


def load_config():
    with open(CONFIG_PATH) as f:
        return yaml.safe_load(f)


def svg_to_thumbnail(svg_path, size=THUMB_SIZE):
    """Render SVG to PIL Image thumbnail."""
    try:
        png_bytes = cairosvg.svg2png(
            url=str(svg_path),
            output_width=size,
            output_height=size,
        )
        return Image.open(BytesIO(png_bytes)).convert("RGBA")
    except Exception as e:
        # Return error placeholder
        img = Image.new("RGBA", (size, size), (255, 200, 200, 255))
        draw = ImageDraw.Draw(img)
        draw.text((10, size // 2), f"Error:\n{e}", fill=(200, 0, 0))
        return img


def create_contact_sheet(entry_id, svg_paths, cols=3):
    """Create a contact sheet image for one entry's candidates."""
    n = len(svg_paths)
    if n == 0:
        return None

    rows = (n + cols - 1) // cols
    cell_w = THUMB_SIZE + PADDING
    cell_h = THUMB_SIZE + LABEL_HEIGHT + PADDING

    sheet_w = cols * cell_w + PADDING
    sheet_h = (
        rows * cell_h + PADDING + LABEL_HEIGHT + PADDING
    )

    sheet = Image.new("RGB", (sheet_w, sheet_h), BG_COLOR)
    draw = ImageDraw.Draw(sheet)

    # Title bar
    draw.rectangle(
        [0, 0, sheet_w, LABEL_HEIGHT + PADDING],
        fill=LABEL_BG,
    )
    draw.text(
        (PADDING, 6),
        f"  {entry_id}  ({n} candidates)",
        fill=LABEL_FG,
    )

    y_offset = LABEL_HEIGHT + PADDING * 2

    for i, svg_path in enumerate(svg_paths):
        row = i // cols
        col = i % cols

        x = PADDING + col * cell_w
        y = y_offset + row * cell_h

        # Render thumbnail
        thumb = svg_to_thumbnail(svg_path)
        # Paste with white background
        bg = Image.new("RGB", thumb.size, (255, 255, 255))
        bg.paste(thumb, mask=thumb.split()[3] if thumb.mode == "RGBA" else None)
        sheet.paste(bg, (x, y))

        # Label
        label = f"#{i + 1} - {svg_path.name}"
        size_kb = svg_path.stat().st_size / 1024
        label += f" ({size_kb:.1f}KB)"
        draw.text(
            (x + 4, y + THUMB_SIZE + 4),
            label,
            fill=(100, 100, 100),
        )

    return sheet


def main():
    parser = argparse.ArgumentParser(
        description="Generate review contact sheets"
    )
    parser.add_argument(
        "--candidates-dir",
        required=True,
        help="Directory with candidate SVGs",
    )
    parser.add_argument(
        "--cols",
        type=int,
        default=3,
        help="Columns per row (default: 3)",
    )
    parser.add_argument(
        "--output-dir",
        help="Output directory for sheets (default: from config)",
    )
    args = parser.parse_args()

    config = load_config()
    candidates_dir = Path(args.candidates_dir)

    output_dir = Path(
        args.output_dir
        or PROJECT_ROOT / config["output"]["review"]
    )
    output_dir.mkdir(parents=True, exist_ok=True)

    # Find entry directories (or treat as single entry)
    if any(candidates_dir.glob("*.svg")):
        # Single entry directory
        entries = [(candidates_dir.name, candidates_dir)]
    else:
        entries = sorted(
            (d.name, d)
            for d in candidates_dir.iterdir()
            if d.is_dir()
        )

    if not entries:
        print("No candidate directories found.")
        sys.exit(1)

    for entry_id, entry_dir in entries:
        svgs = sorted(entry_dir.glob("*.svg"))
        if not svgs:
            continue

        print(
            f"[{entry_id}] "
            f"Rendering {len(svgs)} candidates...",
            end=" ",
        )

        sheet = create_contact_sheet(
            entry_id, svgs, cols=args.cols
        )
        if sheet:
            output_path = output_dir / f"{entry_id}_review.png"
            sheet.save(output_path)
            print(f"-> {output_path.name}")
        else:
            print("SKIPPED (no SVGs)")

    print(f"\nReview sheets saved to {output_dir}")


if __name__ == "__main__":
    main()
