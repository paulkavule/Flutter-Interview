import 'package:flutter/material.dart';

import '../cart/cart_scope.dart';
import '../data/product.dart';
import '../data/products.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            tooltip: 'Cart',
            icon: Badge.count(
              count: cart.itemCount,
              isLabelVisible: cart.itemCount > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) {
          final product = sampleProducts[index];
          final inCart = cart.quantityOf(product.id);
          final stockText = product.availableStock == 0
              ? 'Out of stock'
              : 'In stock: ${product.availableStock}';
          return ListTile(
            title: Text(product.name),
            subtitle: Text(
              '${formatPrice(product.priceInMinorUnits)} - $stockText'
              '${inCart > 0 ? ' - In cart: $inCart' : ''}',
            ),
            trailing: IconButton(
              tooltip: 'Add ${product.name} to cart',
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: cart.canAdd(product) ? () => cart.add(product) : null,
            ),
          );
        },
      ),
    );
  }
}
