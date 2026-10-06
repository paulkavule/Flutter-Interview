import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_search/cart/cart_controller.dart';
import 'package:product_search/cart/product.dart';
import 'package:product_search/main_cart.dart';

const mouse = Product(
  id: 1,
  name: 'Mouse',
  priceInMinorUnits: 2499,
  availableStock: 2,
);
const cable = Product(
  id: 2,
  name: 'Cable',
  priceInMinorUnits: 799,
  availableStock: 5,
);
const soldOut = Product(
  id: 3,
  name: 'Stand',
  priceInMinorUnits: 3450,
  availableStock: 0,
);

void main() {
  group('CartController', () {
    test('derives count and total in integer minor units', () {
      final cart = CartController()
        ..add(mouse)
        ..add(mouse)
        ..add(cable);
      expect(cart.itemCount, 3);
      expect(cart.totalInMinorUnits, 2499 * 2 + 799);
    });

    test('never exceeds available stock', () {
      final cart = CartController()
        ..add(mouse)
        ..add(mouse)
        ..add(mouse)
        ..add(soldOut);
      expect(cart.quantityOf(mouse), 2);
      expect(cart.canAdd(mouse), isFalse);
      expect(cart.quantityOf(soldOut), 0);
    });

    test('decrement removes the line at zero; clear empties', () {
      final cart = CartController()
        ..add(mouse)
        ..add(cable)
        ..decrement(mouse);
      expect(cart.lines.map((l) => l.product.id), [cable.id]);
      cart.clear();
      expect(cart.isEmpty, isTrue);
      expect(cart.totalInMinorUnits, 0);
    });
  });

  test('formatMoney pads minor units', () {
    expect(formatMoney(0), '\$0.00');
    expect(formatMoney(805), '\$8.05');
    expect(formatMoney(24900), '\$249.00');
  });

  testWidgets('badge and cart screen share the same state', (tester) async {
    await tester.pumpWidget(CartApp());

    expect(find.text('1'), findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Add').first);
    await tester.pump();
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Cart (1)'), findsOneWidget);
    expect(find.text('\$24.99'), findsOneWidget);

    await tester.tap(find.byTooltip('Add one'));
    await tester.pump();
    expect(find.text('Cart (2)'), findsOneWidget);
    expect(find.text('\$49.98'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pump();
    expect(find.text('Your cart is empty.'), findsOneWidget);
  });
}
