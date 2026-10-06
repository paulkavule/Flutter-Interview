import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'cart_controller.dart';
import 'product.dart';
import 'product_list_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.cart});

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text('Cart (${cart.itemCount})'),
          actions: [
            if (!cart.isEmpty)
              TextButton(onPressed: cart.clear, child: const Text('Clear')),
          ],
        ),
        body: cart.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(color: AppColors.muted),
                ),
              )
            : ListView.separated(
                itemCount: cart.lines.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final line = cart.lines[i];
                  return ListTile(
                    title: Text(line.product.name),
                    subtitle: Text(
                      '${formatMoney(line.product.priceInMinorUnits)} × ${line.quantity}'
                      ' = ${formatMoney(line.subtotalInMinorUnits)}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    trailing: QuantityStepper(
                      cart: cart,
                      product: line.product,
                    ),
                  );
                },
              ),
        bottomNavigationBar: cart.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 18)),
                      const Spacer(),
                      Text(
                        formatMoney(cart.totalInMinorUnits),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
