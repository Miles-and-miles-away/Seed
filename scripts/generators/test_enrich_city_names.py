#!/usr/bin/env python3
"""Self-check for the enrichment's accept/reject logic.

The floors in enrich_city_names.py only catch under-delivery: a run
that returns too few names aborts. Nothing catches the opposite, so
a loosened band or a dropped gate would ship wrong names and pass
every existing check. These asserts are that missing direction.

    python3 scripts/generators/test_enrich_city_names.py
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import enrich_city_names as e  # noqa: E402

KM_PER_DEG = 111.195


def city(pop, cc="JP", name="Testville"):
    return {"name": name, "cc": cc, "lat": 0.0, "lon": 0.0, "pop": pop}


def row(km, ja="テスト", cc=None, item="Q1"):
    binding = {
        "item": {"value": f"http://www.wikidata.org/entity/{item}"},
        "ja": {"value": ja},
        "coord": {"value": "Point(0 %.6f)" % (km / KM_PER_DEG)},
    }
    if cc is not None:
        binding["cc"] = {"value": cc}
    return binding


def stub(rows):
    e.sparql = lambda _query: rows


def alt(alt_id, name, preferred="", short="", colloquial="", historic=""):
    """An alternateNamesV2 row: id, geonameid, lang, name, 4 flags."""
    return [str(alt_id), "1", "ja", name,
            preferred, short, colloquial, historic]


def check_pick():
    # Colloquial and historic rows are excluded outright, even when
    # nothing else remains.
    assert e.pick([alt(1, "江戸", historic="1")], "ja") is None
    assert e.pick([alt(1, "花の都", colloquial="1")], "ja") is None
    assert e.pick([alt(1, "江戸", historic="1"),
                   alt(2, "東京")], "ja") == "東京"
    # Empty and whitespace-only names never ship.
    assert e.pick([], "ja") is None
    assert e.pick([alt(1, "  ")], "ja") is None
    assert e.pick([alt(1, " 東京 ")], "ja") == "東京"
    # Preferred beats everything except the exclusions and the JA
    # romaji demotion.
    assert e.pick([alt(1, "東京都"),
                   alt(2, "東京", preferred="1")], "ja") == "東京"
    # A full name beats a short form.
    assert e.pick([alt(1, "NY", short="1"),
                   alt(2, "ニューヨーク")], "ja") == "ニューヨーク"
    # Preferred outranks full-over-short.
    assert e.pick([alt(1, "ニューヨーク市"),
                   alt(2, "ニューヨーク", preferred="1", short="1")],
                  "ja") == "ニューヨーク"
    # Oldest id wins so reruns are stable regardless of input order.
    assert e.pick([alt(9, "後"), alt(3, "先")], "ja") == "先"
    assert e.pick([alt(3, "先"), alt(9, "後")], "ja") == "先"
    # JA demotes romaji rows GeoNames files as ja, even preferred
    # ones; ES must not, or every Latin-script name would sink.
    assert e.pick([alt(1, "Amusuterudamu", preferred="1"),
                   alt(2, "アムステルダム")], "ja") == "アムステルダム"
    assert e.pick([alt(1, "Amusuterudamu")], "ja") == "Amusuterudamu"
    es = [["1", "1", "es", "Nueva York", "1", "", "", ""],
          ["2", "1", "es", "ヌエバ", "", "", "", ""]]
    assert e.pick(es, "es") == "Nueva York"


def check_label_gates():
    assert e.gate_ja_label("サンパウロ (都市)", "Sao Paulo")[0] == "サンパウロ"
    assert e.gate_ja_label("(都市)", "X")[0] is None
    # Romaji and copied Latin names are the noise this rejects.
    assert e.gate_ja_label("Amusuterudamu", "Amsterdam")[0] is None
    assert e.gate_ja_label("Monaco", "Monaco")[0] is None
    assert e.gate_ja_label("東京", "Tokyo")[0] == "東京"


def check_bands():
    # 20 km is inside the large band and outside the small one. If
    # either constant drifts, exactly one of these flips.
    stub([row(20)])
    assert e.ja_label_by_name(city(500_000))[0] == "テスト"
    assert e.ja_label_by_name(city(50_000))[0] is None
    stub([row(30)])
    assert e.ja_label_by_name(city(500_000))[0] is None


def check_country_rule():
    # A dependent territory disagrees with P17 by construction, so
    # the check only bites past COUNTRY_CHECK_MIN_KM.
    stub([row(2, cc="CN")])
    assert e.ja_label_by_name(city(50_000, cc="MO"))[0] == "テスト"
    stub([row(8, cc="CN")])
    name, reason = e.ja_label_by_name(city(50_000, cc="MO"))
    assert name is None and "country CN is not MO" in reason
    # Large cities skip the check entirely at any distance.
    stub([row(8, cc="CN")])
    assert e.ja_label_by_name(city(500_000, cc="MO"))[0] == "テスト"


def check_nearest_wins_and_empty():
    stub([row(9, ja="遠い", item="Q9"), row(1, ja="近い", item="Q1")])
    assert e.ja_label_by_name(city(50_000))[0] == "近い"
    stub([])
    name, reason = e.ja_label_by_name(city(50_000))
    assert name is None and "no name match" in reason


def check_haversine():
    assert abs(e.haversine_km(0, 0, 0, 1) - KM_PER_DEG) < 0.5
    assert e.haversine_km(35.68, 139.69, 35.68, 139.69) == 0


if __name__ == "__main__":
    e.POLITE_PAUSE_S = 0
    for check in (check_pick, check_label_gates, check_bands,
                  check_country_rule, check_nearest_wins_and_empty,
                  check_haversine):
        check()
        print(f"ok {check.__name__}")
    print("all checks passed")
