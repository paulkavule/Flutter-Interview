import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/product.dart';
import '../state/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty
          ? const _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.lines.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        _CartLineTile(line: cart.lines[index]),
                  ),
                ),
                _CartSummary(cart: cart),
              ],
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove_shopping_cart_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('Your cart is empty', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartModel>();
    final product = line.product;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${formatPrice(product.priceInMinorUnits)} x ${line.quantity}'
                  ' = ${formatPrice(line.totalInMinorUnits)}',
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Decrease quantity',
            icon: const Icon(Icons.remove),
            onPressed: cart.canDecrement(product)
                ? () => cart.decrement(product)
                : null,
          ),
          Text('${line.quantity}'),
          IconButton(
            tooltip: 'Increase quantity',
            icon: const Icon(Icons.add),
            onPressed:
                cart.canIncrement(product) ? () => cart.add(product) : null,
          ),
          IconButton(
            tooltip: 'Remove',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => cart.remove(product),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Subtotal',
                value: formatPrice(cart.subtotalInMinorUnits),
              ),
              _SummaryRow(
                label: 'Discount (${CartModel.discountPercent}%)',
                value: '-${formatPrice(cart.discountInMinorUnits)}',
              ),
              const Divider(),
              _SummaryRow(
                label: 'Total',
                value: formatPrice(cart.totalInMinorUnits),
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.style});

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
