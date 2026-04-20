import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      );

  testWidgets('renders label text', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        AuthTextField(controller: controller, label: 'Email'),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('typed text lands in the controller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        AuthTextField(controller: controller, label: 'Email'),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'hello@x.com');

    expect(controller.text, 'hello@x.com');
  });

  testWidgets('obscureText hides typed characters', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        AuthTextField(
          controller: controller,
          label: 'Password',
          obscureText: true,
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'secret');

    // The EditableText underneath must be in obscured mode.
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.obscureText, isTrue);
    // But the controller still holds the real characters.
    expect(controller.text, 'secret');
  });

  testWidgets('prefixIcon renders when provided', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        AuthTextField(
          controller: controller,
          label: 'Email',
          prefixIcon: Icons.email,
        ),
      ),
    );

    expect(find.byIcon(Icons.email), findsOneWidget);
  });

  testWidgets('validator error appears on invalid submit', (tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        Form(
          key: formKey,
          child: AuthTextField(
            controller: controller,
            label: 'Email',
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('onFieldSubmitted fires on IME submit', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    String? submitted;

    await tester.pumpWidget(
      wrap(
        AuthTextField(
          controller: controller,
          label: 'Email',
          onFieldSubmitted: (v) => submitted = v,
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'done');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    expect(submitted, 'done');
  });
}
