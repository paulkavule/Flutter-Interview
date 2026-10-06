import 'package:flutter/material.dart';

import '../data/product.dart';
import 'cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) => TextButton(
              onPressed: cart.isEmpty ? null : cart.clear,
              child: const Text('Clear'),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final items = cart.items;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item.product;

                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        '${formatPrice(product.priceInMinorUnits)} x ${item.quantity}'
                        ' = ${formatPrice(item.totalInMinorUnits)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => cart.decrement(product),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            onPressed: () => cart.add(product),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () => cart.remove(product),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('Items: ${cart.itemCount}'),
                    const Spacer(),
                    Text('Total: ${formatPrice(cart.totalInMinorUnits)}'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
