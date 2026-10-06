import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/product.dart';
import '../data/products.dart';
import '../state/cart_model.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [_CartButton()],
      ),
      body: ListView.builder(
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) =>
            _ProductTile(product: sampleProducts[index]),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    final itemCount = context.select<CartModel, int>((cart) => cart.itemCount);

    return IconButton(
      tooltip: 'Cart',
      icon: Badge(
        isLabelVisible: itemCount > 0,
        label: Text('$itemCount'),
        child: const Icon(Icons.shopping_cart),
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CartScreen()),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final quantity =
        context.select<CartModel, int>((cart) => cart.quantityOf(product));
    final canAdd =
        context.select<CartModel, bool>((cart) => cart.canIncrement(product));
    final outOfStock = product.availableStock == 0;

    return ListTile(
      title: Text(product.name),
      subtitle: Text(
        '${formatPrice(product.priceInMinorUnits)} - '
        '${outOfStock ? 'Out of stock' : 'In stock: ${product.availableStock}'}'
        '${quantity > 0 ? ' - In cart: $quantity' : ''}',
      ),
      trailing: IconButton(
        tooltip: outOfStock
            ? 'Out of stock'
            : canAdd
                ? 'Add to cart'
                : 'Maximum quantity in cart',
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: canAdd ? () => context.read<CartModel>().add(product) : null,
      ),
    );
  }
}
