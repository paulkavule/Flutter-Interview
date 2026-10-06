import 'package:flutter/material.dart';

import 'cart/cart_controller.dart';
import 'cart/product_list_screen.dart';
import 'core/app_theme.dart';

/// Question 4 entry point: `flutter run -t lib/main_cart.dart`.
void main() => runApp(CartApp());

class CartApp extends StatelessWidget {
  CartApp({super.key, CartController? cart}) : cart = cart ?? CartController();

  final CartController cart;

  static final _theme = buildAppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: ProductListScreen(cart: cart),
    );
  }
}
