import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/presentation/widgets/social_sign_in_button.dart';

void main() {
  Widget wrap(Widget child, {Brightness brightness = Brightness.light}) =>
      MaterialApp(
        theme: ThemeData(brightness: brightness),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('Google variant renders the Google label and icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const SocialSignInButton(provider: SocialProvider.google)),
    );

    expect(find.text('Google'), findsOneWidget);
    expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
  });

  testWidgets('Apple variant renders the Apple label and icon', (tester) async {
    await tester.pumpWidget(
      wrap(const SocialSignInButton(provider: SocialProvider.apple)),
    );

    expect(find.text('Apple'), findsOneWidget);
    expect(find.byIcon(Icons.apple), findsOneWidget);
  });

  testWidgets('onPressed fires when tapped and not loading', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrap(
        SocialSignInButton(
          provider: SocialProvider.google,
          onPressed: () => taps++,
        ),
      ),
    );
    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('isLoading shows a spinner and disables the button', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      wrap(
        SocialSignInButton(
          provider: SocialProvider.google,
          isLoading: true,
          onPressed: () => taps++,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Label should not render in loading mode.
    expect(find.text('Google'), findsNothing);

    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();
    expect(taps, 0);
  });
}
