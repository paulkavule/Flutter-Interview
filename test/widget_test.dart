// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:dart_function/main.dart';

void main() {
  testWidgets('registration is accessible from Home and supports business',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Input (4)'), findsOneWidget);
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Business name'), findsNothing);

    await tester.tap(find.text('Business'));
    await tester.pump();

    expect(find.text('Business name'), findsOneWidget);
  });

  testWidgets('products can be added to and removed from the cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Pour-over set to cart'));
    await tester.pump();
    expect(find.text('1 in cart'), findsOneWidget);

    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart'), findsOneWidget);
    expect(find.text('\$38.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove one Pour-over set'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);
  });
}
