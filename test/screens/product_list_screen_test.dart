import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/main.dart';

void main() {
  testWidgets('badge shows cart count', (tester) async {
    await tester.pumpWidget(const ShoppingCartApp());

    await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
    await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
  });
}
