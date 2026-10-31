import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the BudouX licence reaches the licences page', () async {
    registerBundledLicences();
    final budoux = await LicenseRegistry.licenses
        .where((entry) => entry.packages.contains('BudouX'))
        .first;
    final text = budoux.paragraphs.map((p) => p.text).join('\n');
    expect(text, contains('Copyright 2021 Google LLC'));
    expect(text, contains('Apache License'));
  });
}
