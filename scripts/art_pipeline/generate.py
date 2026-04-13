#!/usr/bin/env python3
"""Generate SVG assets via Recraft V4 Text-to-Vector API.

Usage:
    python generate.py --json eco_dex_entries.json
    python generate.py --json eco_dex_entries.json --ids flora_01 flora_02
    python generate.py --prompt "cute oak tree" --output test.svg
"""

import argparse
import base64
import json
import os
import sys
import time
from pathlib import Path

import requests
import yaml

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CONFIG_PATH = SCRIPT_DIR / "config.yaml"

MODEL = "recraftv4_vector"
WHITE_BG = {"rgb": [255, 255, 255]}


def load_config():
    with open(CONFIG_PATH) as f:
        return yaml.safe_load(f)


def get_api_token():
    token = os.environ.get("RECRAFT_API_TOKEN")
    if not token:
        print(
            "ERROR: Set RECRAFT_API_TOKEN env var.\n"
            "Get a token at https://www.recraft.ai/docs"
        )
        sys.exit(1)
    return token


def build_prompt(config, entry):
    """Build prompt: subject first, category, then style.

    Follows Recraft recommended order:
        {artPrompt}, {category suffix}, {style suffix}
    """
    category = entry.get("category", "")
    category_suffix = config["style"]["categories"].get(
        category, ""
    )
    style_suffix = config["style"]["suffix"]

    parts = [entry["artPrompt"]]
    if category_suffix:
        parts.append(category_suffix)
    parts.append(style_suffix)

    return ", ".join(parts)


def build_controls(config, entry):
    """Build Recraft controls object with colors and flags."""
    category = entry.get("category", "")
    colors_cfg = config.get("category_colors", {})
    rgb_list = colors_cfg.get(category, [])

    colors = [{"rgb": rgb} for rgb in rgb_list]

    return {
        "colors": colors,
        "background_color": WHITE_BG,
    }


MAX_RETRIES = 2
RETRY_BACKOFF = [2, 5]
RETRYABLE_STATUS_CODES = {429, 500, 502, 503, 504}


def generate_svgs(token, config, prompt, controls, n=1):
    """Call Recraft API with retry, return list of SVG strings.

    Uses the `n` parameter to request multiple candidates in a
    single API call (max 6). Returns a list of decoded SVGs.
    """
    url = config["recraft"]["api_url"]
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "response_format": config["recraft"]["response_format"],
        "size": config["recraft"]["size"],
        "controls": controls,
        "n": n,
    }

    for attempt in range(1 + MAX_RETRIES):
        try:
            resp = requests.post(
                url, headers=headers, json=payload, timeout=120
            )
            if (
                resp.status_code in RETRYABLE_STATUS_CODES
                and attempt < MAX_RETRIES
            ):
                wait = RETRY_BACKOFF[attempt]
                print(f"({resp.status_code}, retry in {wait}s)")
                time.sleep(wait)
                continue
            resp.raise_for_status()
            data = resp.json()

            results = []
            for image_data in data.get("data", []):
                if "url" in image_data:
                    svg_resp = requests.get(
                        image_data["url"], timeout=30
                    )
                    svg_resp.raise_for_status()
                    results.append(svg_resp.text)
                elif "b64_json" in image_data:
                    results.append(
                        base64.b64decode(
                            image_data["b64_json"]
                        ).decode("utf-8")
                    )

            if results:
                return results

            print(
                f"  Unexpected response: "
                f"{json.dumps(data)[:200]}"
            )
            return []

        except requests.exceptions.RequestException as e:
            body = ""
            if hasattr(e, "response") and e.response is not None:
                body = e.response.text[:300]
            if attempt < MAX_RETRIES:
                wait = RETRY_BACKOFF[attempt]
                print(f"({e}, retry in {wait}s)")
                time.sleep(wait)
                continue
            print(f"  API error: {e}")
            if body:
                print(f"  Response: {body}")
            return []

    return []


def generate_from_json(
    config, json_path, ids=None, dry_run=False
):
    """Generate SVGs for entries in a JSON file."""
    with open(json_path) as f:
        data = json.load(f)
    entries = data.get("entries", [])
    if ids:
        entries = [e for e in entries if e["id"] in ids]

    if not entries:
        print("No entries to generate.")
        return

    candidates_dir = (
        PROJECT_ROOT / config["output"]["candidates"]
    )

    n_candidates = config["recraft"]["candidates_per_asset"]
    total = len(entries) * n_candidates
    units = total * config["recraft"]["units_per_svg"]
    budget = config["recraft"]["monthly_unit_budget"]

    print(f"Model: {MODEL}")
    print(
        f"Generating {total} SVGs "
        f"({len(entries)} entries x {n_candidates} candidates)"
    )
    print(f"Units: {units}/{budget} monthly budget")
    print(f"Output: {candidates_dir}\n")

    if dry_run:
        for entry in entries:
            prompt = build_prompt(config, entry)
            controls = build_controls(config, entry)
            n_colors = len(controls.get("colors", []))
            print(
                f"  [{entry['id']}] ({n_colors} colors) "
                f"{prompt[:72]}..."
            )
        print(f"\nDry run -- no API calls made.")
        return

    token = get_api_token()
    candidates_dir.mkdir(parents=True, exist_ok=True)

    for entry in entries:
        entry_id = entry["id"]
        prompt = build_prompt(config, entry)
        controls = build_controls(config, entry)
        print(f"[{entry_id}] {entry['artPrompt'][:60]}")
        print(f"  Prompt: {prompt[:80]}...")

        entry_dir = candidates_dir / entry_id
        entry_dir.mkdir(parents=True, exist_ok=True)

        # Request all candidates in a single API call
        print(
            f"  Requesting {n_candidates} candidates...",
            end=" ",
        )
        svgs = generate_svgs(
            token, config, prompt, controls, n=n_candidates
        )

        for i, svg_content in enumerate(svgs):
            output_path = (
                entry_dir / f"candidate_{i + 1}.svg"
            )
            output_path.write_text(svg_content)
            size_kb = output_path.stat().st_size / 1024
            print(f"#{i + 1}({size_kb:.1f}KB)", end=" ")

        if svgs:
            print(f"OK ({len(svgs)}/{n_candidates})")
        else:
            print("FAILED")

        # Brief pause between entries
        time.sleep(0.5)

    print(f"\nDone! Candidates saved to {candidates_dir}")


def generate_single(config, prompt, output_path):
    """Generate a single SVG from a prompt (for testing)."""
    token = get_api_token()
    print(f"Model: {MODEL}")
    print(f"Prompt: {prompt}")
    print(f"Output: {output_path}")

    controls = {
        "background_color": WHITE_BG,
    }

    svgs = generate_svgs(token, config, prompt, controls, n=1)
    if svgs:
        Path(output_path).write_text(svgs[0])
        size_kb = Path(output_path).stat().st_size / 1024
        print(f"OK ({size_kb:.1f}KB)")
    else:
        print("FAILED")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Generate SVG assets via Recraft API"
    )
    parser.add_argument(
        "--json",
        help="JSON file with entries to generate",
    )
    parser.add_argument(
        "--ids",
        nargs="+",
        help="Only generate specific entry IDs from manifest",
    )
    parser.add_argument(
        "--prompt",
        help="Single prompt for testing",
    )
    parser.add_argument(
        "--output",
        help="Output path for single prompt mode",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be generated without calling API",
    )
    args = parser.parse_args()

    config = load_config()

    if args.prompt:
        if args.dry_run:
            print(f"Dry run -- prompt: {args.prompt}")
            return
        output = args.output or "test_output.svg"
        generate_single(config, args.prompt, output)
    elif args.json:
        generate_from_json(
            config, args.json, args.ids, args.dry_run
        )
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
