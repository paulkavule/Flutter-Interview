import 'package:flutter/material.dart';

import 'screens/product_list_screen.dart';

void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ProductListScreen(),
    );
  }
}
