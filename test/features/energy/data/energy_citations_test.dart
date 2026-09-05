import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Exact pins for every citation in the dataset (Phase 8.13).
///
/// The value pins in energy_exact_values_test.dart make a changed number
/// a deliberate two-file edit. This does the same for provenance, which
/// is the half that actually went wrong during the build: two separate
/// citation defects shipped and neither was detectable by any test.
///
///  - All three wash entries carried the 60 C table row, so the 0.350
///    and 1.300 figures were each "evidenced" by a row reading 1,700.
///  - The two lighting entries carried citations borrowed from
///    data/seed/co2_actions_database.json with their access date
///    rewritten, asserting a verification that never happened.
///
/// A mutation pass confirmed both classes were invisible: swapping
/// wash_cold's quote for the 60 C row, and replacing the oven's formula
/// with an invented one, both left the suite green.
///
/// So every (behavior, source name, url, quote) tuple is pinned here.
/// The file is deliberately dumb -- it is a copy of the dataset's
/// provenance, and its whole job is to make any change to a citation
/// deliberate. When one legitimately changes, re-derive it from
/// RESEARCH_ENERGY.md sections 1 and 3 and update it in both places.
/// If no citable primary exists, ship `sources: []` and say so in the
/// entry's calculation_notes -- never borrow one from elsewhere.
///
/// The over-length lines below are verbatim quotes and URLs: wrapping
/// or trimming one to fit 88 columns would break the pin it exists for.
void main() {
  late List<(String, String, String, String)> actual;

  setUpAll(() {
    final root =
        json.decode(File('data/app/energy_behaviors.json').readAsStringSync())
            as Map<String, dynamic>;
    actual = [
      for (final b
          in (root['behaviors'] as List<dynamic>).cast<Map<String, dynamic>>())
        for (final s
            in (b['sources'] as List<dynamic>).cast<Map<String, dynamic>>())
          (
            b['id'] as String,
            s['name'] as String,
            s['url'] as String,
            s['quote'] as String,
          ),
    ];
  });

  test('every citation ships exactly as researched', () {
    const expected = <(String, String, String, String)>[
      (
        'shower_electric',
        'US EPA WaterSense (showerheads)',
        'https://www.epa.gov/watersense/showerheads',
        'Did you know that standard showerheads use 2.5 gallons of water per minute (gpm)? Water-saving showerheads that earn the WaterSense label must demonstrate that they use no more than 2.0 gpm.',
      ),
      (
        'shower_electric',
        'TOTO CSR (shower water use)',
        'https://jp.toto.com/company/csr/csractivity/usefulinformation/use_shower/',
        '現在、TOTOが販売しているコンフォートウェーブシャワーの水量は1分間に6.5Ｌです',
      ),
      (
        'shower_electric',
        'UK SAP 10.1 Appendix J and Table J1',
        'https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf',
        'Table J1: Cold water temperatures (°C)',
      ),
      (
        'shower_heatpump',
        'US EPA WaterSense (showerheads)',
        'https://www.epa.gov/watersense/showerheads',
        'Did you know that standard showerheads use 2.5 gallons of water per minute (gpm)? Water-saving showerheads that earn the WaterSense label must demonstrate that they use no more than 2.0 gpm.',
      ),
      (
        'shower_heatpump',
        'TOTO CSR (shower water use)',
        'https://jp.toto.com/company/csr/csractivity/usefulinformation/use_shower/',
        '現在、TOTOが販売しているコンフォートウェーブシャワーの水量は1分間に6.5Ｌです',
      ),
      (
        'shower_heatpump',
        'UK SAP 10.1 Appendix J and Table J1',
        'https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf',
        'Table J1: Cold water temperatures (°C)',
      ),
      (
        'shower_heatpump',
        'Heat Pump & Thermal Storage Technology Center of Japan',
        'https://www.hptcj.or.jp/e/learning/tabid/370/Default.aspx',
        'Eco Cute has improved its efficiency to COP = 5.1 in the recent model',
      ),
      (
        'shower_gas',
        'US EPA WaterSense (showerheads)',
        'https://www.epa.gov/watersense/showerheads',
        'Did you know that standard showerheads use 2.5 gallons of water per minute (gpm)? Water-saving showerheads that earn the WaterSense label must demonstrate that they use no more than 2.0 gpm.',
      ),
      (
        'shower_gas',
        'TOTO CSR (shower water use)',
        'https://jp.toto.com/company/csr/csractivity/usefulinformation/use_shower/',
        '現在、TOTOが販売しているコンフォートウェーブシャワーの水量は1分間に6.5Ｌです',
      ),
      (
        'shower_gas',
        'UK SAP 10.1 Appendix J and Table J1',
        'https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf',
        'Table J1: Cold water temperatures (°C)',
      ),
      (
        'shower_gas',
        'BRE Technical Paper STP09/B07 (GASTEC-at-CRE tests for DECC)',
        'https://bregroup.com/documents/d/bre-group/stp09-b07_dhw_boiler_tests_2009',
        'ηDHW = heat content of the useful hot water drawn / heat in fuel consumption (net basis)',
      ),
      (
        'bath_electric',
        '東京都水道局',
        'https://www.waterworks.metro.tokyo.lg.jp/kurashi/shiyou/jouzu',
        '残り湯は、使用状態によって異なりますが、一般家庭では、約180リットルの量があります',
      ),
      (
        'bath_electric',
        'UK SAP 10.1 Appendix J and Table J1',
        'https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf',
        'Table J1: Cold water temperatures (°C)',
      ),
      (
        'bath_gas',
        '東京都水道局',
        'https://www.waterworks.metro.tokyo.lg.jp/kurashi/shiyou/jouzu',
        '残り湯は、使用状態によって異なりますが、一般家庭では、約180リットルの量があります',
      ),
      (
        'bath_gas',
        'UK SAP 10.1 Appendix J and Table J1',
        'https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf',
        'Table J1: Cold water temperatures (°C)',
      ),
      (
        'bath_gas',
        'BRE Technical Paper STP09/B07 (GASTEC-at-CRE tests for DECC)',
        'https://bregroup.com/documents/d/bre-group/stp09-b07_dhw_boiler_tests_2009',
        'ηDHW = heat content of the useful hot water drawn / heat in fuel consumption (net basis)',
      ),
      (
        'dishwasher_eco',
        'Bosch SMS67MW00G dishwasher, 14 place settings',
        'https://media3.bosch-home.com/Documents/specsheet/en-GB/SMS67MW00G.pdf',
        'Energy Consumption for 100 cycles Eco Programme: 85 kWh',
      ),
      (
        'dishwasher_normal',
        'Which? UK (dishwasher main wash, 03 Jul 2026)',
        'https://www.which.co.uk/news/article/which-research-reveals-how-little-water-dishwashers-use-compared-to-hand-washing-aUDng9Y2iK8E',
        'around 1.12kWh of energy per wash, which costs roughly 29.2p',
      ),
      (
        'wash_cold',
        'Bosch WNA14400GR, 9 kg, EN50229 programme table',
        'https://media3.bosch-home.com/Documents/9001533128_A.pdf',
        'Βαμβακερά (Cottons) 20 °C | 9,0 | 0,350 | 89,0 | 3:02',
      ),
      (
        'wash_warm',
        'Bosch WNA14400GR, 9 kg, EN50229 programme table',
        'https://media3.bosch-home.com/Documents/9001533128_A.pdf',
        'Βαμβακερά (Cottons) 40 °C | 9,0 | 1,300 | 89,0 | 3:48',
      ),
      (
        'wash_hot',
        'Bosch WNA14400GR, 9 kg, EN50229 programme table',
        'https://media3.bosch-home.com/Documents/9001533128_A.pdf',
        'Βαμβακερά (Cottons) 60 °C | 9,0 | 1,700 | 89,0 | 3:03',
      ),
      (
        'dryer_vented',
        'Bosch WTM8327SZA condenser dryer, 8 kg',
        'https://media3.bosch-home.com/Documents/specsheet/en-ZA/WTM8327SZA.pdf',
        'energy consumption of the standard cotton programme at full load 4.63 kWh and energy consumption of the standard cotton programme at half load 2.61 kWh',
      ),
      (
        'dryer_heatpump',
        'Bosch WQG24509GB heat-pump dryer, 9 kg',
        'https://media3.bosch-home.com/Documents/specsheet/en-GB/WQG24509GB.pdf',
        'Energy consumption electric dryer, full load - NEW (2010/30/EC): 2.05 kWh',
      ),
      (
        'aircon_heating',
        '資源エネルギー庁 省エネポータルサイト (空調)',
        'https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/airconditioning/index.html',
        '暖房を1日1時間短縮した場合（設定温度：20℃）年間で電気40.73kWhの省エネ',
      ),
      (
        'portable_electric_heater',
        'Office of Congressional Workplace Rights (US)',
        'https://www.ocwr.gov/publications/fast-facts/portable-space-heaters/',
        'Average electric space heaters range from 400-1,500 watts.',
      ),
      (
        'kotatsu',
        'メトロ電気工業 (kotatsu 標準平均消費電力量 test method)',
        'https://www.kotatsu.metro-co.com/our-kotatsu/',
        'こたつ：電気代及び標準平均消費電力量は、室温20℃で厚さ約５cmの綿のふとんを使用し、人が入らない状態で５時間運転した時の１時間あたりの平均値です。',
      ),
      (
        'electric_blanket',
        'enechange (Yamazen electric blanket per-setting measurements)',
        'https://enechange.jp/articles/cost-electric-blanket',
        '強（約53度）約35Wh、適温（約33度）約22Wh、弱（約21度）約13Wh',
      ),
      (
        'aircon_cooling',
        '資源エネルギー庁 省エネポータルサイト (空調)',
        'https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/airconditioning/index.html',
        '冷房を1日1時間短縮した場合（設定温度：28℃）年間で電気18.78kWhの省エネ',
      ),
      (
        'fan',
        'Panasonic F-CV339 仕様',
        'https://panasonic.jp/fan/products/F-CV339/spec.html',
        '消費電力 [ノッチ 8(強)] 50/60Hz:22W',
      ),
      (
        'kettle',
        'Murray, Liao, Stankovic & Stankovic (Strathclyde), EEDAL 2015',
        'https://strathprints.strath.ac.uk/55059/1/Murray_etal_EEDAL2015_How_make_efficient_use_kettles_understanding_usage_patterns.pdf',
        'most kettles are around 80-90% efficient (efficiency is decreased due to heat dissipation and transference to the body of the kettle)',
      ),
      (
        'ih_hob',
        'Frontier Energy, Residential Cooktop Performance and Energy Comparison Study, Report #501318071-R0 (July 2019)',
        'https://cao-94612.s3.amazonaws.com/documents/Induction-Range-Final-Report-July-2019.pdf',
        'Three induction cooktops measured 85.20%, 86.10%, 83.00%',
      ),
      (
        'gas_hob',
        'Frontier Energy, Residential Cooktop Performance and Energy Comparison Study, Report #501318071-R0 (July 2019)',
        'https://cao-94612.s3.amazonaws.com/documents/Induction-Range-Final-Report-July-2019.pdf',
        'The efficiency of the gas burner for the 12 pounds of water heat-up test was just 32%',
      ),
      (
        'oven',
        'Commission Regulation (EU) No 66/2014, Annex II (ecodesign requirements for domestic ovens, hobs and range hoods)',
        'https://webgate.ec.europa.eu/reqs2/public/v2/requirement/auxi/eu/32014R0066_energcook_annex_2.pdf',
        'SECelectric cavity = 0,0042 × V + 0,55 (in kWh)',
      ),
      (
        'rice_cooker',
        '一般財団法人 家電製品協会 (省エネルギーセンター実測値)',
        'https://seihinjyoho.go.jp/frontguide/pdf/guide_rice_cooker_2022.pdf?update=22113',
        '炊飯ジャー：IH5.5合以上8合未満平均消費電力量（炊飯時158Wh/回 保温時16.5Wh/h）',
      ),
      (
        'rice_cook_keepwarm',
        '一般財団法人 家電製品協会 (省エネルギーセンター実測値)',
        'https://seihinjyoho.go.jp/frontguide/pdf/guide_rice_cooker_2022.pdf?update=22113',
        '炊飯ジャー：IH5.5合以上8合未満平均消費電力量（炊飯時158Wh/回 保温時16.5Wh/h）',
      ),
      (
        'tv',
        '資源エネルギー庁 省エネポータルサイト (娯楽)',
        'https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/entertainment/index.html',
        '1日1時間テレビ（50V型）を見る時間を減らした場合 年間で電気28.87kWhの省エネ',
      ),
      (
        'phone_charge',
        'iFixit iPhone 15 battery',
        'https://www.ifixit.com/products/iphone-15-battery',
        '12.98 Wh',
      ),
      (
        'standby',
        'Lawrence Berkeley National Laboratory, Standby Power',
        'https://standby.lbl.gov/',
        'Most products draw relatively little standby power – less than 0.5 watts – but they still add up.',
      ),
    ];
    // Compared as an ordered list, so a citation moving between
    // behaviors fails too -- that is precisely the wash-quote bug.
    expect(actual, expected);
  });

  test('every access date ships exactly as researched', () {
    // The header names "borrowed citation with a rewritten access
    // date" as a defect class this file exists to catch, and the date
    // is the field the tuple pin above does not carry. The allowlist in
    // energy_behaviors_data_test.dart bounds the date set; this pins
    // which source carries which date, closing the swap-within-the-
    // allowlist gap.
    final root =
        json.decode(File('data/app/energy_behaviors.json').readAsStringSync())
            as Map<String, dynamic>;
    final dates = {
      for (final b
          in (root['behaviors'] as List<dynamic>).cast<Map<String, dynamic>>())
        for (final s
            in (b['sources'] as List<dynamic>).cast<Map<String, dynamic>>())
          '${b['id']}/${s['name']}': s['accessed'] as String,
    };
    final offBaseline = Map.of(dates)
      ..removeWhere((_, accessed) => accessed == '2026-08-02');
    expect(offBaseline, {
      'oven/Commission Regulation (EU) No 66/2014, Annex II (ecodesign '
              'requirements for domestic ovens, hobs and range hoods)':
          '2026-08-29',
      'fan/Panasonic F-CV339 仕様': '2026-08-30',
    });
  });
}
