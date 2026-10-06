import 'package:flutter/material.dart';

/// Scaffolding only. Implement the cart behaviour described in README.md.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Center(child: Text('TODO: cart lines and totals')),
    );
  }
}
