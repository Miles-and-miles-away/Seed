#!/usr/bin/env python3
"""Config paths and SVG rasterising shared by the art pipeline scripts.

Imported by sibling scripts in this directory, which Python puts on
sys.path when they are run directly.
"""
from io import BytesIO
from pathlib import Path

import cairosvg
import yaml
from PIL import Image

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CONFIG_PATH = SCRIPT_DIR / "config.yaml"


def load_config():
    with open(CONFIG_PATH) as f:
        return yaml.safe_load(f)


def render_svg(svg_path, size, mode="RGBA"):
    """Rasterise an SVG to a square PIL image."""
    png_bytes = cairosvg.svg2png(
        url=str(svg_path),
        output_width=size,
        output_height=size,
    )
    return Image.open(BytesIO(png_bytes)).convert(mode)
