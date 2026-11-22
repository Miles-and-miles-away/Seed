import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/app/startup_error_app.dart';

void main() {
  testWidgets('tells the user to reopen the app', (tester) async {
    await tester.pumpWidget(const StartupErrorApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Seed could not start. Close the app and open it again.'),
      findsOneWidget,
    );
  });
}
