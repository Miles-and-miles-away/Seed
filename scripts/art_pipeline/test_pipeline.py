#!/usr/bin/env python3
"""Tests for art pipeline utility functions.

Run: conda activate seed && python -m pytest test_pipeline.py -v
"""

import math
import textwrap
from pathlib import Path
from unittest.mock import patch

import pytest
import yaml

SCRIPT_DIR = Path(__file__).parent

# --- Fixtures ---


@pytest.fixture
def config():
    with open(SCRIPT_DIR / "config.yaml") as f:
        return yaml.safe_load(f)


@pytest.fixture
def tmp_svg(tmp_path):
    """Create a minimal valid SVG file."""
    svg = textwrap.dedent("""\
        <?xml version="1.0" encoding="UTF-8"?>
        <svg xmlns="http://www.w3.org/2000/svg"
             viewBox="0 0 1024 1024" width="1024" height="1024">
          <circle cx="512" cy="512" r="400"
                  fill="#2E7D32" stroke="#005005"/>
        </svg>
    """)
    path = tmp_path / "test.svg"
    path.write_text(svg)
    return path


@pytest.fixture
def tmp_svg_no_viewbox(tmp_path):
    svg = textwrap.dedent("""\
        <?xml version="1.0" encoding="UTF-8"?>
        <svg xmlns="http://www.w3.org/2000/svg"
             width="1024" height="1024">
          <circle cx="512" cy="512" r="400" fill="#2E7D32"/>
        </svg>
    """)
    path = tmp_path / "no_viewbox.svg"
    path.write_text(svg)
    return path


@pytest.fixture
def tmp_svg_with_raster(tmp_path):
    svg = textwrap.dedent("""\
        <?xml version="1.0" encoding="UTF-8"?>
        <svg xmlns="http://www.w3.org/2000/svg"
             viewBox="0 0 1024 1024">
          <image href="data:image/png;base64,iVBOR"/>
        </svg>
    """)
    path = tmp_path / "raster.svg"
    path.write_text(svg)
    return path


@pytest.fixture
def tmp_svg_invalid_xml(tmp_path):
    path = tmp_path / "invalid.svg"
    path.write_text("<svg><not-closed>")
    return path


@pytest.fixture
def tmp_svg_white_bg(tmp_path):
    """SVG with a white background rect to strip."""
    svg = textwrap.dedent("""\
        <?xml version="1.0" encoding="UTF-8"?>
        <svg xmlns="http://www.w3.org/2000/svg"
             viewBox="0 0 1024 1024">
          <rect width="1024" height="1024" fill="#FFFFFF"/>
          <circle cx="512" cy="512" r="400"
                  fill="#FFFFFF" stroke="#000000"/>
        </svg>
    """)
    path = tmp_path / "white_bg.svg"
    path.write_text(svg)
    return path


@pytest.fixture
def tmp_svg_percent_bg(tmp_path):
    """SVG with a 100% width/height white background rect."""
    svg = textwrap.dedent("""\
        <?xml version="1.0" encoding="UTF-8"?>
        <svg xmlns="http://www.w3.org/2000/svg"
             viewBox="0 0 1024 1024">
          <rect width="100%" height="100%" fill="#FFFFFF"/>
          <circle cx="512" cy="512" r="200" fill="#4CAF50"/>
        </svg>
    """)
    path = tmp_path / "percent_bg.svg"
    path.write_text(svg)
    return path


# ============================================================
# validate.py tests
# ============================================================

from validate import (
    build_palette_labs,
    check_color_adherence,
    check_file_size,
    check_svg_structure,
    color_distance,
    extract_svg_colors,
    hex_to_rgb,
    rgb_to_lab,
)


class TestHexToRgb:
    def test_standard_hex(self):
        assert hex_to_rgb("#FF0000") == (255, 0, 0)
        assert hex_to_rgb("#00FF00") == (0, 255, 0)
        assert hex_to_rgb("#0000FF") == (0, 0, 255)

    def test_lowercase(self):
        assert hex_to_rgb("#ff8800") == (255, 136, 0)

    def test_mixed_case(self):
        assert hex_to_rgb("#2E7D32") == (46, 125, 50)

    def test_black_and_white(self):
        assert hex_to_rgb("#000000") == (0, 0, 0)
        assert hex_to_rgb("#FFFFFF") == (255, 255, 255)

    def test_without_hash(self):
        assert hex_to_rgb("2E7D32") == (46, 125, 50)


class TestRgbToLab:
    def test_black(self):
        l, a, b = rgb_to_lab((0, 0, 0))
        assert abs(l) < 1
        assert abs(a) < 1
        assert abs(b) < 1

    def test_white(self):
        l, a, b = rgb_to_lab((255, 255, 255))
        assert abs(l - 100) < 1
        assert abs(a) < 1
        assert abs(b) < 1

    def test_pure_red_positive_a(self):
        _, a, _ = rgb_to_lab((255, 0, 0))
        assert a > 50

    def test_pure_green_negative_a(self):
        _, a, _ = rgb_to_lab((0, 255, 0))
        assert a < -50


class TestColorDistance:
    def test_same_color_zero(self):
        lab = rgb_to_lab((128, 64, 32))
        assert color_distance(lab, lab) == 0.0

    def test_black_white_large(self):
        black = rgb_to_lab((0, 0, 0))
        white = rgb_to_lab((255, 255, 255))
        assert color_distance(black, white) > 90

    def test_similar_greens_small(self):
        g1 = rgb_to_lab(hex_to_rgb("#2E7D32"))
        g2 = rgb_to_lab(hex_to_rgb("#4CAF50"))
        dist = color_distance(g1, g2)
        assert dist < 40

    def test_symmetry(self):
        a = rgb_to_lab((100, 50, 200))
        b = rgb_to_lab((200, 100, 50))
        assert color_distance(a, b) == color_distance(b, a)


class TestExtractSvgColors:
    def test_extracts_fill_colors(self, tmp_svg):
        colors = extract_svg_colors(tmp_svg)
        assert "#2E7D32" in colors
        assert "#005005" in colors

    def test_normalizes_3digit_hex(self, tmp_path):
        svg = (
            '<svg xmlns="http://www.w3.org/2000/svg" '
            'viewBox="0 0 100 100">'
            '<rect fill="#F0F"/></svg>'
        )
        path = tmp_path / "short.svg"
        path.write_text(svg)
        colors = extract_svg_colors(path)
        assert "#FF00FF" in colors

    def test_empty_svg_no_colors(self, tmp_path):
        svg = (
            '<svg xmlns="http://www.w3.org/2000/svg" '
            'viewBox="0 0 100 100"></svg>'
        )
        path = tmp_path / "empty.svg"
        path.write_text(svg)
        colors = extract_svg_colors(path)
        assert len(colors) == 0


class TestCheckSvgStructure:
    def test_valid_svg_no_issues(self, tmp_svg):
        issues = check_svg_structure(tmp_svg)
        assert issues == []

    def test_missing_viewbox(self, tmp_svg_no_viewbox):
        issues = check_svg_structure(tmp_svg_no_viewbox)
        assert any("viewBox" in i for i in issues)

    def test_embedded_raster(self, tmp_svg_with_raster):
        issues = check_svg_structure(tmp_svg_with_raster)
        assert any("raster" in i.lower() for i in issues)

    def test_invalid_xml(self, tmp_svg_invalid_xml):
        issues = check_svg_structure(tmp_svg_invalid_xml)
        assert any("XML" in i or "xml" in i for i in issues)


class TestCheckFileSize:
    def test_under_limit_passes(self, tmp_svg):
        assert check_file_size(tmp_svg, 102400) is None

    def test_over_limit_fails(self, tmp_svg):
        result = check_file_size(tmp_svg, 10)
        assert result is not None
        assert "exceeds" in result


class TestBuildPaletteLabs:
    def test_returns_nonempty(self, config):
        labs = build_palette_labs(config)
        assert len(labs) > 0

    def test_all_tuples_of_three(self, config):
        labs = build_palette_labs(config)
        for lab in labs:
            assert len(lab) == 3


class TestCheckColorAdherence:
    def test_on_palette_passes(self, config):
        palette_labs = build_palette_labs(config)
        on_palette = {"#2E7D32", "#4CAF50"}
        off = check_color_adherence(on_palette, palette_labs, 60)
        assert len(off) == 0

    def test_off_palette_detected(self, config):
        palette_labs = build_palette_labs(config)
        off_colors = {"#FF00FF"}  # Magenta, not in palette
        off = check_color_adherence(
            off_colors, palette_labs, 30
        )
        assert len(off) > 0


# ============================================================
# generate.py tests
# ============================================================

from generate import build_prompt


def _with_context(config, enabled):
    """Return a config copy with apply_category_context overridden."""
    return {
        **config,
        "style": {**config["style"], "apply_category_context": enabled},
    }


class TestBuildPrompt:
    def test_artprompt_leads_and_suffix_follows(self, config):
        entry = {
            "id": "fauna_01",
            "category": "fauna",
            "artPrompt": "honeybee on a flower",
        }
        prompt = build_prompt(config, entry)
        assert prompt.startswith("honeybee on a flower")
        assert "simple flat vector illustration" in prompt

    def test_category_context_omitted_by_default(self, config):
        # Real config sets apply_category_context: false.
        assert config["style"]["apply_category_context"] is False
        entry = {
            "id": "fauna_01",
            "category": "fauna",
            "artPrompt": "honeybee on a flower",
        }
        prompt = build_prompt(config, entry)
        assert "friendly animal character" not in prompt

    def test_category_context_appended_when_enabled(self, config):
        entry = {
            "id": "fauna_01",
            "category": "fauna",
            "artPrompt": "honeybee on a flower",
        }
        prompt = build_prompt(_with_context(config, True), entry)
        assert "friendly animal character" in prompt

    def test_context_defaults_on_when_flag_absent(self, config):
        cfg = {**config, "style": {**config["style"]}}
        del cfg["style"]["apply_category_context"]
        entry = {
            "id": "fauna_01",
            "category": "fauna",
            "artPrompt": "honeybee on a flower",
        }
        prompt = build_prompt(cfg, entry)
        assert "friendly animal character" in prompt

    def test_unknown_category_when_enabled(self, config):
        entry = {
            "id": "test_01",
            "category": "nonexistent",
            "artPrompt": "test subject",
        }
        prompt = build_prompt(_with_context(config, True), entry)
        assert prompt.startswith("test subject")
        assert "simple flat vector illustration" in prompt


# ============================================================
# optimize.py tests
# ============================================================

from optimize import fix_dark_mode_colors


class TestFixDarkModeColors:
    def test_removes_white_background_rect(self, tmp_svg_white_bg):
        changes = fix_dark_mode_colors(tmp_svg_white_bg)
        assert changes > 0
        content = tmp_svg_white_bg.read_text()
        # Background rect should be gone, but circle remains
        assert "circle" in content

    def test_replaces_white_fills(self, tmp_svg_white_bg):
        fix_dark_mode_colors(tmp_svg_white_bg)
        content = tmp_svg_white_bg.read_text()
        assert "#FAFAFA" in content

    def test_replaces_black_strokes(self, tmp_svg_white_bg):
        fix_dark_mode_colors(tmp_svg_white_bg)
        content = tmp_svg_white_bg.read_text()
        assert "#212121" in content
        assert "#000000" not in content

    def test_percent_background_removed(self, tmp_svg_percent_bg):
        changes = fix_dark_mode_colors(tmp_svg_percent_bg)
        assert changes > 0
        content = tmp_svg_percent_bg.read_text()
        assert "100%" not in content

    def test_no_changes_on_clean_svg(self, tmp_svg):
        changes = fix_dark_mode_colors(tmp_svg)
        assert changes == 0

    def test_invalid_xml_returns_zero(self, tmp_svg_invalid_xml):
        changes = fix_dark_mode_colors(tmp_svg_invalid_xml)
        assert changes == 0
