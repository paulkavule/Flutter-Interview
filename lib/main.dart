import 'package:flutter/material.dart';

import 'cart/cart_model.dart';
import 'cart/product_list_screen.dart';
import 'data/product_repository.dart';

void main() {
  runApp(MyApp(repository: ProductRepository()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cart = CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My E-Shop',
      home: ProductListScreen(repository: widget.repository, cart: _cart),
    );
  }
}
