import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_form/main.dart';

void main() {
  testWidgets('shows the registration screen', (tester) async {
    await tester.pumpWidget(const RegistrationApp());
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await tester.pumpWidget(const RegistrationApp());

    EditableText passwordInput = tester.widget(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(EditableText),
      ),
    );
    expect(passwordInput.obscureText, isTrue);
    expect(find.byTooltip('Show password'), findsOneWidget);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();

    passwordInput = tester.widget(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(EditableText),
      ),
    );
    expect(passwordInput.obscureText, isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });
}
