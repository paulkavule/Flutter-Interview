import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/main.dart';

void main() {
  Finder addButton(String name) => find.ancestor(
    of: find.byTooltip('Add $name to cart'),
    matching: find.byType(IconButton),
  );

  String badgeText(WidgetTester tester) {
    final badge = tester.widget<Badge>(find.byType(Badge));
    return badge.isLabelVisible ? (badge.label! as Text).data! : '';
  }

  testWidgets('badge, cart screen and totals stay in sync', (tester) async {
    await tester.pumpWidget(const ShoppingCartApp());
    expect(badgeText(tester), '');

    // Out-of-stock item is disabled.
    final stand = tester.widget<IconButton>(addButton('Laptop Stand'));
    expect(stand.onPressed, isNull);

    await tester.tap(addButton('Wireless Mouse'));
    await tester.tap(addButton('Wireless Mouse'));
    await tester.tap(addButton('Mechanical Keyboard'));
    await tester.pump();
    expect(badgeText(tester), '3');

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('24.99 x 2 = 49.98'), findsOneWidget);
    expect(find.text('139.97'), findsOneWidget); // subtotal
    expect(find.text('-14.00'), findsOneWidget); // discount
    expect(find.text('125.97'), findsOneWidget); // total

    await tester.tap(find.byTooltip('Decrease Wireless Mouse'));
    await tester.pump();
    expect(find.text('24.99 x 1 = 24.99'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Mechanical Keyboard'));
    await tester.pump();
    expect(find.text('Mechanical Keyboard'), findsNothing);

    // Cart persists across navigation and the badge reflects edits.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(badgeText(tester), '1');

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove Wireless Mouse'));
    await tester.pump();
    expect(find.text('Your cart is empty.'), findsOneWidget);
  });

  testWidgets('add button disables once stock is reached', (tester) async {
    await tester.pumpWidget(const ShoppingCartApp());
    await tester.tap(addButton('Headphones')); // stock 1
    await tester.pump();
    expect(
      tester.widget<IconButton>(addButton('Headphones')).onPressed,
      isNull,
    );
    expect(find.textContaining('In cart: 1'), findsOneWidget);
  });
}
