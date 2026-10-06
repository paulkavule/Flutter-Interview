import 'package:flutter/material.dart';

import '../cart/cart.dart';
import '../cart/cart_scope.dart';
import '../data/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (final line in cart.lines)
                        _CartLineTile(cart: cart, line: line),
                    ],
                  ),
                ),
                _Totals(cart: cart),
              ],
            ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.cart, required this.line});

  final Cart cart;
  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final product = line.product;
    return ListTile(
      title: Text(product.name),
      subtitle: Text(
        '${formatPrice(product.priceInMinorUnits)} x ${line.quantity} = '
        '${formatPrice(line.lineTotalInMinorUnits)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Decrease ${product.name}',
            icon: const Icon(Icons.remove),
            onPressed: cart.canDecrement(product.id)
                ? () => cart.decrement(product.id)
                : null,
          ),
          Text('${line.quantity}'),
          IconButton(
            tooltip: 'Increase ${product.name}',
            icon: const Icon(Icons.add),
            onPressed: cart.canIncrement(product.id)
                ? () => cart.increment(product.id)
                : null,
          ),
          IconButton(
            tooltip: 'Remove ${product.name}',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => cart.remove(product.id),
          ),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row('Subtotal', formatPrice(cart.subtotalInMinorUnits)),
            _row(
              'Discount (${Cart.discountPercent}%)',
              '-${formatPrice(cart.discountInMinorUnits)}',
            ),
            const Divider(),
            _row(
              'Total',
              formatPrice(cart.totalInMinorUnits),
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? style}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    ),
  );
}
