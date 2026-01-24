#!/usr/bin/env python3
"""Generate iOS app icons from SVG source."""

import cairosvg
from pathlib import Path

# Paths
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
SVG_SOURCE = PROJECT_ROOT / "assets" / "images" / "app_icon.svg"
OUTPUT_DIR = PROJECT_ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"

# iOS icon size specifications: (filename, pixel_size)
IOS_ICONS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]

def main():
    print(f"SVG source: {SVG_SOURCE}")
    print(f"Output directory: {OUTPUT_DIR}")

    if not SVG_SOURCE.exists():
        print(f"ERROR: SVG file not found at {SVG_SOURCE}")
        return 1

    if not OUTPUT_DIR.exists():
        print(f"ERROR: Output directory not found at {OUTPUT_DIR}")
        return 1

    svg_data = SVG_SOURCE.read_bytes()

    for filename, size in IOS_ICONS:
        output_path = OUTPUT_DIR / filename
        print(f"Generating {filename} ({size}x{size}px)...")

        cairosvg.svg2png(
            bytestring=svg_data,
            write_to=str(output_path),
            output_width=size,
            output_height=size,
        )

    print(f"\nSuccessfully generated {len(IOS_ICONS)} iOS icons!")
    return 0

if __name__ == "__main__":
    exit(main())
