import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'cart_controller.dart';
import 'cart_screen.dart';
import 'product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    super.key,
    required this.cart,
    this.products = sampleProducts,
  });

  final CartController cart;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            IconButton(
              tooltip: 'Cart',
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => CartScreen(cart: cart))),
              icon: Badge.count(
                count: cart.itemCount,
                isLabelVisible: cart.itemCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _productTile(products[i]),
        ),
      ),
    );
  }

  Widget _productTile(Product product) {
    final inCart = cart.quantityOf(product);
    final left = product.availableStock - inCart;
    return ListTile(
      title: Text(product.name),
      subtitle: Text(
        product.availableStock == 0
            ? 'Out of stock'
            : '${formatMoney(product.priceInMinorUnits)} · $left left',
        style: TextStyle(
          color: product.availableStock == 0
              ? AppColors.danger
              : AppColors.muted,
        ),
      ),
      trailing: inCart == 0
          ? TextButton(
              onPressed: cart.canAdd(product) ? () => cart.add(product) : null,
              child: const Text('Add'),
            )
          : QuantityStepper(cart: cart, product: product),
    );
  }
}

/// − quantity + control, shared by both screens.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({super.key, required this.cart, required this.product});

  final CartController cart;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Remove one',
          icon: const Icon(Icons.remove),
          onPressed: () => cart.decrement(product),
        ),
        Text('${cart.quantityOf(product)}'),
        IconButton(
          tooltip: 'Add one',
          icon: const Icon(Icons.add),
          onPressed: cart.canAdd(product) ? () => cart.add(product) : null,
        ),
      ],
    );
  }
}
