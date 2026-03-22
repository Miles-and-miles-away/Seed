#!/usr/bin/env python3
"""Check all URLs found in a JSON file for broken links.

Usage:
    python scripts/check_urls.py data/app/sdg_resources.json
    python scripts/check_urls.py data/app/eco_facts.json -v
    python scripts/check_urls.py data/reference/un_world_days.json

Options:
    -v, --verbose   Show all URLs, not just failures
    --timeout N     Request timeout in seconds (default: 15)
"""

import argparse
import json
import re
import sys
import time
from pathlib import Path

import requests

URL_PATTERN = re.compile(r"https?://[^\s\"'\\]+")
REQUEST_DELAY = 0.5
DEFAULT_TIMEOUT = 15

USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/120.0.0.0 Safari/537.36"
)

HEADERS = {
    "User-Agent": USER_AGENT,
    "Accept": "text/html,application/xhtml+xml,"
    "application/xml;q=0.9,*/*;q=0.8",
}


def extract_urls(data, path="$"):
    """Recursively extract URLs from JSON data."""
    urls = []
    if isinstance(data, str):
        for match in URL_PATTERN.finditer(data):
            url = match.group().rstrip(".,;:)")
            urls.append((url, path))
    elif isinstance(data, dict):
        for key, value in data.items():
            urls.extend(
                extract_urls(value, f"{path}.{key}")
            )
    elif isinstance(data, list):
        for i, item in enumerate(data):
            urls.extend(
                extract_urls(item, f"{path}[{i}]")
            )
    return urls


def check_url(url, timeout):
    """Check a URL, trying HEAD first, then GET."""
    try:
        resp = requests.head(
            url,
            headers=HEADERS,
            timeout=timeout,
            allow_redirects=True,
        )
        if resp.status_code == 405:
            resp = requests.get(
                url,
                headers=HEADERS,
                timeout=timeout,
                allow_redirects=True,
            )
        return resp.status_code, None
    except requests.RequestException:
        pass

    try:
        resp = requests.get(
            url,
            headers=HEADERS,
            timeout=timeout,
            allow_redirects=True,
        )
        return resp.status_code, None
    except requests.Timeout:
        return None, "TIMEOUT"
    except requests.ConnectionError:
        return None, "CONNECTION_ERROR"
    except requests.RequestException as e:
        return None, str(e)[:60]


def classify_status(status_code):
    """Classify HTTP status into a category."""
    if status_code is None:
        return "ERROR"
    if 200 <= status_code < 300:
        return "OK"
    if 300 <= status_code < 400:
        return "REDIRECT"
    return "BROKEN"


def main():
    parser = argparse.ArgumentParser(
        description="Check URLs in a JSON file."
    )
    parser.add_argument(
        "file", type=Path, help="Path to JSON file"
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Show all URLs, not just failures",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=DEFAULT_TIMEOUT,
        help=f"Timeout in seconds (default: {DEFAULT_TIMEOUT})",
    )
    args = parser.parse_args()

    if not args.file.exists():
        print(f"File not found: {args.file}")
        sys.exit(2)

    with open(args.file, encoding="utf-8") as f:
        data = json.load(f)

    url_entries = extract_urls(data)
    seen = set()
    unique_entries = []
    for url, path in url_entries:
        if url not in seen:
            seen.add(url)
            unique_entries.append((url, path))

    total = len(unique_entries)
    if total == 0:
        print("No URLs found in file.")
        sys.exit(0)

    print(f"Found {total} unique URLs in {args.file}")
    print("-" * 60)

    results = {"OK": [], "REDIRECT": [], "BROKEN": [], "ERROR": []}

    for i, (url, path) in enumerate(unique_entries, 1):
        status_code, error = check_url(url, args.timeout)
        category = classify_status(status_code)
        if error:
            detail = error
        else:
            detail = str(status_code)

        results[category].append((url, path, detail))

        marker = "." if category == "OK" else "X"
        sys.stdout.write(marker)
        if i % 50 == 0 or i == total:
            sys.stdout.write(f" {i}/{total}\n")
        sys.stdout.flush()

        if i < total:
            time.sleep(REQUEST_DELAY)

    print()
    print("=" * 60)
    print("RESULTS")
    print("=" * 60)

    if args.verbose and results["OK"]:
        print(f"\n-- OK ({len(results['OK'])}) --")
        for url, path, detail in results["OK"]:
            print(f"  [{detail}] {url}")
            print(f"         at {path}")

    if results["REDIRECT"]:
        print(f"\n-- REDIRECT ({len(results['REDIRECT'])}) --")
        for url, path, detail in results["REDIRECT"]:
            print(f"  [{detail}] {url}")
            print(f"         at {path}")

    if results["BROKEN"]:
        print(f"\n-- BROKEN ({len(results['BROKEN'])}) --")
        for url, path, detail in results["BROKEN"]:
            print(f"  [{detail}] {url}")
            print(f"         at {path}")

    if results["ERROR"]:
        print(f"\n-- ERROR ({len(results['ERROR'])}) --")
        for url, path, detail in results["ERROR"]:
            print(f"  [{detail}] {url}")
            print(f"         at {path}")

    print()
    print("-" * 60)
    print("SUMMARY")
    print("-" * 60)
    print(f"  Total:    {total}")
    print(f"  OK:       {len(results['OK'])}")
    print(f"  Redirect: {len(results['REDIRECT'])}")
    print(f"  Broken:   {len(results['BROKEN'])}")
    print(f"  Error:    {len(results['ERROR'])}")

    has_broken = (
        len(results["BROKEN"]) > 0 or len(results["ERROR"]) > 0
    )
    sys.exit(1 if has_broken else 0)


if __name__ == "__main__":
    main()
