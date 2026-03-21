#!/usr/bin/env python3
"""Validate generated SVG candidates for style consistency.

Checks:
  1. SVG structure (valid XML, no embedded rasters, viewBox)
  2. Color palette adherence (CIELAB distance from app palette)
  3. File size limits
  4. CLIP embedding similarity against reference images

Usage:
    python validate.py --candidates-dir candidates/flora_01
    python validate.py --candidates-dir candidates/ --all
    python validate.py --svg single_file.svg
"""

import argparse
import json
import math
import re
import sys
from io import BytesIO
from pathlib import Path

import cairosvg
import yaml
from lxml import etree
from PIL import Image

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CONFIG_PATH = SCRIPT_DIR / "config.yaml"

# Optional CLIP import -- graceful fallback
CLIP_AVAILABLE = False
try:
    import open_clip
    import torch

    CLIP_AVAILABLE = True
except ImportError:
    pass


def load_config():
    with open(CONFIG_PATH) as f:
        return yaml.safe_load(f)


# --- Color utilities ---

def hex_to_rgb(hex_color):
    """Convert hex color string to RGB tuple."""
    h = hex_color.lstrip("#")
    return tuple(int(h[i : i + 2], 16) for i in (0, 2, 4))


def rgb_to_lab(rgb):
    """Convert RGB to CIELAB (approximate)."""
    # Normalize to 0-1
    r, g, b = [c / 255.0 for c in rgb]

    # sRGB to linear
    def linearize(c):
        return (
            c / 12.92
            if c <= 0.04045
            else ((c + 0.055) / 1.055) ** 2.4
        )

    r, g, b = linearize(r), linearize(g), linearize(b)

    # Linear RGB to XYZ (D65)
    x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375
    y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750
    z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041

    # XYZ to Lab
    xn, yn, zn = 0.95047, 1.0, 1.08883
    x, y, z = x / xn, y / yn, z / zn

    def f(t):
        return (
            t ** (1 / 3)
            if t > 0.008856
            else 7.787 * t + 16 / 116
        )

    l_star = 116 * f(y) - 16
    a_star = 500 * (f(x) - f(y))
    b_star = 200 * (f(y) - f(z))

    return (l_star, a_star, b_star)


def color_distance(lab1, lab2):
    """Euclidean distance in CIELAB space."""
    return math.sqrt(
        sum((a - b) ** 2 for a, b in zip(lab1, lab2))
    )


def extract_svg_colors(svg_path):
    """Extract hex colors from SVG fill/stroke attributes."""
    content = svg_path.read_text()
    # Match hex colors in attributes and style properties
    hex_pattern = r"#[0-9A-Fa-f]{6}\b|#[0-9A-Fa-f]{3}\b"
    colors = set(re.findall(hex_pattern, content))

    # Normalize 3-digit hex to 6-digit
    normalized = set()
    for c in colors:
        if len(c) == 4:  # #RGB
            normalized.add(
                f"#{c[1]*2}{c[2]*2}{c[3]*2}".upper()
            )
        else:
            normalized.add(c.upper())
    return normalized


def build_palette_labs(config):
    """Build list of CIELAB values from config palette."""
    labs = []
    palette = config["palette"]
    for group in palette.values():
        for hex_color in group:
            labs.append(rgb_to_lab(hex_to_rgb(hex_color)))
    return labs


def check_color_adherence(svg_colors, palette_labs, threshold):
    """Count colors that are too far from the app palette."""
    off_palette = []
    for hex_color in svg_colors:
        try:
            rgb = hex_to_rgb(hex_color)
        except (ValueError, IndexError):
            continue

        lab = rgb_to_lab(rgb)
        min_dist = min(
            color_distance(lab, p) for p in palette_labs
        )
        if min_dist > threshold:
            off_palette.append((hex_color, min_dist))

    return off_palette


# --- SVG structure checks ---

def check_svg_structure(svg_path):
    """Validate SVG structure. Returns list of issues."""
    issues = []
    content = svg_path.read_bytes()

    try:
        tree = etree.fromstring(content)
    except etree.XMLSyntaxError as e:
        return [f"Invalid XML: {e}"]

    # Check root element
    tag = etree.QName(tree.tag).localname
    if tag != "svg":
        issues.append(f"Root element is '{tag}', expected 'svg'")

    # Check for embedded rasters (base64 images)
    ns = {"svg": "http://www.w3.org/2000/svg"}
    xlink = "http://www.w3.org/1999/xlink"
    images = tree.findall(".//svg:image", ns)
    if not images:
        # Also check without namespace (bare SVG)
        images = tree.findall(".//image")
    for img in images:
        href = img.get("href") or img.get(f"{{{xlink}}}href", "")
        if "base64" in href:
            issues.append("Contains embedded raster image (base64)")
            break

    # Check viewBox
    viewbox = tree.get("viewBox")
    if not viewbox:
        issues.append("Missing viewBox attribute")

    return issues


def check_file_size(svg_path, max_bytes):
    """Check file size against limit."""
    size = svg_path.stat().st_size
    if size > max_bytes:
        return (
            f"File size {size / 1024:.1f}KB "
            f"exceeds {max_bytes / 1024:.1f}KB limit"
        )
    return None


# --- CLIP similarity ---

def render_svg_to_image(svg_path, size=224):
    """Render SVG to PIL Image for CLIP."""
    png_bytes = cairosvg.svg2png(
        url=str(svg_path),
        output_width=size,
        output_height=size,
    )
    return Image.open(BytesIO(png_bytes)).convert("RGB")


class CLIPValidator:
    """CLIP-based style consistency checker."""

    def __init__(self):
        if not CLIP_AVAILABLE:
            raise ImportError(
                "Install open_clip_torch: "
                "pip install open_clip_torch torch"
            )
        self.model, _, self.preprocess = (
            open_clip.create_model_and_transforms(
                "ViT-B-32", pretrained="laion2b_s34b_b79k"
            )
        )
        self.model.eval()
        self.reference_embeddings = []

    def add_reference(self, image_path):
        """Add a reference image for comparison."""
        if isinstance(image_path, Path) and image_path.suffix == ".svg":
            img = render_svg_to_image(image_path)
        else:
            img = Image.open(image_path).convert("RGB")

        tensor = self.preprocess(img).unsqueeze(0)
        with torch.no_grad():
            embedding = self.model.encode_image(tensor)
            embedding = embedding / embedding.norm(
                dim=-1, keepdim=True
            )
        self.reference_embeddings.append(embedding)

    def score(self, image_path):
        """Score similarity against references (0-1)."""
        if not self.reference_embeddings:
            return 1.0  # No references, pass by default

        if isinstance(image_path, Path) and image_path.suffix == ".svg":
            img = render_svg_to_image(image_path)
        else:
            img = Image.open(image_path).convert("RGB")

        tensor = self.preprocess(img).unsqueeze(0)
        with torch.no_grad():
            embedding = self.model.encode_image(tensor)
            embedding = embedding / embedding.norm(
                dim=-1, keepdim=True
            )

        similarities = []
        for ref in self.reference_embeddings:
            sim = (embedding @ ref.T).item()
            similarities.append(sim)

        return sum(similarities) / len(similarities)


# --- Main validation ---

def validate_svg(
    svg_path, config, clip_validator=None, palette_labs=None
):
    """Run all checks on a single SVG. Returns (pass, results)."""
    results = {"path": str(svg_path), "checks": {}, "passed": True}
    thresholds = config["validation"]

    # 1. SVG structure
    structure_issues = check_svg_structure(svg_path)
    results["checks"]["structure"] = {
        "passed": len(structure_issues) == 0,
        "issues": structure_issues,
    }

    # 2. File size
    size_issue = check_file_size(
        svg_path, thresholds["max_file_size_bytes"]
    )
    results["checks"]["file_size"] = {
        "passed": size_issue is None,
        "size_kb": svg_path.stat().st_size / 1024,
        "issue": size_issue,
    }

    # 3. Color palette
    svg_colors = extract_svg_colors(svg_path)
    if palette_labs is None:
        palette_labs = build_palette_labs(config)
    off_palette = check_color_adherence(
        svg_colors, palette_labs,
        thresholds["color_distance_threshold"],
    )
    max_off = thresholds["max_off_palette_colors"]
    results["checks"]["color_palette"] = {
        "passed": len(off_palette) <= max_off,
        "total_colors": len(svg_colors),
        "off_palette_count": len(off_palette),
        "off_palette": [
            {"color": c, "distance": round(d, 1)}
            for c, d in off_palette
        ],
    }

    # 4. CLIP similarity (if available)
    if clip_validator:
        try:
            score = clip_validator.score(svg_path)
            min_score = thresholds["clip_similarity_min"]
            results["checks"]["clip_similarity"] = {
                "passed": score >= min_score,
                "score": round(score, 3),
                "threshold": min_score,
            }
        except Exception as e:
            results["checks"]["clip_similarity"] = {
                "passed": True,
                "skipped": True,
                "reason": str(e),
            }
    else:
        results["checks"]["clip_similarity"] = {
            "passed": True,
            "skipped": True,
            "reason": "CLIP not available",
        }

    # Overall pass/fail
    results["passed"] = all(
        c["passed"] for c in results["checks"].values()
    )
    return results


def print_results(results):
    """Pretty-print validation results."""
    path = Path(results["path"]).name
    status = "PASS" if results["passed"] else "FAIL"
    print(f"  [{status}] {path}")

    for name, check in results["checks"].items():
        if check.get("skipped"):
            continue
        icon = "+" if check["passed"] else "x"
        detail = ""

        if name == "structure" and check.get("issues"):
            detail = f" -- {'; '.join(check['issues'])}"
        elif name == "file_size":
            detail = f" -- {check['size_kb']:.1f}KB"
            if check.get("issue"):
                detail += f" ({check['issue']})"
        elif name == "color_palette":
            detail = (
                f" -- {check['off_palette_count']}/"
                f"{check['total_colors']} off-palette"
            )
        elif name == "clip_similarity" and "score" in check:
            detail = (
                f" -- {check['score']:.3f} "
                f"(min {check['threshold']})"
            )

        print(f"    [{icon}] {name}{detail}")


def main():
    parser = argparse.ArgumentParser(
        description="Validate SVG candidates"
    )
    parser.add_argument(
        "--candidates-dir",
        help="Directory of candidate SVGs (or parent dir with --all)",
    )
    parser.add_argument(
        "--svg", help="Single SVG file to validate"
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Validate all subdirs in candidates-dir",
    )
    parser.add_argument(
        "--references",
        nargs="*",
        help="Reference images for CLIP comparison",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output results as JSON",
    )
    args = parser.parse_args()

    config = load_config()

    # Set up CLIP if references provided
    clip_validator = None
    if args.references and CLIP_AVAILABLE:
        print("Loading CLIP model...")
        clip_validator = CLIPValidator()
        for ref in args.references:
            clip_validator.add_reference(Path(ref))
        print(
            f"Loaded {len(args.references)} reference images\n"
        )

    all_results = []
    palette_labs = build_palette_labs(config)

    if args.svg:
        svg_path = Path(args.svg)
        results = validate_svg(
            svg_path, config, clip_validator, palette_labs
        )
        all_results.append(results)
        if not args.json:
            print_results(results)

    elif args.candidates_dir:
        candidates_dir = Path(args.candidates_dir)
        if args.all:
            dirs = sorted(
                d for d in candidates_dir.iterdir()
                if d.is_dir()
            )
        else:
            dirs = [candidates_dir]

        for entry_dir in dirs:
            svgs = sorted(entry_dir.glob("*.svg"))
            if not svgs:
                continue

            if not args.json:
                print(f"\n{entry_dir.name}:")

            for svg_path in svgs:
                results = validate_svg(
                    svg_path, config, clip_validator,
                    palette_labs,
                )
                all_results.append(results)
                if not args.json:
                    print_results(results)
    else:
        parser.print_help()
        sys.exit(1)

    if args.json:
        print(json.dumps(all_results, indent=2))

    # Summary
    passed = sum(1 for r in all_results if r["passed"])
    total = len(all_results)
    if not args.json and total > 0:
        print(f"\n--- {passed}/{total} passed ---")

    sys.exit(0 if passed == total else 1)


if __name__ == "__main__":
    main()
