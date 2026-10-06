import 'package:flutter/material.dart';

import '../data/product.dart';
import '../data/products.dart';
import 'cart_screen.dart';

/// Scaffolding only. Implement the cart behaviour described in README.md.
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            // TODO: show the cart badge.
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) {
          final product = sampleProducts[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(
              '${formatPrice(product.priceInMinorUnits)} - '
              'In stock: ${product.availableStock}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                // TODO: add to cart.
              },
            ),
          );
        },
      ),
    );
  }
}
