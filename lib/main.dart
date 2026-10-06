import 'package:flutter/material.dart';

import 'cart/cart.dart';
import 'cart/cart_scope.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatefulWidget {
  const ShoppingCartApp({super.key});

  @override
  State<ShoppingCartApp> createState() => _ShoppingCartAppState();
}

class _ShoppingCartAppState extends State<ShoppingCartApp> {
  final _cart = Cart();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Above MaterialApp so pushed routes share the same cart.
    return CartScope(
      cart: _cart,
      child: MaterialApp(
        title: 'Shopping Cart',
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        home: const ProductListScreen(),
      ),
    );
  }
}
