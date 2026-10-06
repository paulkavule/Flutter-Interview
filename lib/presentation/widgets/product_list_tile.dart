import 'package:flutter/material.dart';

import '../../data/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        product.name,
        style: theme.textTheme.titleMedium,
      ),
      trailing: Text(
        '\$${formatPrice(product.priceInMinorUnits)}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
