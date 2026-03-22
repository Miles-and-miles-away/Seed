"""One-time script to convert eco_dex_entries_data.dart to JSON."""

import json
import re
import sys

DART_FILE = (
    "lib/features/eco_dex/data/eco_dex_entries_data.dart"
)
OUTPUT_FILE = "data/app/eco_dex_entries.json"

CATEGORIES = [
    {
        "id": "climate",
        "nameEn": "Climate",
        "nameJa": "気候",
        "nameEs": "Clima",
    },
    {
        "id": "oceans",
        "nameEn": "Oceans",
        "nameJa": "海洋",
        "nameEs": "Oceanos",
    },
    {
        "id": "food_systems",
        "nameEn": "Food Systems",
        "nameJa": "食料システム",
        "nameEs": "Sistemas Alimentarios",
    },
    {
        "id": "biodiversity",
        "nameEn": "Biodiversity",
        "nameJa": "生物多様性",
        "nameEs": "Biodiversidad",
    },
    {
        "id": "energy",
        "nameEn": "Energy",
        "nameJa": "エネルギー",
        "nameEs": "Energia",
    },
    {
        "id": "circular_economy",
        "nameEn": "Circular Economy",
        "nameJa": "サーキュラーエコノミー",
        "nameEs": "Economia Circular",
    },
    {
        "id": "people_planet",
        "nameEn": "People & Planet",
        "nameJa": "人と地球",
        "nameEs": "Personas y Planeta",
    },
    {
        "id": "your_journey",
        "nameEn": "Your Journey",
        "nameJa": "あなたの旅",
        "nameEs": "Tu Viaje",
    },
]

# Map Dart factory name -> JSON type string
CONDITION_MAP = {
    "totalActions": "totalActions",
    "co2Saved": "co2Saved",
    "categoryActions": "categoryActions",
    "streakDays": "streakDays",
    "levelReached": "levelReached",
    "sdgBreadth": "sdgBreadth",
    "challengeStreak": "challengeStreak",
    "multiDayChallenge": "multiDayChallenge",
    "ecoFactsViewed": "ecoFactsViewed",
}


def parse_condition(text: str) -> dict:
    """Parse e.g. EcoDexCondition.totalActions(count: 5)."""
    m = re.match(
        r"EcoDexCondition\.(\w+)\((.*?)\)",
        text.strip(),
        re.DOTALL,
    )
    if not m:
        raise ValueError(f"Cannot parse condition: {text}")
    factory = m.group(1)
    args_str = m.group(2)
    result = {"type": CONDITION_MAP[factory]}
    for arg_match in re.finditer(
        r"(\w+):\s*(?:'([^']*)'|(\d+))", args_str
    ):
        key = arg_match.group(1)
        if arg_match.group(2) is not None:
            result[key] = arg_match.group(2)
        else:
            result[key] = int(arg_match.group(3))
    return result


def join_dart_strings(raw: str) -> str:
    """Join Dart adjacent string literals (mixed quotes)."""
    # Match both single and double quoted strings
    parts = re.findall(r"""'([^']*)'|"([^"]*)" """.strip(), raw)
    if parts:
        return "".join(p[0] or p[1] for p in parts)
    return raw.strip("'\"")


def extract_field(entry_text: str, field: str) -> str:
    """Extract a named field value from an entry block."""
    # Find field: then collect all adjacent string literals
    pattern = (
        rf"{field}:\s*\n?\s*"
        r"((?:(?:'[^']*'|\"[^\"]*\")\s*\n?\s*)+)"
    )
    m = re.search(pattern, entry_text)
    if not m:
        return ""
    return join_dart_strings(m.group(1))


def extract_condition(entry_text: str) -> dict:
    """Extract condition block from entry text."""
    # Multi-line condition
    m = re.search(
        r"condition:\s*(EcoDexCondition\.\w+\([^)]*\))",
        entry_text,
        re.DOTALL,
    )
    if m:
        return parse_condition(m.group(1))
    raise ValueError(
        f"Cannot find condition in entry: {entry_text[:100]}"
    )


def parse_entries(dart_source: str) -> list:
    """Parse all EcoDexEntry blocks from the Dart source."""
    entries = []
    # Split on EcoDexEntry( constructors
    blocks = re.split(r"\bEcoDexEntry\(", dart_source)
    for block in blocks[1:]:  # skip preamble
        # Find matching closing paren
        depth = 1
        end = 0
        for i, ch in enumerate(block):
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    end = i
                    break
        entry_text = block[:end]

        entry = {
            "id": extract_field(entry_text, "id"),
            "category": extract_field(entry_text, "category"),
            "nameEn": extract_field(entry_text, "nameEn"),
            "nameJa": extract_field(entry_text, "nameJa"),
            "nameEs": extract_field(entry_text, "nameEs"),
            "factEn": extract_field(entry_text, "factEn"),
            "factJa": extract_field(entry_text, "factJa"),
            "factEs": extract_field(entry_text, "factEs"),
            "sourceUrl": extract_field(
                entry_text, "sourceUrl"
            ),
            "iconName": extract_field(
                entry_text, "iconName"
            ),
            "condition": extract_condition(entry_text),
            "hintEn": extract_field(entry_text, "hintEn"),
            "hintJa": extract_field(entry_text, "hintJa"),
            "hintEs": extract_field(entry_text, "hintEs"),
        }
        entries.append(entry)
    return entries


def main():
    with open(DART_FILE) as f:
        dart_source = f.read()

    entries = parse_entries(dart_source)
    print(f"Parsed {len(entries)} entries")

    # Validate category distribution
    cat_counts = {}
    for e in entries:
        cat = e["category"]
        cat_counts[cat] = cat_counts.get(cat, 0) + 1
    for cat_id, count in cat_counts.items():
        print(f"  {cat_id}: {count} entries")

    if len(entries) != 60:
        print(
            f"ERROR: Expected 60 entries, got "
            f"{len(entries)}",
            file=sys.stderr,
        )
        sys.exit(1)

    output = {
        "categories": CATEGORIES,
        "entries": entries,
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(
            output, f, ensure_ascii=False, indent=2
        )
        f.write("\n")

    print(f"Wrote {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
