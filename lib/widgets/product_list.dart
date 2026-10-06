import 'package:flutter/material.dart';

import '../data/product.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          key: ValueKey(product.id),
          title: Text(product.name),
          trailing: Text(formatPrice(product.priceInMinorUnits)),
        );
      },
    );
  }
}
