#!/usr/bin/env python3
"""Generate SVG assets via Recraft V4 Text-to-Vector API.

Usage:
    python generate.py --manifest eco_dex_manifest.yaml
    python generate.py --manifest eco_dex_manifest.yaml --ids flora_01 flora_02
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
    """Build full prompt from style config + entry metadata."""
    prefix = config["style"]["prefix"]
    category = entry.get("category", "")
    category_suffix = config["style"]["categories"].get(
        category, ""
    )
    subject = entry["subject"]
    color_hint = entry.get("color_hint", "")

    parts = [prefix]
    if category_suffix:
        parts.append(category_suffix)
    parts.append(subject)
    if color_hint:
        parts.append(color_hint)

    return ", ".join(parts)


MAX_RETRIES = 2
RETRY_BACKOFF = [2, 5]
RETRYABLE_STATUS_CODES = {429, 500, 502, 503, 504}


def generate_svg(token, config, prompt):
    """Call Recraft API with retry, return SVG string or None."""
    url = config["recraft"]["api_url"]
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }
    payload = {
        "prompt": prompt,
        "response_format": config["recraft"]["response_format"],
        "size": config["recraft"]["size"],
        "style": "vector_illustration",
        "substyle": "flat_2",
    }

    for attempt in range(1 + MAX_RETRIES):
        try:
            resp = requests.post(
                url, headers=headers, json=payload, timeout=60
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

            if "data" in data and len(data["data"]) > 0:
                image_data = data["data"][0]
                if "url" in image_data:
                    svg_resp = requests.get(
                        image_data["url"], timeout=30
                    )
                    svg_resp.raise_for_status()
                    return svg_resp.text
                elif "b64_json" in image_data:
                    return base64.b64decode(
                        image_data["b64_json"]
                    ).decode("utf-8")

            print(
                f"  Unexpected response: "
                f"{json.dumps(data)[:200]}"
            )
            return None

        except requests.exceptions.RequestException as e:
            if attempt < MAX_RETRIES:
                wait = RETRY_BACKOFF[attempt]
                print(f"({e}, retry in {wait}s)")
                time.sleep(wait)
                continue
            print(f"  API error: {e}")
            return None

    return None


def generate_from_manifest(
    config, manifest_path, ids=None, dry_run=False
):
    """Generate SVGs for entries in a manifest file."""
    with open(manifest_path) as f:
        manifest = yaml.safe_load(f)

    entries = manifest.get("entries", [])
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
    tokens = total * config["recraft"]["tokens_per_svg"]
    budget = config["recraft"]["monthly_token_budget"]

    print(
        f"Generating {total} SVGs "
        f"({len(entries)} entries x {n_candidates} candidates)"
    )
    print(f"Tokens: {tokens}/{budget} monthly budget")
    print(f"Output: {candidates_dir}\n")

    if dry_run:
        for entry in entries:
            prompt = build_prompt(config, entry)
            print(f"  [{entry['id']}] {prompt[:72]}...")
        print(f"\nDry run -- no API calls made.")
        return

    token = get_api_token()
    candidates_dir.mkdir(parents=True, exist_ok=True)

    for entry in entries:
        entry_id = entry["id"]
        prompt = build_prompt(config, entry)
        print(f"[{entry_id}] {entry['subject']}")
        print(f"  Prompt: {prompt[:80]}...")

        entry_dir = candidates_dir / entry_id
        entry_dir.mkdir(parents=True, exist_ok=True)

        for i in range(n_candidates):
            output_path = entry_dir / f"candidate_{i + 1}.svg"
            print(f"  Candidate {i + 1}/{n_candidates}...", end=" ")

            svg_content = generate_svg(token, config, prompt)
            if svg_content:
                output_path.write_text(svg_content)
                size_kb = output_path.stat().st_size / 1024
                print(f"OK ({size_kb:.1f}KB)")
            else:
                print("FAILED")

            # Rate limiting
            if i < n_candidates - 1:
                time.sleep(1)

        # Brief pause between entries
        time.sleep(0.5)

    print(f"\nDone! Candidates saved to {candidates_dir}")


def generate_single(config, prompt, output_path):
    """Generate a single SVG from a prompt (for testing)."""
    token = get_api_token()
    print(f"Prompt: {prompt}")
    print(f"Output: {output_path}")

    svg_content = generate_svg(token, config, prompt)
    if svg_content:
        Path(output_path).write_text(svg_content)
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
        "--manifest",
        help="YAML manifest file with entries to generate",
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
    elif args.manifest:
        generate_from_manifest(
            config, args.manifest, args.ids, args.dry_run
        )
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
