import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/product_list_screen.dart';
import 'state/cart_model.dart';

void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        title: 'Shopping Cart',
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        home: const ProductListScreen(),
      ),
    );
  }
}
