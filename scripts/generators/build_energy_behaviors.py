"""Generates data/app/energy_behaviors.json from RESEARCH_ENERGY.md sections 3-5.

Every kwh_per_unit is the value in that document's section 4 table and every
preset quantity is from its section 5 table. Source name, url and quote are
transcribed from its sections 1 and 3.

The one access date applied to every citation (ACC) is the date
RESEARCH_ENERGY.md states for all of its sections 1 and 3 sources. That makes
it correct only for citations that genuinely come from those sections, which
is a trap this file fell into once: an earlier draft borrowed two lighting
citations from data/seed/co2_actions_database.json and the blanket ACC
re-stamped them, asserting a live verification that never happened. If you
add a source, it must come from the research doc, or it needs its own real
access date. Entries with no citable primary ship sources=[] and say so in
their calculation_notes -- that is the honest state, not a gap to paper over.

Run from anywhere:  python3 scripts/generators/build_energy_behaviors.py
"""
import collections
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
PATH = REPO_ROOT / 'data' / 'app' / 'energy_behaviors.json'

EXPECTED_BEHAVIORS = 32

ACC = '2026-08-02'


def S(n, u, q, accessed=ACC):
    return {'name': n, 'url': u, 'quote': q, 'accessed': accessed}


EPA = S(
    'US EPA WaterSense (showerheads)',
    'https://www.epa.gov/watersense/showerheads',
    'Did you know that standard showerheads use 2.5 gallons of water per '
    'minute (gpm)? Water-saving showerheads that earn the WaterSense label '
    'must demonstrate that they use no more than 2.0 gpm.')
TOTO = S(
    'TOTO CSR (shower water use)',
    'https://jp.toto.com/company/csr/csractivity/usefulinformation/'
    'use_shower/',
    '現在、TOTOが販売しているコンフォートウェーブシャワーの水量は1分間に6.5Ｌです')
SAP = S(
    'UK SAP 10.1 Appendix J and Table J1',
    'https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf',
    'Table J1: Cold water temperatures (°C)')
BRE = S(
    'BRE Technical Paper STP09/B07 (GASTEC-at-CRE tests for DECC)',
    'https://bregroup.com/documents/d/bre-group/stp09-b07_dhw_boiler_tests_2009',
    'ηDHW = heat content of the useful hot water drawn / heat in fuel '
    'consumption (net basis)')
HPTCJ = S(
    'Heat Pump & Thermal Storage Technology Center of Japan',
    'https://www.hptcj.or.jp/e/learning/tabid/370/Default.aspx',
    'Eco Cute has improved its efficiency to COP = 5.1 in the recent model')
SUIDO = S(
    '東京都水道局',
    'https://www.waterworks.metro.tokyo.lg.jp/kurashi/shiyou/jouzu',
    '残り湯は、使用状態によって異なりますが、一般家庭では、約180リットルの量があります')
_WHICH_U = (
    'https://www.which.co.uk/news/article/which-research-reveals-how-little-'
    'water-dishwashers-use-compared-to-hand-washing-aUDng9Y2iK8E'
)
WHICH_DW = S(
    'Which? UK (dishwasher main wash, 03 Jul 2026)',
    _WHICH_U,
    'around 1.12kWh of energy per wash, which costs roughly 29.2p')
_WM_N = 'Bosch WNA14400GR, 9 kg, EN50229 programme table'
_WM_U = 'https://media3.bosch-home.com/Documents/9001533128_A.pdf'
# One row per entry. A single shared quote made the 20 C and 40 C entries
# cite a table row reading 1,700 kWh (red-team finding, 2026-08-29).
BOSCH_WM_20 = S(
    _WM_N, _WM_U, 'Βαμβακερά (Cottons) 20 °C | 9,0 | 0,350 | 89,0 | 3:02')
BOSCH_WM_40 = S(
    _WM_N, _WM_U, 'Βαμβακερά (Cottons) 40 °C | 9,0 | 1,300 | 89,0 | 3:48')
BOSCH_WM_60 = S(
    _WM_N, _WM_U, 'Βαμβακερά (Cottons) 60 °C | 9,0 | 1,700 | 89,0 | 3:03')
BOSCH_DRY_C = S(
    'Bosch WTM8327SZA condenser dryer, 8 kg',
    'https://media3.bosch-home.com/Documents/specsheet/en-ZA/WTM8327SZA.pdf',
    'energy consumption of the standard cotton programme at full load '
    '4.63 kWh and energy consumption of the standard cotton programme '
    'at half load 2.61 kWh')
BOSCH_DRY_HP = S(
    'Bosch WQG24509GB heat-pump dryer, 9 kg',
    'https://media3.bosch-home.com/Documents/specsheet/en-GB/WQG24509GB.pdf',
    'Energy consumption electric dryer, full load - NEW (2010/30/EC): '
    '2.05 kWh')
BOSCH_DW = S(
    'Bosch SMS67MW00G dishwasher, 14 place settings',
    'https://media3.bosch-home.com/Documents/specsheet/en-GB/SMS67MW00G.pdf',
    'Energy Consumption for 100 cycles Eco Programme: 85 kWh')
_METI_AC_N = '資源エネルギー庁 省エネポータルサイト (空調)'
_METI_AC_U = (
    'https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/'
    'howto/airconditioning/index.html'
)
METI_AC_COOL = S(
    _METI_AC_N, _METI_AC_U,
    '冷房を1日1時間短縮した場合（設定温度：28℃）年間で電気18.78kWhの省エネ')
METI_AC_HEAT = S(
    _METI_AC_N, _METI_AC_U,
    '暖房を1日1時間短縮した場合（設定温度：20℃）年間で電気40.73kWhの省エネ')
PANA_FAN = S(
    'Panasonic F-CV339 仕様',
    'https://panasonic.jp/fan/products/F-CV339/spec.html',
    '消費電力 [ノッチ 8(強)] 50/60Hz:22W',
    accessed='2026-08-30')
OCWR = S(
    'Office of Congressional Workplace Rights (US)',
    'https://www.ocwr.gov/publications/fast-facts/portable-space-heaters/',
    'Average electric space heaters range from 400-1,500 watts.')
METRO = S(
    'メトロ電気工業 (kotatsu 標準平均消費電力量 test method)',
    'https://www.kotatsu.metro-co.com/our-kotatsu/',
    'こたつ：電気代及び標準平均消費電力量は、室温20℃で厚さ約５cmの綿のふとんを使用し、'
    '人が入らない状態で５時間運転した時の１時間あたりの平均値です。')
ENECHANGE = S(
    'enechange (Yamazen electric blanket per-setting measurements)',
    'https://enechange.jp/articles/cost-electric-blanket',
    '強（約53度）約35Wh、適温（約33度）約22Wh、弱（約21度）約13Wh')
KETTLE = S(
    'Murray, Liao, Stankovic & Stankovic (Strathclyde), EEDAL 2015',
    'https://strathprints.strath.ac.uk/55059/1/Murray_etal_EEDAL2015_How_'
    'make_efficient_use_kettles_understanding_usage_patterns.pdf',
    'most kettles are around 80-90% efficient (efficiency is decreased due to '
    'heat dissipation and transference to the body of the kettle)')
_FRONTIER_N = (
    'Frontier Energy, Residential Cooktop Performance and Energy '
    'Comparison Study, Report #501318071-R0 (July 2019)'
)
_FRONTIER_U = (
    'https://cao-94612.s3.amazonaws.com/documents/'
    'Induction-Range-Final-Report-July-2019.pdf'
)
FRONTIER_IH = S(
    _FRONTIER_N, _FRONTIER_U,
    'Three induction cooktops measured 85.20%, 86.10%, 83.00%')
FRONTIER_GAS = S(
    _FRONTIER_N, _FRONTIER_U,
    'The efficiency of the gas burner for the 12 pounds of water '
    'heat-up test was just 32%')
# Re-fetched and read 2026-08-29 to settle the regulation number, so it
# carries that date rather than the research pass's.
EU_OVEN = S(
    'Commission Regulation (EU) No 66/2014, Annex II '
    '(ecodesign requirements for domestic ovens, hobs and range hoods)',
    'https://webgate.ec.europa.eu/reqs2/public/v2/requirement/auxi/eu/'
    '32014R0066_energcook_annex_2.pdf',
    'SECelectric cavity = 0,0042 × V + 0,55 (in kWh)',
    '2026-08-29')
RICE = S(
    '一般財団法人 家電製品協会 (省エネルギーセンター実測値)',
    'https://seihinjyoho.go.jp/frontguide/pdf/'
    'guide_rice_cooker_2022.pdf?update=22113',
    '炊飯ジャー：IH5.5合以上8合未満平均消費電力量（炊飯時158Wh/回 保温時16.5Wh/h）')
# The two lighting entries ship NO citation. An earlier draft borrowed a
# US DOE Energy Saver and an Energy Use Calculator citation from
# data/seed/co2_actions_database.json (accessed 2026-01-31) and
# re-stamped both 2026-08-02, asserting a verification that never
# happened. Neither supports 8.5 W at 800 lm -- one states 10 W, which
# would drive a 17.6% "correction" -- and neither appears anywhere in the
# energy evidence base. Removed 2026-08-29 (red-team finding).
IFIXIT = S(
    'iFixit iPhone 15 battery',
    'https://www.ifixit.com/products/iphone-15-battery',
    '12.98 Wh')
METI_TV = S(
    '資源エネルギー庁 省エネポータルサイト (娯楽)',
    'https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/'
    'howto/entertainment/index.html',
    '1日1時間テレビ（50V型）を見る時間を減らした場合 年間で電気28.87kWhの省エネ')
# The two dashes below are U+2013 because LBNL writes them that way; a
# quote that is not character-for-character the source is not a quote.
LBNL = S(
    'Lawrence Berkeley National Laboratory, Standby Power',
    'https://standby.lbl.gov/',
    'Most products draw relatively little standby power – less than 0.5 watts '
    '– but they still add up.')

def P(pid, en, ja, es, units):
    return {'id': pid, 'name_en': en, 'name_ja': ja, 'name_es': es, 'units': units}

SHOWER_PRESETS = [
    P('quick_5min', 'A quick shower (5 min)', 'さっとシャワー（5分）',
      'Ducha rápida (5 min)', 5),
    P('typical_10min', 'A typical shower (10 min)', 'ふつうのシャワー（10分）',
      'Ducha normal (10 min)', 10),
    P('long_20min', 'A long shower (20 min)', '長めのシャワー（20分）',
      'Ducha larga (20 min)', 20),
]
BATH_PRESETS = [
    P('full_180l', 'A full bath (~180 L)', 'ふつうの湯量（約180L）',
      'Baño normal (~180 L)', 1.0),
    P('shallow_150l', 'A shallow bath (~150 L)', '浅めの湯量（約150L）',
      'Baño poco profundo (~150 L)', 0.83),
]
ONE_LOAD = [P('one_load', '1 load', '1回', '1 carga', 1)]
ONE_CYCLE_DW = [P('one_cycle', '1 cycle (14 place settings)', '1回（食器14人分）',
                  '1 ciclo (14 servicios)', 1)]
BOIL_PRESETS = [
    P('one_litre', '1 litre', '1リットル', '1 litro', 1),
    P('one_mug', 'A mug (0.3 L)', 'マグカップ1杯（0.3L）', 'Una taza (0,3 L)', 0.3),
]
EVENING_4H = [P('evening_4h', 'An evening (4 h)', '夜に4時間', 'Una tarde (4 h)', 4)]
ONE_HOUR = [P('one_hour', '1 hour', '1時間', '1 hora', 1)]
EVENING_3H = P('evening_3h', 'An evening (3 h)', '夜に3時間', 'Una tarde (3 h)', 3)
EVENING_5H = P('evening_5h', 'An evening (5 h)', '夜に5時間', 'Una tarde (5 h)', 5)

BEHAVIORS = [
 # ---- hot_water ----
 dict(id='shower_electric', group='hot_water', carrier='electricity', unit='minute',
      kwh=0.248111, en='Shower (electric hot water)', ja='シャワー（電気給湯）',
      es='Ducha (agua caliente eléctrica)', conf='medium_high', presets=SHOWER_PRESETS,
      sources=[EPA, TOTO, SAP],
      notes='7.844784 L/min (mean of three current showerheads, decision E4) x '
            '0.03162756 kWh/L (heating 1 L by 27.2 K: delivered 40 C from a 12.8 C '
            'annual-mean mains inlet, SAP 10.1) = 0.248111 kWh/min thermal, shipped '
            'directly because resistance electric water heating is ~100% efficient. '
            'RESEARCH_ENERGY section 3.1.'),
 dict(id='shower_heatpump', group='hot_water', carrier='electricity', unit='minute',
      kwh=0.057700, en='Shower (heat-pump hot water)', ja='シャワー（ヒートポンプ給湯）',
      es='Ducha (agua caliente con bomba de calor)', conf='medium', presets=SHOWER_PRESETS,
      sources=[EPA, TOTO, SAP, HPTCJ],
      notes='The 0.248111 kWh/min thermal load divided by a heat-pump COP of 4.3, the '
            'mean of the 3.5 initial and 5.1 recent Eco Cute models. Ships as its own '
            'entry rather than averaged with resistance (decision E3): they are two '
            'appliances, and an Eco Cute owner knows they own one. '
            'RESEARCH_ENERGY section 3.1.'),
 dict(id='shower_gas', group='hot_water', carrier='gas', unit='minute',
      kwh=0.328036, en='Shower (gas hot water)', ja='シャワー（ガス給湯）',
      es='Ducha (agua caliente de gas)', conf='medium_high', presets=SHOWER_PRESETS,
      sources=[EPA, TOTO, SAP, BRE],
      notes='The 0.248111 kWh/min thermal load divided by a gas hot-water efficiency '
            'of 0.756353. That efficiency is BRE STP09/B07 test A (instantaneous '
            'condensing combi, keep-hot off) at 83.8% net, restated on the Gross CV '
            'basis the gas factor uses: 0.838 x (0.18231 / 0.20199). Pairing a net-CV '
            'efficiency with a gross-CV factor understated gas by 12.6%. '
            'RESEARCH_ENERGY section 3.1.'),
 dict(id='bath_electric', group='hot_water', carrier='electricity', unit='use',
      kwh=5.692960, en='Bath (electric hot water)', ja='入浴（電気給湯）',
      es='Baño (agua caliente eléctrica)', conf='high', presets=BATH_PRESETS,
      sources=[SUIDO, SAP],
      notes='180 L x 0.03162756 kWh/L = 5.692960 kWh. The largest electric '
            'single-use figure in the dataset; bath_gas is larger still. '
            'RESEARCH_ENERGY section 3.1.'),
 dict(id='bath_gas', group='hot_water', carrier='gas', unit='use',
      kwh=7.526854, en='Bath (gas hot water)', ja='入浴（ガス給湯）',
      es='Baño (agua caliente de gas)', conf='medium_high', presets=BATH_PRESETS,
      sources=[SUIDO, SAP, BRE],
      notes='5.692960 kWh thermal / 0.756353 gross-CV gas hot-water efficiency. '
            'RESEARCH_ENERGY section 3.1.'),
 # ---- dishes ----
 dict(id='dishwasher_eco', group='dishes', carrier='electricity', unit='use',
      kwh=0.85, en='Dishwasher, eco programme', ja='食洗機（エコ）',
      es='Lavavajillas, programa eco', conf='high', presets=ONE_CYCLE_DW,
      sources=[BOSCH_DW],
      notes='85 kWh per 100 eco cycles = 0.85 kWh/cycle, 14 place settings. Eco is '
            '~24% below the normal programme and takes 3h15, so both ship as a real '
            'behaviour choice. RESEARCH_ENERGY section 3.2.'),
 dict(id='dishwasher_normal', group='dishes', carrier='electricity', unit='use',
      kwh=1.12, en='Dishwasher, normal programme', ja='食洗機（標準）',
      es='Lavavajillas, programa normal', conf='high', presets=ONE_CYCLE_DW,
      sources=[WHICH_DW],
      notes='Which? 2026 on the main wash, same 14-place-setting basis as the eco '
            'figure. RESEARCH_ENERGY section 3.2.'),
 # ---- laundry_wash ----
 dict(id='wash_cold', group='laundry_wash', carrier='electricity', unit='use',
      kwh=0.350, en='Washing machine, cold (20 C)', ja='洗濯機（20℃）',
      es='Lavado en frío (20 °C)', conf='high', presets=ONE_LOAD,
      sources=[BOSCH_WM_20],
      notes='Bosch WNA14400GR Cottons 20 C at 9.0 kg, EN50229. Three temperatures from '
            'one machine, one standard and one document (decision E6). '
            'RESEARCH_ENERGY section 3.2.'),
 dict(id='wash_warm', group='laundry_wash', carrier='electricity', unit='use',
      kwh=1.300, en='Washing machine, warm (40 C)', ja='洗濯機（40℃）',
      es='Lavado en templado (40 °C)', conf='high', presets=ONE_LOAD,
      sources=[BOSCH_WM_40],
      notes='Bosch WNA14400GR Cottons 40 C at 9.0 kg, EN50229. '
            'RESEARCH_ENERGY section 3.2.'),
 dict(id='wash_hot', group='laundry_wash', carrier='electricity', unit='use',
      kwh=1.700, en='Washing machine, hot (60 C)', ja='洗濯機（60℃）',
      es='Lavado en caliente (60 °C)', conf='medium', presets=ONE_LOAD,
      sources=[BOSCH_WM_60],
      notes='Bosch WNA14400GR Cottons 60 C at 9.0 kg, EN50229. This is a user-selected '
            '60 C programme; the EU-label "Cottons colour 60 C" programme uses '
            '0.900 kWh and does not actually reach 60 C, so a mandated sublabel '
            'saying "about half that" is 0.9/1.7. A "60 C" wash is 0.90-1.70 kWh '
            'depending on which 60 C the machine means. Confidence deviates from '
            'section 4 on purpose: that table says High, while section 3.2 splits it '
            'as High (provenance) / Medium (representativeness), and a user meets the '
            'representativeness half. RESEARCH_ENERGY section 3.2.'),
 # ---- laundry_dry ----
 dict(id='dryer_vented', group='laundry_dry', carrier='electricity', unit='use',
      kwh=4.5, en='Tumble dryer (conventional)', ja='乾燥機（ヒーター式）',
      es='Secadora (por resistencia)', conf='high', presets=ONE_LOAD,
      sources=[BOSCH_DRY_C],
      notes='Rounded down from the verified 4.63 kWh full load, because that is one '
            'energy-class-B model and independent figures on a stated 7 kg basis give '
            '3.5-4.5. RESEARCH_ENERGY section 3.2.'),
 dict(id='dryer_heatpump', group='laundry_dry', carrier='electricity', unit='use',
      kwh=2.05, en='Tumble dryer (heat pump)', ja='乾燥機（ヒートポンプ式）',
      es='Secadora (bomba de calor)', conf='high', presets=ONE_LOAD,
      sources=[BOSCH_DRY_HP],
      notes='Ships the verified figure exactly. Dryer type is a picker choice, not a '
            'footnote: the two differ by 2.2x. RESEARCH_ENERGY section 3.2.'),
 dict(id='line_dry', group='laundry_dry', carrier='none', unit='use',
      kwh=0, en='Line drying', ja='自然乾燥', es='Secado al aire',
      conf='high', presets=ONE_LOAD, sources=[],
      notes='Zero by definition, and the only entry with carrier "none". Caveat that '
            'must ship with it: outdoors or on a rack is free, but running a '
            'dehumidifier to dry indoors is not, and typically adds 1-4 kWh at '
            '300-700 W. RESEARCH_ENERGY section 3.2.'),
 # ---- space_heat / space_cool ----
 dict(id='aircon_heating', group='space_heat', carrier='electricity', unit='hour',
      kwh=0.241006, en='Air conditioner, heating (20 C)', ja='エアコン暖房（20℃）',
      es='Aire acondicionado, calefacción (20 °C)', conf='high',
      presets=[P('hour_20c', '1 hour at 20 C', '20℃で1時間', '1 hora a 20 °C', 1.0),
               P('hour_21c', '1 hour at 21 C', '21℃で1時間', '1 hora a 21 °C', 1.14480),
               P('hour_22c', '1 hour at 22 C', '22℃で1時間', '1 hora a 22 °C', 1.28960)],
      sources=[METI_AC_HEAT],
      notes='METI publishes 40.73 kWh/year saved by shortening heating one hour a day '
            'at a 20 C setpoint, sourced to 省エネルギーセンター実測値; over the 169-day '
            '暖房期間 that is 0.241006 kWh/h. MEASURED, not rated: the Panasonic '
            'CS-227VB JIS rating is 455 W, about 1.9x higher, because it is '
            'measured at full load. Do not "correct" this to the catalog '
            'figure. Setpoint presets use METI absolute deltas (+0.034898 '
            'kWh/h per 1 C) and are capped at +2 C '
            'because neither source supports extrapolating further. '
            'RESEARCH_ENERGY section 3.3.'),
 dict(id='portable_electric_heater', group='space_heat',
      carrier='electricity', unit='hour',
      kwh=1.2, en='Portable electric heater', ja='電気ストーブ／セラミックファンヒーター',
      es='Calefactor eléctrico portátil', conf='medium', presets=EVENING_4H,
      sources=[OCWR],
      notes='JP ceramic fan heaters run 600-1200 W in three steps; ships the high '
            'setting. A plug-in electric resistance heater specifically, never a '
            'gas-fed radiator: "space heater" is banned as a term because in British '
            'English it reads as the whole category of space heating. Nameplate on '
            'high, so thermostatic cycling reduces the true average once the room is '
            'warm. RESEARCH_ENERGY section 3.3.'),
 dict(id='kotatsu', group='space_heat', carrier='electricity', unit='hour',
      kwh=0.15, en='Kotatsu (heated table)', ja='こたつ',
      es='Kotatsu (mesa con calefactor)',
      conf='medium_high', presets=EVENING_4H, sources=[METRO],
      notes='The makers publish 標準（平均）消費電力量 in Wh, an already thermostat-'
            'averaged per-hour figure that is entirely separate from the 消費電力 '
            'nameplate: a 510 W nameplate unit measures ~170 Wh/h, a 3x gap. 0.15 sits '
            'inside the 強 cluster of 145-180 Wh/h across four manufacturer-grade '
            'sources. Never the 300-600 W nameplate. Heated carpets (電気カーペット) '
            'are NOT this entry: a carpet was closed as a deliberate non-entry at '
            '~0.33 kWh/h on 中, over twice this figure, so logging one here would '
            'understate it by about 2.2x (RESEARCH_ENERGY_ARCHIVE section 1). '
            'RESEARCH_ENERGY section 3.3.'),
 dict(id='electric_blanket', group='space_heat', carrier='electricity', unit='hour',
      kwh=0.025, en='Electric blanket', ja='電気毛布', es='Manta eléctrica',
      conf='medium', presets=EVENING_4H, sources=[ENECHANGE],
      notes='Per-setting measured figures for a single-size Yamazen blanket. Another '
            'cycling appliance whose nameplate is never the shipped value. Ships the '
            '適温 22 Wh/h setting rounded up, not the 弱 13 Wh/h the quote also lists. '
            'RESEARCH_ENERGY section 3.3.'),
 dict(id='aircon_cooling', group='space_cool', carrier='electricity', unit='hour',
      kwh=0.167679, en='Air conditioner, cooling (28 C)', ja='エアコン冷房（28℃）',
      es='Aire acondicionado, refrigeración (28 °C)', conf='high',
      presets=[P('hour_28c', '1 hour at 28 C', '28℃で1時間', '1 hora a 28 °C', 1.0),
               P('hour_27c', '1 hour at 27 C', '27℃で1時間', '1 hora a 27 °C', 1.17891),
               P('hour_26c', '1 hour at 26 C', '26℃で1時間', '1 hora a 26 °C', 1.35783),
               P('evening_26c', 'An evening (4 h at 26 C)', '夜に26℃で4時間',
                 'Una tarde (4 h a 26 °C)', 5.43132)],
      sources=[METI_AC_COOL],
      notes='METI publishes 18.78 kWh/year saved by shortening cooling one hour a day '
            'at a 28 C setpoint, sourced to 省エネルギーセンター実測値; over the 112-day '
            '冷房期間 that is 0.167679 kWh/h. MEASURED, not rated: the Panasonic JIS '
            'rating is 435 W, about 2.6x higher. Setpoint presets use METI absolute '
            'deltas (+0.030 kWh/h per 1 C), capped at -2 C. '
            'RESEARCH_ENERGY section 3.3.'),
 dict(id='fan', group='space_cool', carrier='electricity', unit='hour',
      kwh=0.022, en='Electric fan', ja='扇風機',
      es='Ventilador', conf='medium',
      presets=[P('one_hour', '1 hour', '1時間', '1 hora', 1.0),
               P('evening_4h', 'An evening (4 h)', '夜に4時間',
                 'Una tarde (4 h)', 4.0)],
      sources=[PANA_FAN],
      notes='Panasonic F-CV339 DC living fan at its highest notch (22 W), the same '
            'basis as the use_fan_instead_of_ac action so the calculator and the '
            'action library cannot disagree. A fan at a fixed notch draws constant '
            'power, so the nameplate-vs-cycling rule does not bind; the highest '
            'notch is the conservative direction for the fan-vs-aircon lesson. '
            'RESEARCH_ENERGY section 3.3.'),
 # ---- boil ----
 dict(id='kettle', group='boil', carrier='electricity', unit='use',
      kwh=0.116278, en='Electric kettle, 1 L', ja='電気ケトル（1L）',
      es='Hervidor eléctrico, 1 L', conf='medium_high', presets=BOIL_PRESETS,
      sources=[KETTLE],
      notes='Physics floor for boiling 1 L from 15 C is 0.09883611 kWh (1 kg x 4.186 '
            'kJ/kg-K x 85 K); divided by a kettle efficiency of 0.85. Metered '
            'cross-check in the same paper: 1.50 L from 18 C consumed 0.17 kWh = '
            '0.113 kWh/L. RESEARCH_ENERGY section 3.4.'),
 dict(id='ih_hob', group='boil', carrier='electricity', unit='use',
      kwh=0.116598, en='Induction hob, boil 1 L', ja='IHクッキングヒーター（1L沸かす）',
      es='Placa de inducción, hervir 1 L', conf='medium_high', presets=BOIL_PRESETS,
      sources=[FRONTIER_IH],
      notes='The same 0.09883611 kWh floor divided by 0.847667, the mean of three '
            'induction cooktops measured to ASTM F1521. Within 0.3% of the kettle, '
            'which is the point: this is a tie, and the app says so. '
            'RESEARCH_ENERGY section 3.4.'),
 dict(id='gas_hob', group='boil', carrier='gas', unit='use',
      kwh=0.282389, en='Gas hob, boil 1 L', ja='ガスコンロ（1L沸かす）',
      es='Placa de gas, hervir 1 L', conf='medium', presets=BOIL_PRESETS,
      sources=[FRONTIER_GAS],
      notes='The same 0.09883611 kWh floor divided by 0.35. That efficiency is a '
            'physical spread, not measurement noise: 31.9% for an oversized US burner '
            'in an ASTM lab test, 38-42% for right-sized home measurements with a lid. '
            '0.35 is the chosen midpoint. RESEARCH_ENERGY section 3.4.'),
 # ---- cook ----
 dict(id='oven', group='cook', carrier='electricity', unit='use',
      kwh=0.82, en='Electric oven, 1 bake', ja='電気オーブン（1回）',
      es='Horno eléctrico, 1 horneado', conf='medium',
      presets=[P('one_bake', '1 bake', '1回焼く', '1 horneado', 1),
               P('two_bakes', '2 bakes', '2回焼く', '2 horneados', 2)],
      sources=[EU_OVEN],
      notes='PER BAKE CYCLE, not per hour, and that is structural rather than a gap: '
            'DOE never adopted an active-mode oven standard and ENERGY STAR does not '
            'certify ovens, both citing use-pattern variability, so no per-hour figure '
            'exists anywhere. Do not "fix" it to an hourly unit. From the EU '
            'formula at 60-70 L cavities (0.802-0.844), shipping the 0.82 '
            'midpoint. Lowest confidence of the cooking entries: it is an '
            'EU-to-US proxy. '
            'RESEARCH_ENERGY section 3.4.'),
 dict(id='microwave', group='cook', carrier='electricity', unit='minute',
      kwh=0.019, en='Microwave', ja='電子レンジ', es='Microondas', conf='medium',
      presets=[P('two_min', '2 minutes', '2分', '2 minutos', 2),
               P('ten_min', '10 minutes', '10分', '10 minutos', 10)],
      sources=[],
      notes='The advertised wattage of a microwave is OUTPUT, not draw. A 700 W-output '
            'unit at 60% conversion efficiency draws 1167 W, so 10 minutes is 0.1944 '
            'kWh and one minute is 0.019. The 50-64% efficiency range behind this is '
            'aggregator-sourced rather than a primary, which is why this entry carries '
            'no citation and is the weakest term in any oven-vs-microwave comparison. '
            'RESEARCH_ENERGY section 3.4.'),
 dict(id='rice_cooker', group='cook', carrier='electricity', unit='use',
      kwh=0.16, en='Rice cooker, one cycle', ja='炊飯器（1回炊飯）',
      es='Arrocera, un ciclo', conf='high',
      presets=[P('one_cycle', '1 cycle (5.5 go)', '1回（5.5合）', '1 ciclo (5,5 go)', 1)],
      sources=[RICE],
      notes='158 Wh per cook cycle for an IH 5.5-8合 machine, sourced to '
            '省エネルギーセンター実測値 and corroborated by Tiger at 163 Wh, two '
            'independent JP sources within 3%. RESEARCH_ENERGY section 3.4.'),
 dict(id='rice_cook_keepwarm', group='cook', carrier='electricity', unit='use',
      kwh=0.226, en='Rice cooker, cycle + 4 h keeping warm',
      ja='炊飯器（1回炊飯＋4時間保温）',
      es='Arrocera, ciclo + 4 h manteniendo caliente', conf='high',
      presets=[P('cycle_plus_four', '1 cycle + 4 h keeping warm',
                 '1回炊飯＋4時間保温', '1 ciclo + 4 h manteniendo caliente', 1)],
      sources=[RICE],
      notes='0.16 kWh for the cycle (the rice_cooker row: 158 Wh measured, 163 Wh '
            'corroborated) plus 4 x 16.5 Wh/h keeping warm = 0.226 kWh, all on the '
            'same measured basis. Ships as one figure because keeping warm never '
            'happens without a cycle first (owner call 2026-09-02): held alone it '
            'ranked below the cycle and read as though holding rice were the cheaper '
            'option, which is not a choice anyone has. The 4 hours is the guideline '
            'the source states -- past about 4 hours reheating in a microwave uses '
            'less than holding, and past 7-8 hours cooking twice does. '
            'RESEARCH_ENERGY section 3.4.'),
 # ---- lighting ----
 dict(id='led_bulb', group='lighting', carrier='electricity', unit='hour',
      kwh=0.0085, en='LED bulb (800 lm)', ja='LED電球（800lm）',
      es='Bombilla LED (800 lm)', conf='high',
      presets=ONE_HOUR + [EVENING_5H],
      sources=[],
      notes='NO CITATION SHIPS, on purpose: the primary is the Philips A19 spec '
            'quoted verbatim in RESEARCH_ENERGY section 3.5 ("Wattage: 8.5 Watts" / '
            '"Lumen Output: 800 Lumens"), and that pass did not capture its URL, so '
            'nothing citable exists to attach. Re-source before treating this as '
            'traceable. An 8.5 W lamp at 800 lm is the smallest per-hour entry and '
            'the scale anchor the heat entries are read against. '
            'RESEARCH_ENERGY section 3.5.'),
 dict(id='incandescent_bulb', group='lighting', carrier='electricity', unit='hour',
      kwh=0.06, en='Incandescent bulb (60 W)', ja='白熱電球（60W）',
      es='Bombilla incandescente (60 W)', conf='high',
      presets=ONE_HOUR + [EVENING_5H],
      sources=[],
      notes='NO CITATION SHIPS, same reason as the LED entry: no URL was captured '
            'for the lighting primary in RESEARCH_ENERGY section 3.5. '
            'The 60 W incandescent at ~800 lm is the definitional comparator for the '
            'LED, a 7.06x ratio. Japan never legally banned incandescents, so a '
            'blanket "phased out" claim is false for a JP reader. '
            'RESEARCH_ENERGY section 3.5.'),
 # ---- device ----
 dict(id='tv', group='device', carrier='electricity', unit='hour',
      kwh=0.079096, en='Television (50 inch)', ja='テレビ（50V型）',
      es='Televisor (50 pulgadas)', conf='high',
      presets=ONE_HOUR + [EVENING_3H],
      sources=[METI_TV],
      notes='28.87 kWh/year for one hour a day, sourced to 省エネルギーセンター実測値; '
            'TVs run year-round so that is 0.079096 kWh/h, about 79 W for a 50V型 set. '
            'RESEARCH_ENERGY section 3.5.'),
 dict(id='phone_charge', group='device', carrier='electricity', unit='use',
      kwh=0.015271, en='Phone charge', ja='スマートフォンの充電',
      es='Carga de teléfono', conf='medium',
      presets=[P('one_charge', '1 full charge', '1回フル充電', '1 carga completa', 1)],
      sources=[IFIXIT],
      notes='A 12.98 Wh iPhone 15 battery at 85% charging efficiency. About 7 g CO2e '
            'per charge: small loads are never rounded up, because the honest '
            'smallness is why this entry ships. RESEARCH_ENERGY section 3.5.'),
 dict(id='laptop_charge', group='device', carrier='electricity', unit='use',
      kwh=0.063294, en='Laptop charge', ja='ノートパソコンの充電',
      es='Carga del portátil', conf='medium',
      presets=[P('one_charge', '1 full charge', '1回フル充電', '1 carga completa', 1)],
      sources=[],
      notes='A 53.8 Wh MacBook Air battery at 85% charging efficiency. Sourced '
            'from the manufacturer spec quoted verbatim in RESEARCH_ENERGY '
            'section 3.5, whose '
            'URL that research pass did not capture, so no citation is attached here '
            'rather than attaching an unverified one. Distinct from a laptop RUNNING, '
            'which METI measures at about 15 W.'),
 dict(id='standby', group='device', carrier='electricity', unit='day',
      kwh=0.8, en='Household standby', ja='待機電力（家全体）',
      es='Consumo en espera del hogar', conf='low',
      presets=[P('one_day', '1 day', '1日', '1 día', 1)],
      sources=[LBNL],
      notes='25-40 always-on devices at about 1 W. Against a US home at ~29 kWh/day '
            'that is ~2.8%, below LBNL own 5-10% band, so the shipped value is '
            'deliberately conservative. The honest framing, which the copy must keep: '
            'per-device standby collapsed from 1-3 W to about 0.5 W while device '
            'counts rose faster, leaving roughly the same household total '
            'spread over many more products. Not "standby is trivial" and not '
            '"standby is 10% of your bill". Excludes builder-installed '
            'always-on load (smoke alarms, '
            'thermostats, security) that a user cannot unplug. '
            'RESEARCH_ENERGY section 3.5.'),
]


def build():
    return {
        'metadata': {
            'version': 1,
            'scope': (
                'Operational energy only: the kWh a behaviour consumes at the point of '
                'use, multiplied by a carrier factor. Generation-basis electricity '
                'with no well-to-tank term, and combustion-only gas, matching the '
                'transport dataset scope. Excludes appliance manufacturing, '
                'transmission and distribution losses, and water supply and treatment '
                'energy. One global grid factor for every user; per-country factors '
                'were considered and not shipped (decision E1). Whether a T&D '
                'correction is warranted is an open question rather than a settled '
                'exclusion (Plan/PDR_GRID_REGIONALISATION.md section 4.6). Nearly '
                'every comparison here is within one carrier, where the grid factor '
                'cancels out entirely. NEVER sum a figure from this calculator with '
                'one from the food or transport calculators: food counts a lifecycle, '
                'transport counts tailpipe energy, and this counts the electricity or '
                'gas to run a home.'
            ),
            'grid_factor_g_per_kwh': 458,
            'grid_factor_source': (
                'Ember, Global Electricity Review 2026 (2025 world average, CO2e). '
                'Shared with data/app/transport_modes.json and pinned by a '
                'cross-dataset test. Decision E1, 2026-08-02.'
            ),
            'gas_factor_g_per_kwh': 182,
            'gas_factor_source': (
                'DEFRA/DESNZ 2026 natural gas, Scope 1 combustion, Gross CV (0.18231 '
                'rounded down). Independently corroborated by 資源エネルギー庁 at 179.5 '
                'g CO2/kWh, 1.4% apart. Decision E2.'
            ),
            'verdict_min_percent': 20,
            'unit_note': (
                'kwh_per_unit is per stated unit: minute, hour, use or day. Values are '
                'stored unrounded and rounded only for display.'
            ),
            'awards_note': (
                'This calculator awards no points and logs no CO2 savings. Energy is a '
                'teaching tool, not a decision tool that generates actions: a shorter '
                'shower has no verifiable counterfactual, and the action library '
                'already covers the same behaviours. Decision 8.18, permanent, not '
                'deferred.'
            ),
            'research_doc': 'Plan/RESEARCH_ENERGY.md',
            'decisions_doc': 'Plan/PDR_ENERGY_CALCULATOR.md',
        },
        'behaviors': [
            {
                'id': b['id'],
                'comparable_group': b['group'],
                'carrier': b['carrier'],
                'unit': b['unit'],
                'kwh_per_unit': b['kwh'],
                'name_en': b['en'],
                'name_ja': b['ja'],
                'name_es': b['es'],
                'confidence': b['conf'],
                'presets': b['presets'],
                'default_preset_id': b['presets'][0]['id'],
                'calculation_notes': b['notes'],
                'sources': b['sources'],
            }
            for b in BEHAVIORS
        ],
    }


def validate(out):
    """Guard the shipped asset. Never assert: -O would strip it."""
    behaviors = out['behaviors']
    if len(behaviors) != EXPECTED_BEHAVIORS:
        sys.exit(f'{len(behaviors)} behaviors, expected '
                 f'{EXPECTED_BEHAVIORS}: move EXPECTED_BEHAVIORS and '
                 f'ENERGY_BEHAVIOR_COUNT in energy_behaviors_data.dart '
                 f'together, or the asset and the app disagree')
    counts = collections.Counter(b['id'] for b in behaviors)
    duplicates = sorted(i for i, n in counts.items() if n > 1)
    if duplicates:
        sys.exit('duplicate behavior id: ' + ', '.join(duplicates))


def main():
    out = build()
    # Validate before writing: a half-right asset on disk plus a
    # non-zero exit is worse than no write at all.
    validate(out)
    with open(PATH, 'w', encoding='utf-8') as f:
        f.write(json.dumps(out, indent=2, ensure_ascii=False) + '\n')
    groups = collections.Counter(
        b['comparable_group'] for b in out['behaviors']
    )
    print(f'wrote {PATH}: {len(out["behaviors"])} behaviors')
    print('groups:', dict(groups))


if __name__ == '__main__':
    main()
