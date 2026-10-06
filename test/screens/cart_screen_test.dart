import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/screens/cart_screen.dart';
import 'package:shopping_cart/state/cart_model.dart';

void main() {
  testWidgets('shows empty cart message', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    expect(find.text('Your cart is empty'), findsOneWidget);
  });
}
